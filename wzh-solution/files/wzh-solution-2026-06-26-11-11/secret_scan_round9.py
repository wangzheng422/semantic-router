#!/usr/bin/env python
import os
import pathlib
import re
import subprocess
import sys


ROOT = pathlib.Path(__file__).resolve().parents[3]
SKIP_DIRS = {"node_modules", ".git", "__pycache__"}
SKIP_SUFFIXES = {
    ".png",
    ".jpg",
    ".jpeg",
    ".gif",
    ".webp",
    ".db",
    ".sqlite",
    ".pyc",
    ".tar",
    ".gz",
    ".tgz",
    ".zip",
}

PATTERNS = [
    ("aws_access_key", re.compile(r"AKIA[0-9A-Z]{16}")),
    ("hf_token", re.compile(r"hf_[A-Za-z0-9]{20,}")),
    ("jwt", re.compile(r"eyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}")),
    ("private_key", re.compile(r"-----BEGIN [A-Z ]*PRIVATE KEY-----")),
    (
        "generic_secret_assignment",
        re.compile(
            r"(?i)\b(password|passwd|secret|api[_-]?key|access[_-]?key|token)\b"
            r"\s*[:=]\s*[\"']?"
            r"(?!\$|\[REDACTED|<|your-|round9-local-test-|search-api-key|args\.|process\.env|dashboardCredential)"
            r"[A-Za-z0-9_./+=:@-]{12,}"
        ),
    ),
]


def changed_paths() -> list[str]:
    raw = subprocess.check_output(["git", "status", "--porcelain", "-z"], cwd=ROOT)
    entries = raw.decode("utf-8", "replace").split("\0")
    paths: list[str] = []
    index = 0
    while index < len(entries):
        entry = entries[index]
        index += 1
        if not entry:
            continue
        code = entry[:2]
        path = entry[3:]
        if code.startswith(("R", "C")) and index < len(entries):
            path = entries[index]
            index += 1
        if path:
            paths.append(path)
    return paths


def iter_files(paths: list[str]):
    for rel in paths:
        candidate = ROOT / rel
        if not candidate.exists():
            continue
        if candidate.is_dir():
            for dirpath, dirnames, filenames in os.walk(candidate):
                dirnames[:] = [name for name in dirnames if name not in SKIP_DIRS]
                for name in filenames:
                    file_path = pathlib.Path(dirpath) / name
                    if file_path.suffix.lower() not in SKIP_SUFFIXES:
                        yield file_path
        elif candidate.suffix.lower() not in SKIP_SUFFIXES:
            if not any(part in SKIP_DIRS for part in candidate.parts):
                yield candidate


def main() -> int:
    files = sorted(set(iter_files(changed_paths())))
    findings = []
    for file_path in files:
        try:
            text = file_path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        for lineno, line in enumerate(text.splitlines(), 1):
            for name, pattern in PATTERNS:
                if pattern.search(line):
                    snippet = pattern.sub("[REDACTED_MATCH]", line.strip())[:220]
                    findings.append((file_path.relative_to(ROOT), lineno, name, snippet))

    print(f"scanned_files={len(files)}")
    print(f"findings={len(findings)}")
    for rel, lineno, name, snippet in findings:
        print(f"{rel}:{lineno}: {name}: {snippet}")
    return 1 if findings else 0


if __name__ == "__main__":
    sys.exit(main())
