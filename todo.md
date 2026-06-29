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

## round 4

- DONE: Rebuilt the rebooted GPU VM environment, including persistent working directory, model/cache directories, vLLM backends, semantic-router, and Envoy.
- DONE: Researched current project documentation and runtime behavior for fused multi-signal routing plus model-selection algorithms, including Elo and session-aware/global learning paths.
- DONE: Created one fused semantic-router configuration where many signals can match first and a `hybrid` model-selection algorithm then chooses between `qwen35-2b` and `qwen35-27b-fp8`.
- DONE: Built OpenAI SDK audit traffic that records raw request input, response body, response headers, selected model, selected decision, and matched signal headers for every scenario.
- DONE: Ran many single-turn and multi-turn scenarios, including topic switches, and verified the fused configuration's routing outputs.
- DONE: Verified per-decision `session_aware` and `elo` are rejected by the current runtime image and now point to `global.router.learning.protection` / `global.router.learning.adaptation`.
- DONE: Analyzed signal-hit computation cost, including whether each signal uses regex/header parsing, semantic-router local embedding/classifier inference, external service calls, or backend LLM inference.
- DONE: Produced a comprehensive Chinese round 4 report explaining algorithm configuration meanings, fused routing behavior, test evidence, VM recovery steps, and practical usage guidance.
- DONE: Verified report links, raw evidence, current changed files, host redaction, and secret/password scan before completion.

## round 5

- DONE: Merge the earlier beginner report, the round 4 fused-routing report, and the raw evidence into one Chinese "from beginner to advanced" report.
- DONE: Reorder the learning path from simple routing, to model-selection algorithms, to two fused configuration patterns.
- DONE: Explain technical concepts, routing/configuration fields, algorithm behavior, multi-turn behavior, and cost/performance implications in enough detail for a new graduate reader.
- DONE: Preserve links to source evidence, configs, raw OpenAI SDK request logs, and validation outputs.
- DONE: Verify the new report and steps artifacts exist and do not introduce obvious password/secret content.

## round 6

- DONE: Verify whether the remote GPU VM reboot cleared the working NVMe state, containers, and semantic-router runtime.
- DONE: Recreate the VM working directory, model/cache directories, Podman network, and linger/runtime settings if needed.
- DONE: Restore or restart the two Qwen vLLM backends: `Qwen/Qwen3.5-2B` and `Qwen/Qwen3.5-27B-FP8`.
- DONE: Restore semantic-router and Envoy with the latest fused routing configuration when the backends are healthy.
- DONE: Run OpenAI-compatible health and routed OpenAI SDK audit traffic through Envoy to verify selected-model headers and multi-turn behavior.
- DONE: Record commands, redacted evidence, final state, and any remaining risks in round 6 steps and solution artifacts.

## round 7

- DONE: Confirm from project code and docs whether "budget mode" is real budget exhaustion/fallback or cost-aware model selection.
- DONE: Build the smallest valid budget-related semantic-router configuration for the current runtime image.
- DONE: Run remote OpenAI SDK traffic through Envoy to prove the observed budget/cost behavior.
- DONE: If true budget exhaustion fallback is not implemented or not wired in the runtime image, document that explicitly instead of overclaiming.
- DONE: Record commands, raw evidence, final conclusion, and secret scan results in round 7 artifacts.

## round 8

- DONE: Build an explicit coverage inventory from repository docs/code, not from memory, covering signals, plugins, model-selection algorithms, and global services.
- DONE: Compare that inventory against rounds 1-7 evidence to identify untested, partially tested, and misclassified features.
- DONE: Produce a prioritized missing-test plan that says which features should be tested next on the GPU VM and which require extra dependencies.
- DONE: Record the audit commands, raw evidence, final matrix, and secret scan result in round 8 artifacts.

## round 9

- DONE: Built and ran P0 plugin tests on the GPU VM: fast_response, system_prompt, header_mutation, semantic-cache, router_replay, and streaming chat completions all passed with mock-backend evidence.
- DONE: Built and ran P1 tests where feasible: tools/tool_selection, response_api, and hybrid model selection passed; RAG retrieval/replay was partial because the retrieved context did not reach the final backend request; model_switch_gate was blocked because the current runtime removed that config field; memory was blocked by missing Milvus/Valkey/Qdrant backend.
- DONE: Tested dashboard startup and core pages/API behavior: focused backend packages, protected config API, tools DB API, Vite SPA routes, and authenticated Config/Playground UI passed; production build failed on a TypeScript timer type issue, and full backend `go test ./...` failed in handlers/OpenClaw tests.
- DONE: Classified every P0/P1/dashboard item as PASS, PARTIAL, BLOCKED, or FAIL with concrete evidence and next action in the round 9 solution report.
- DONE: Recorded commands, raw outputs, generated configs/scripts, dashboard evidence, environment cleanup, and secret scan results in round 9 artifacts.

## round 10

- DONE: Re-validated the rebooted remote GPU VM, including GPU, Podman, image cache, model cache, writable NVMe, and open ports.
- DONE: Recreated the VM working directory, Podman network, model/cache mounts, and runtime configs needed for a complex semantic-router use case.
- DONE: Restarted the two OpenAI-compatible Qwen backends: `Qwen/Qwen3.5-2B` and `Qwen/Qwen3.5-27B-FP8`.
- DONE: Deployed semantic-router and Envoy with a complex demo configuration that is interesting to inspect from the dashboard.
- DONE: Started dashboard and exposed an access path for the user to experience it.
- DONE: Ran smoke checks through Envoy and dashboard APIs/UI, then left the dashboard running in detached `screen` session `vsr_round10_dashboard`.
- DONE: Recorded commands, raw outputs, access URL/tunnel notes, generated configs/scripts, risks, and secret scan results in round 10 artifacts.

## round 11

- DONE: Produce a self-contained Chinese "from beginner to advanced" operations guide for senior IT operations customers.
- DONE: Include environment setup: GPU VM prerequisites, filesystem layout, Podman network, model cache, vLLM backends, semantic-router, Envoy, dashboard, local tunnel, and cleanup.
- DONE: Explain simple routing scenarios first, then model-selection algorithms, then fused multi-signal and cache/dashboard scenarios.
- DONE: Embed complete example configuration, request data, expected headers, and parameter explanations in the document.
- DONE: Validate the document exists, is linked from the round artifacts, and does not include live passwords or host secrets.

## round 12

- DONE: Use the `baoyu-design` deck workflow to turn the round 11 E2E operations guide into a Red Hat publication-style briefing deck.
- DONE: Build a 16-slide static HTML deck with Red Hat red/gray/black/white styling and minimum font size above 16 pt.
- DONE: Export the deck as an editable PPTX and verify slide XML contains editable text.
- DONE: Start a local preview server and capture a browser screenshot for visual validation.
- DONE: Scan the generated design artifacts for obvious password, token, API key, host, and private-key patterns.
