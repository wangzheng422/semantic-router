# Semantic Router VM Routing Benchmark

## Goal

Validate semantic-router behavior on a GPU VM with two OpenAI-compatible
Qwen-family vLLM backends: a small model and a larger model. Measure how router
configuration and request content affect backend selection, including
multi-turn conversations where the topic changes, and quantify performance
overhead with guidellm.

## Scope

- Use the VM described by `.wzh/env.txt`.
- Deploy two model backends behind semantic-router.
- Exercise multiple semantic-router configurations that produce observable
  routing differences.
- Generate scenario traffic with a modern OpenAI-compatible client or load
  tool rather than relying on raw curl for the main tests.
- Use guidellm for direct-backend versus semantic-router benchmark comparison.
- Preserve detailed operational evidence under `wzh-steps/` and customer-facing
  conclusions under `wzh-solution/`.

## Non-Goals

- Do not change router behavior unless deployment testing exposes a concrete bug
  that blocks the validation.
- Do not replace the repository's canonical local image flow.
- Do not publish or persist credentials from `.wzh/env.txt`.

## Exit Criteria

- VM GPU, disk, and container runtime state is documented.
- Exact deployed model identifiers are documented, including any substitution if
  the requested shorthand names are not available.
- Both backends answer OpenAI-compatible chat completion requests directly.
- Semantic-router answers through the front door and routes to both backends
  under at least two configurations.
- Single-turn scenario traffic shows content-dependent route selection.
- Multi-turn topic-switch traffic shows whether backend selection can change
  across turns in the same conversation.
- guidellm results compare direct backend and semantic-router paths with
  latency, throughput, and error-rate observations.
- `todo.md`, `wzh-steps/`, and `wzh-solution/` are consistent.

## Task List

- [x] PL0034-T1: Confirm VM access, GPU inventory, runtime, disk layout, and
  network exposure strategy.
- [x] PL0034-T2: Resolve deployable model identifiers for the requested
  Qwen 3.5 2B and 27B targets, or document the closest valid substitute.
- [x] PL0034-T3: Prepare NVMe-backed workspace/cache paths without destroying
  useful existing state.
- [x] PL0034-T4: Launch and health-check both OpenAI-compatible vLLM backends.
- [x] PL0034-T5: Launch semantic-router in front of both backends.
- [x] PL0034-T6: Build at least two semantic-router configuration variants.
- [x] PL0034-T7: Run single-turn scenario traffic and collect route evidence.
- [x] PL0034-T8: Run multi-turn topic-switch scenarios and verify dynamic
  backend switching behavior.
- [x] PL0034-T9: Run guidellm direct-backend and router-path benchmarks.
- [x] PL0034-T10: Write final customer-facing conclusion, evidence, risks, and
  remaining follow-ups.

## Next Action

Round 1 completed. The VM is left running with the `router-basic.yaml`
semantic-router configuration restored after benchmarking.

## Operating Rules

- Treat credentials and tokens as secrets; redact them from durable artifacts.
- Prefer Podman on the CoreOS-like host unless live inspection shows Docker is
  the maintained path.
- Use raw curl only for health checks and debugging. Main traffic generation must
  use a scenario client or benchmark tool.
- Keep direct model endpoint baselines separate from semantic-router measurements.
- Record failed attempts and retries in `wzh-steps/`.

## Related Docs

- [AGENTS.md](../../AGENTS.md)
- [docs/agent/README.md](../README.md)
- [docs/agent/change-surfaces.md](../change-surfaces.md)
- [wzh-solution/wzh-solution-2026.06.25.09.21.md](../../wzh-solution/wzh-solution-2026.06.25.09.21.md)
- [wzh-steps/wzh-steps-2026.06.25.09.21.md](../../wzh-steps/wzh-steps-2026.06.25.09.21.md)
