#!/usr/bin/env python
from pathlib import Path


FEATURES = [
    ("signal", "keywords"),
    ("signal", "embeddings"),
    ("signal", "language"),
    ("signal", "context"),
    ("signal", "structure"),
    ("signal", "role_bindings/authz"),
    ("signal", "jailbreak"),
    ("signal", "pii"),
    ("signal", "user_feedback"),
    ("signal", "reasks"),
    ("signal", "preferences"),
    ("signal", "conversation"),
    ("signal", "events"),
    ("signal", "projections"),
    ("signal", "domains"),
    ("signal", "fact_check"),
    ("signal", "kb"),
    ("signal", "complexity"),
    ("signal", "modality"),
    ("selection", "static"),
    ("selection", "router_dc"),
    ("selection", "automix"),
    ("selection", "hybrid"),
    ("selection", "multi_factor"),
    ("selection", "latency_aware"),
    ("selection", "elo"),
    ("selection", "session_aware"),
    ("selection", "rl_driven"),
    ("selection", "gmtrouter"),
    ("selection", "knn/kmeans/svm/mlp"),
    ("plugin", "semantic-cache"),
    ("plugin", "fast_response"),
    ("plugin", "system_prompt"),
    ("plugin", "header_mutation"),
    ("plugin", "hallucination"),
    ("plugin", "router_replay"),
    ("plugin", "memory"),
    ("plugin", "rag"),
    ("plugin", "tools"),
    ("plugin", "tool_selection"),
    ("plugin", "image_gen"),
    ("plugin", "request_params"),
    ("plugin", "response_jailbreak"),
    ("global", "ratelimit/local-limiter"),
    ("global", "authz/header-injection/static-config"),
    ("global", "response_api"),
    ("global", "looper"),
    ("global", "semantic_cache backends"),
    ("global", "router_replay API/aggregate"),
    ("protocol", "streaming"),
    ("protocol", "Anthropic passthrough"),
    ("protocol", "Responses API"),
    ("routing", "reasoning_family/chat_template_kwargs"),
    ("routing", "model switch gate/session transition"),
    ("routing", "hot reload/watch config"),
]

reports = "\n".join(
    p.read_text(encoding="utf-8", errors="ignore")
    for p in sorted(Path("wzh-solution").glob("wzh-solution-2026.06.25.*.md"))
)
configs = "\n".join(
    p.read_text(encoding="utf-8", errors="ignore")
    for p in sorted(Path("wzh-solution/files").glob("wzh-solution-2026-06-25-*/*"))
    if p.is_file() and p.suffix in {".yaml", ".py", ".txt"}
)
haystack = (reports + "\n" + configs).lower()

print("| Area | Feature | Evidence keyword count | Auto note |")
print("|---|---|---:|---|")
for area, name in FEATURES:
    terms = [name.lower()]
    if "/" in name:
        terms += [part.strip().lower() for part in name.split("/")]
    if "-" in name:
        terms.append(name.replace("-", "_").lower())
    count = sum(haystack.count(t) for t in terms)
    note = "mentioned in prior artifacts" if count else "no prior artifact mention"
    print(f"| {area} | `{name}` | {count} | {note} |")
