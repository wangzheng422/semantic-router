from pathlib import Path
import re
import subprocess


ROOT = Path.cwd()
SKIP_SUFFIXES = {
    ".tgz",
    ".gz",
    ".zip",
    ".png",
    ".jpg",
    ".jpeg",
    ".gif",
    ".webp",
    ".pdf",
    ".bin",
    ".parquet",
}
PATTERNS = [
    ("aws_access_key", re.compile(r"AKIA[0-9A-Z]{16}")),
    ("aws_secret_assignment", re.compile(r"AWS_SECRET_ACCESS_KEY\s*=\s*[^\s\"']+")),
    (
        "private_key",
        re.compile(r"-----BEGIN (?:RSA |OPENSSH |EC |)PRIVATE KEY-----"),
    ),
    ("hf_token_assignment", re.compile(r"HF_TOKEN\s*=\s*[^\s\"']+")),
    ("openai_key_assignment", re.compile(r"OPENAI_API_KEY\s*=\s*[^\s\"']+")),
    ("dashscope_key_assignment", re.compile(r"DASHSCOPE_API_KEY\s*=\s*[^\s\"']+")),
    (
        "literal_password_assignment",
        re.compile(r"(?i)(?:password|passwd|pwd)\s*[:=]\s*[^\s\"'${}][^\s]*"),
    ),
    (
        "literal_token_assignment",
        re.compile(r"(?i)(?:api[_-]?key|token|secret)\s*[:=]\s*[^\s\"'${}][^\s]*"),
    ),
]
ALLOWLIST_FRAGMENTS = (
    "OpenAI(base_url=args.base_url, api_key=args.api_key)",
    "token=<your_token>",
)


def changed_paths() -> list[Path]:
    raw = subprocess.check_output(["git", "status", "--porcelain=v1", "-z"])
    entries = raw.decode("utf-8", errors="replace").split("\0")
    paths: list[Path] = []
    index = 0
    while index < len(entries):
        entry = entries[index]
        index += 1
        if not entry:
            continue
        status = entry[:2]
        path_text = entry[3:]
        if status.startswith(("R", "C")) and index < len(entries):
            path_text = entries[index]
            index += 1
        path = ROOT / path_text
        if path.is_dir():
            paths.extend(child for child in path.rglob("*") if child.is_file())
        elif path.is_file():
            paths.append(path)
    return sorted(set(paths))


def main() -> int:
    findings: list[tuple[str, int, str]] = []
    scanned = 0
    paths = changed_paths()
    for path in paths:
        if path.suffix.lower() in SKIP_SUFFIXES:
            continue
        try:
            data = path.read_bytes()
        except OSError:
            continue
        if b"\0" in data[:4096]:
            continue
        text = data.decode("utf-8", errors="replace")
        scanned += 1
        rel = path.relative_to(ROOT)
        for lineno, line in enumerate(text.splitlines(), 1):
            if any(fragment in line for fragment in ALLOWLIST_FRAGMENTS):
                continue
            for name, pattern in PATTERNS:
                if pattern.search(line):
                    findings.append((str(rel), lineno, name))

    print(f"changed_entries={len(paths)}")
    print(f"text_files_scanned={scanned}")
    print(f"findings={len(findings)}")
    for path, lineno, name in findings:
        print(f"MATCH {path}:{lineno} {name} [value redacted]")
    return 1 if findings else 0


if __name__ == "__main__":
    raise SystemExit(main())
