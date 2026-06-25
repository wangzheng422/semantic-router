# Semantic router VM routing and performance validation

## round 1

- DONE: Confirmed the VM access path, GPU/container runtime, writable NVMe layout, and model availability for the requested Qwen 3.5 2B and 27B targets.
- DONE: Deployed two OpenAI-compatible vLLM backends on the GPU VM, using `Qwen/Qwen3.5-2B` and `Qwen/Qwen3.5-27B-FP8`.
- DONE: Deployed semantic-router plus Envoy in front of the two backends and tested two routing configurations: `router-basic.yaml` and `router-aggressive-large.yaml`.
- DONE: Selected and used OpenAI SDK scenario traffic for content-sensitive and multi-turn tests instead of relying on raw curl.
- DONE: Tested multi-turn conversations where the topic changes mid-session; both tested configs dynamically switched between 2B and 27B-FP8 according to the current turn and configured priority/default rules.
- DONE: Used `guidellm` 0.6.1 to benchmark direct backend access versus semantic-router access and measured latency/throughput impact.
- DONE: Produced a customer-facing solution report with architecture, routing observations, performance impact, evidence, and risks.

## round 2

- DONE: Inventory non-keyword routing signal types and model-selection algorithms supported by the project.
- DONE: Built a VM-safe multi-signal configuration that tested embedding, structure, conversation, language, context, projection, authz, jailbreak, PII, event, fact-check, user-feedback, reask, and preference routes without external services or real secrets.
- DONE: Built and ran a VM-safe model-selection configuration for router_dc, automix, hybrid, multi_factor, and latency_aware selection over the two Qwen backends.
- DONE: Confirmed per-decision `algorithm.type=elo` and `algorithm.type=session_aware` are rejected by the current router image and now point to global learning/adaptation or protection configuration instead.
- DONE: Ran OpenAI SDK simulated traffic for single-turn and multi-turn scenarios, including topic switches and repeated questions, and captured routing headers.
- DONE: Recorded which routing methods were validated, which were version-gated, and which need different global configuration before reliable use.
- DONE: Restored the VM router to the round 1 basic configuration after the extended tests.

## round 3

- DONE: Produce a comprehensive Chinese report for a semantic-router beginner, explaining the runtime environment, containers, mounted files, traffic path, configuration mechanics, and test results.
- DONE: Explain how each tested configuration directly caused each observed routing result.
- DONE: Document which models were downloaded or initialized by vLLM and semantic-router, including classifier/embedding assets observed in logs.
- DONE: Include practical configuration and usage guidance from entry level to advanced operations.
- DONE: Verify the report links to the authoritative round 1 and round 2 evidence and does not contain secrets.
