# Round 7 steps: semantic-router budget behavior validation

| Field | Value |
|---|---|
| Date | 2026-06-25 |
| Repository | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Goal | Validate whether semantic-router has a true budget-exhaustion model fallback mode, and test the closest budget/cost-related runtime behavior on the remote GPU VM. |
| Scope | Code/docs inspection plus remote runtime validation. |
| Raw output directory | [files/wzh-steps-2026-06-25-22-14](files/wzh-steps-2026-06-25-22-14) |
| Secret handling | VM connection details are read from `.wzh/env.txt` by helper scripts and must not be written to reports. |

## Notes

- This round is explicitly about budget behavior, not generic router recovery.
- If the current runtime only supports cost-aware selection and not mutable budget exhaustion, the report must say that plainly.

### agent-report

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:17:50+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `make agent-report ENV=cpu CHANGED_FILES=todo.md\ wzh-steps/wzh-steps-2026.06.25.22.14.md\ wzh-solution/wzh-solution-2026.06.25.22.14.md ` |
| Exit code | 0 |
| stdout | [agent-report-.stdout.txt](files/wzh-steps-2026-06-25-22-14/agent-report-.stdout.txt) (59 lines, 4720 bytes) |
| stderr | [agent-report-.stderr.txt](files/wzh-steps-2026-06-25-22-14/agent-report-.stderr.txt) (1 lines, 276 bytes) |
| meta | [agent-report-.meta.txt](files/wzh-steps-2026-06-25-22-14/agent-report-.meta.txt) |

### budget-readme

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:18:07+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 330,420p src/vllm-sr/README.md ` |
| Exit code | 0 |
| stdout | [budget-readme-.stdout.txt](files/wzh-steps-2026-06-25-22-14/budget-readme-.stdout.txt) (91 lines, 3016 bytes) |
| stderr | [budget-readme-.stderr.txt](files/wzh-steps-2026-06-25-22-14/budget-readme-.stderr.txt) (0 lines, 0 bytes) |
| meta | [budget-readme-.meta.txt](files/wzh-steps-2026-06-25-22-14/budget-readme-.meta.txt) |

### multi-factor-source

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:18:07+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,430p src/semantic-router/pkg/selection/multi_factor.go ` |
| Exit code | 0 |
| stdout | [multi-factor-source-.stdout.txt](files/wzh-steps-2026-06-25-22-14/multi-factor-source-.stdout.txt) (430 lines, 13196 bytes) |
| stderr | [multi-factor-source-.stderr.txt](files/wzh-steps-2026-06-25-22-14/multi-factor-source-.stderr.txt) (0 lines, 0 bytes) |
| meta | [multi-factor-source-.meta.txt](files/wzh-steps-2026-06-25-22-14/multi-factor-source-.meta.txt) |

### config-schema-budget

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:18:07+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `rg -n MaxCost\|MaxCostPer1M\|max_cost\|budget\|Budget\|pricing\|model_selection\|slo src/semantic-router/pkg src/vllm-sr deploy/recipes docs -g \*.go -g \*.yaml -g \*.md ` |
| Exit code | 0 |
| stdout | [config-schema-budget-.stdout.txt](files/wzh-steps-2026-06-25-22-14/config-schema-budget-.stdout.txt) (541 lines, 63096 bytes) |
| stderr | [config-schema-budget-.stderr.txt](files/wzh-steps-2026-06-25-22-14/config-schema-budget-.stderr.txt) (0 lines, 0 bytes) |
| meta | [config-schema-budget-.meta.txt](files/wzh-steps-2026-06-25-22-14/config-schema-budget-.meta.txt) |

### selection-config

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:18:30+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,280p src/semantic-router/pkg/config/selection_config.go ` |
| Exit code | 0 |
| stdout | [selection-config-.stdout.txt](files/wzh-steps-2026-06-25-22-14/selection-config-.stdout.txt) (280 lines, 13754 bytes) |
| stderr | [selection-config-.stderr.txt](files/wzh-steps-2026-06-25-22-14/selection-config-.stderr.txt) (0 lines, 0 bytes) |
| meta | [selection-config-.meta.txt](files/wzh-steps-2026-06-25-22-14/selection-config-.meta.txt) |

### ratelimit-source

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:18:30+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,240p src/semantic-router/pkg/ratelimit/local_provider.go ` |
| Exit code | 0 |
| stdout | [ratelimit-source-.stdout.txt](files/wzh-steps-2026-06-25-22-14/ratelimit-source-.stdout.txt) (240 lines, 6659 bytes) |
| stderr | [ratelimit-source-.stderr.txt](files/wzh-steps-2026-06-25-22-14/ratelimit-source-.stderr.txt) (0 lines, 0 bytes) |
| meta | [ratelimit-source-.meta.txt](files/wzh-steps-2026-06-25-22-14/ratelimit-source-.meta.txt) |

### factory-source

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:18:30+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,260p src/semantic-router/pkg/selection/factory.go ` |
| Exit code | 0 |
| stdout | [factory-source-.stdout.txt](files/wzh-steps-2026-06-25-22-14/factory-source-.stdout.txt) (260 lines, 8148 bytes) |
| stderr | [factory-source-.stderr.txt](files/wzh-steps-2026-06-25-22-14/factory-source-.stderr.txt) (0 lines, 0 bytes) |
| meta | [factory-source-.meta.txt](files/wzh-steps-2026-06-25-22-14/factory-source-.meta.txt) |

### router-build-ratelimit

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:18:30+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `rg -n ratelimit\|rate_limit\|Report\\\(\|Check\\\( src/semantic-router/pkg/extproc src/semantic-router/pkg/config deploy/recipes -g \*.go -g \*.yaml ` |
| Exit code | 0 |
| stdout | [router-build-ratelimit-.stdout.txt](files/wzh-steps-2026-06-25-22-14/router-build-ratelimit-.stdout.txt) (61 lines, 8169 bytes) |
| stderr | [router-build-ratelimit-.stderr.txt](files/wzh-steps-2026-06-25-22-14/router-build-ratelimit-.stderr.txt) (0 lines, 0 bytes) |
| meta | [router-build-ratelimit-.meta.txt](files/wzh-steps-2026-06-25-22-14/router-build-ratelimit-.meta.txt) |

### local-yaml-parse

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:19:46+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `python - ` |
| Exit code | 0 |
| stdout | [local-yaml-parse-.stdout.txt](files/wzh-steps-2026-06-25-22-14/local-yaml-parse-.stdout.txt) (2 lines, 281 bytes) |
| stderr | [local-yaml-parse-.stderr.txt](files/wzh-steps-2026-06-25-22-14/local-yaml-parse-.stderr.txt) (0 lines, 0 bytes) |
| meta | [local-yaml-parse-.meta.txt](files/wzh-steps-2026-06-25-22-14/local-yaml-parse-.meta.txt) |

### remote-sync-budget-configs

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:20:08+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh -c zsh\ wzh-steps/files/wzh-steps-2026-06-25-22-14/scp_to_vm.zsh\ wzh-solution/files/wzh-solution-2026-06-25-22-14/router-budget-cost-ceiling.yaml\ /var/mnt/semantic-router-bench/configs/router-budget-cost-ceiling.yaml\ \&\&\ zsh\ wzh-steps/files/wzh-steps-2026-06-25-22-14/scp_to_vm.zsh\ wzh-solution/files/wzh-solution-2026-06-25-22-14/router-budget-request-params.yaml\ /var/mnt/semantic-router-bench/configs/router-budget-request-params.yaml ` |
| Exit code | 0 |
| stdout | [remote-sync-budget-configs-.stdout.txt](files/wzh-steps-2026-06-25-22-14/remote-sync-budget-configs-.stdout.txt) (0 lines, 0 bytes) |
| stderr | [remote-sync-budget-configs-.stderr.txt](files/wzh-steps-2026-06-25-22-14/remote-sync-budget-configs-.stderr.txt) (2 lines, 200 bytes) |
| meta | [remote-sync-budget-configs-.meta.txt](files/wzh-steps-2026-06-25-22-14/remote-sync-budget-configs-.meta.txt) |

### remote-start-cost-ceiling

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:20:55+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh wzh-steps/files/wzh-steps-2026-06-25-22-14/remote.zsh set\ -euo\ pipefail\;\ MP=/var/mnt/semantic-router-bench\;\ podman\ rm\ -f\ vsr-router\ vsr-envoy\ \>/dev/null\ 2\>\&1\ \|\|\ true\;\ podman\ run\ -d\ --name\ vsr-router\ --network\ vsr-bench\ --security-opt=label=disable\ -p\ 18080:8080\ -p\ 15051:50051\ -p\ 19190:9190\ -e\ AI_BINDING=candle\ -v\ \"\$MP/configs/router-budget-cost-ceiling.yaml:/app/config.yaml:Z\"\ -v\ \"\$MP/models:/app/models:Z\"\ -v\ \"\$MP/logs:/logs:Z\"\ ghcr.io/vllm-project/semantic-router/vllm-sr:latest\ /app/config.yaml\;\ podman\ run\ -d\ --name\ vsr-envoy\ --network\ vsr-bench\ --security-opt=label=disable\ -p\ 18888:8888\ -p\ 19901:9901\ -v\ \"\$MP/configs/envoy-vsr.yaml:/etc/envoy/envoy.yaml:Z\"\ docker.io/envoyproxy/envoy:v1.34-latest\ -c\ /etc/envoy/envoy.yaml\ --log-level\ warn\;\ for\ i\ in\ \$\(seq\ 1\ 90\)\;\ do\ if\ curl\ -fsS\ http://127.0.0.1:18080/health\ \>/dev/null\ 2\>\&1\ \&\&\ curl\ -fsS\ http://127.0.0.1:18888/v1/models\ \>/dev/null\ 2\>\&1\;\ then\ echo\ \"ready_attempt=\$i\"\;\ break\;\ fi\;\ if\ !\ podman\ ps\ --format\ \"\{\{.Names\}\}\"\ \|\ grep\ -qx\ vsr-router\;\ then\ echo\ router_exited\;\ podman\ logs\ --tail\ 240\ vsr-router\ \|\|\ true\;\ exit\ 1\;\ fi\;\ sleep\ 2\;\ done\;\ curl\ -fsS\ http://127.0.0.1:18080/health\;\ echo\;\ curl\ -fsS\ http://127.0.0.1:18888/v1/models\;\ echo\;\ podman\ logs\ --tail\ 80\ vsr-router ` |
| Exit code | 0 |
| stdout | [remote-start-cost-ceiling-.stdout.txt](files/wzh-steps-2026-06-25-22-14/remote-start-cost-ceiling-.stdout.txt) (17 lines, 1485 bytes) |
| stderr | [remote-start-cost-ceiling-.stderr.txt](files/wzh-steps-2026-06-25-22-14/remote-start-cost-ceiling-.stderr.txt) (54 lines, 12364 bytes) |
| meta | [remote-start-cost-ceiling-.meta.txt](files/wzh-steps-2026-06-25-22-14/remote-start-cost-ceiling-.meta.txt) |

### remote-cost-ceiling-sdk

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:21:43+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh wzh-steps/files/wzh-steps-2026-06-25-22-14/remote.zsh set\ -euo\ pipefail\;\ OUT=/var/mnt/semantic-router-bench/benchmarks/round7-2026-06-25-22-14\;\ mkdir\ -p\ \"\$OUT\"\;\ podman\ run\ --rm\ --network\ vsr-bench\ --security-opt=label=disable\ -v\ /var/mnt/semantic-router-bench/benchmarks:/benchmarks:Z\ --entrypoint\ python3\ docker.io/vllm/vllm-openai:latest\ -\ \<\<\"PY\"$'\n'import\ json,\ time$'\n'from\ openai\ import\ OpenAI$'\n'client\ =\ OpenAI\(base_url=\"http://vsr-envoy:8888/v1\",\ api_key=\"EMPTY\"\)$'\n'scenarios\ =\ \[$'\n'\ \ \ \ \(\"complex_debug_budget_ceiling\",\ \[\{\"role\":\"user\",\"content\":\"Troubleshoot\ this\ production\ incident,\ explain\ the\ root\ cause,\ debug\ the\ architecture,\ and\ propose\ mitigation\ steps.\"\}\],\ 64\),$'\n'\ \ \ \ \(\"simple_default_budget_ceiling\",\ \[\{\"role\":\"user\",\"content\":\"Hello,\ answer\ in\ one\ short\ sentence.\"\}\],\ 32\),$'\n'\]$'\n'rows=\[\]$'\n'for\ sid,\ messages,\ max_tokens\ in\ scenarios:$'\n'\ \ \ \ req\ =\ \{\"model\":\"auto\",\"messages\":messages,\"max_tokens\":max_tokens,\"temperature\":0\}$'\n'\ \ \ \ start=time.perf_counter\(\)$'\n'\ \ \ \ raw\ =\ client.chat.completions.with_raw_response.create\(\*\*req,\ extra_headers=\{\"x-authz-user-id\":\"round7-budget\"\}\)$'\n'\ \ \ \ parsed=raw.parse\(\)$'\n'\ \ \ \ headers=\{k.lower\(\):v\ for\ k,v\ in\ raw.headers.items\(\)\}$'\n'\ \ \ \ captured=\{k:headers.get\(k\)\ for\ k\ in\ \[\"x-vsr-selected-decision\",\"x-vsr-selected-model\",\"x-vsr-selection-method\",\"x-vsr-model-selection-method\",\"x-vsr-selected-reasoning\",\"x-vsr-matched-keywords\"\]\ if\ headers.get\(k\)\ is\ not\ None\}$'\n'\ \ \ \ row=\{\"scenario_id\":sid,\"ok\":True,\"elapsed_ms\":round\(\(time.perf_counter\(\)-start\)\*1000,2\),\"request\":\{\"body\":req\},\"response\":\{\"status\":raw.status_code,\"captured_headers\":captured,\"model\":parsed.model,\"usage\":parsed.usage.model_dump\(\)\ if\ parsed.usage\ else\ None,\"content\":parsed.choices\[0\].message.content\}\}$'\n'\ \ \ \ rows.append\(row\)$'\n'\ \ \ \ print\(sid,\ raw.status_code,\ captured,\ parsed.model,\ parsed.usage\)$'\n'path=\"/benchmarks/round7-2026-06-25-22-14/cost-ceiling-sdk-results.jsonl\"$'\n'with\ open\(path,\"w\",encoding=\"utf-8\"\)\ as\ f:$'\n'\ \ \ \ for\ row\ in\ rows:$'\n'\ \ \ \ \ \ \ \ f.write\(json.dumps\(row,\ ensure_ascii=False,\ sort_keys=True\)+\"\\n\"\)$'\n'print\(\"saved\",\ path\)$'\n'PY$'\n'cat\ \"\$OUT/cost-ceiling-sdk-results.jsonl\"\;\ echo\ \"\#\#\ envoy\"\;\ podman\ logs\ --tail\ 20\ vsr-envoy\;\ echo\ \"\#\#\ router\"\;\ podman\ logs\ --tail\ 120\ vsr-router ` |
| Exit code | 1 |
| stdout | [remote-cost-ceiling-sdk-.stdout.txt](files/wzh-steps-2026-06-25-22-14/remote-cost-ceiling-sdk-.stdout.txt) (0 lines, 0 bytes) |
| stderr | [remote-cost-ceiling-sdk-.stderr.txt](files/wzh-steps-2026-06-25-22-14/remote-cost-ceiling-sdk-.stderr.txt) (2 lines, 229 bytes) |
| meta | [remote-cost-ceiling-sdk-.meta.txt](files/wzh-steps-2026-06-25-22-14/remote-cost-ceiling-sdk-.meta.txt) |

### remote-sync-budget-probe

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:22:53+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh wzh-steps/files/wzh-steps-2026-06-25-22-14/scp_to_vm.zsh wzh-solution/files/wzh-solution-2026-06-25-22-14/budget_probe.py /var/mnt/semantic-router-bench/traffic/budget_probe.py ` |
| Exit code | 0 |
| stdout | [remote-sync-budget-probe-.stdout.txt](files/wzh-steps-2026-06-25-22-14/remote-sync-budget-probe-.stdout.txt) (0 lines, 0 bytes) |
| stderr | [remote-sync-budget-probe-.stderr.txt](files/wzh-steps-2026-06-25-22-14/remote-sync-budget-probe-.stderr.txt) (1 lines, 100 bytes) |
| meta | [remote-sync-budget-probe-.meta.txt](files/wzh-steps-2026-06-25-22-14/remote-sync-budget-probe-.meta.txt) |

### remote-cost-ceiling-sdk-file

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:23:44+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh wzh-steps/files/wzh-steps-2026-06-25-22-14/remote.zsh set\ -euo\ pipefail\;\ OUT=/var/mnt/semantic-router-bench/benchmarks/round7-2026-06-25-22-14\;\ mkdir\ -p\ \"\$OUT\"\;\ podman\ run\ --rm\ --network\ vsr-bench\ --security-opt=label=disable\ -v\ /var/mnt/semantic-router-bench/traffic:/traffic:Z\ -v\ /var/mnt/semantic-router-bench/benchmarks:/benchmarks:Z\ --entrypoint\ python3\ docker.io/vllm/vllm-openai:latest\ /traffic/budget_probe.py\ --mode\ cost-ceiling\ --base-url\ http://vsr-envoy:8888/v1\ --output\ /benchmarks/round7-2026-06-25-22-14/cost-ceiling-sdk-results.jsonl\;\ echo\ \"\#\#\ results\"\;\ cat\ \"\$OUT/cost-ceiling-sdk-results.jsonl\"\;\ echo\ \"\#\#\ envoy\"\;\ podman\ logs\ --tail\ 20\ vsr-envoy\;\ echo\ \"\#\#\ router\ multifactor\"\;\ podman\ logs\ --tail\ 160\ vsr-router\ \|\ grep\ -E\ \"MultiFactor\|routing_decision\|startup_complete\|Unknown\ field\"\ \|\|\ true ` |
| Exit code | 0 |
| stdout | [remote-cost-ceiling-sdk-file-.stdout.txt](files/wzh-steps-2026-06-25-22-14/remote-cost-ceiling-sdk-file-.stdout.txt) (10 lines, 3595 bytes) |
| stderr | [remote-cost-ceiling-sdk-file-.stderr.txt](files/wzh-steps-2026-06-25-22-14/remote-cost-ceiling-sdk-file-.stderr.txt) (72 lines, 19015 bytes) |
| meta | [remote-cost-ceiling-sdk-file-.meta.txt](files/wzh-steps-2026-06-25-22-14/remote-cost-ceiling-sdk-file-.meta.txt) |

### remote-start-request-params

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:24:52+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh wzh-steps/files/wzh-steps-2026-06-25-22-14/remote.zsh set\ -euo\ pipefail\;\ MP=/var/mnt/semantic-router-bench\;\ podman\ rm\ -f\ vsr-router\ vsr-envoy\ \>/dev/null\ 2\>\&1\ \|\|\ true\;\ podman\ run\ -d\ --name\ vsr-router\ --network\ vsr-bench\ --security-opt=label=disable\ -p\ 18080:8080\ -p\ 15051:50051\ -p\ 19190:9190\ -e\ AI_BINDING=candle\ -v\ \"\$MP/configs/router-budget-request-params.yaml:/app/config.yaml:Z\"\ -v\ \"\$MP/models:/app/models:Z\"\ -v\ \"\$MP/logs:/logs:Z\"\ ghcr.io/vllm-project/semantic-router/vllm-sr:latest\ /app/config.yaml\;\ podman\ run\ -d\ --name\ vsr-envoy\ --network\ vsr-bench\ --security-opt=label=disable\ -p\ 18888:8888\ -p\ 19901:9901\ -v\ \"\$MP/configs/envoy-vsr.yaml:/etc/envoy/envoy.yaml:Z\"\ docker.io/envoyproxy/envoy:v1.34-latest\ -c\ /etc/envoy/envoy.yaml\ --log-level\ warn\;\ for\ i\ in\ \$\(seq\ 1\ 90\)\;\ do\ if\ curl\ -fsS\ http://127.0.0.1:18080/health\ \>/dev/null\ 2\>\&1\ \&\&\ curl\ -fsS\ http://127.0.0.1:18888/v1/models\ \>/dev/null\ 2\>\&1\;\ then\ echo\ \"ready_attempt=\$i\"\;\ break\;\ fi\;\ if\ !\ podman\ ps\ --format\ \"\{\{.Names\}\}\"\ \|\ grep\ -qx\ vsr-router\;\ then\ echo\ router_exited\;\ podman\ logs\ --tail\ 240\ vsr-router\ \|\|\ true\;\ exit\ 1\;\ fi\;\ sleep\ 2\;\ done\;\ curl\ -fsS\ http://127.0.0.1:18080/health\;\ echo\;\ curl\ -fsS\ http://127.0.0.1:18888/v1/models\;\ echo\;\ podman\ logs\ --tail\ 80\ vsr-router ` |
| Exit code | 0 |
| stdout | [remote-start-request-params-.stdout.txt](files/wzh-steps-2026-06-25-22-14/remote-start-request-params-.stdout.txt) (17 lines, 1392 bytes) |
| stderr | [remote-start-request-params-.stderr.txt](files/wzh-steps-2026-06-25-22-14/remote-start-request-params-.stderr.txt) (53 lines, 12197 bytes) |
| meta | [remote-start-request-params-.meta.txt](files/wzh-steps-2026-06-25-22-14/remote-start-request-params-.meta.txt) |

### remote-request-params-sdk

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:25:53+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh wzh-steps/files/wzh-steps-2026-06-25-22-14/remote.zsh set\ -euo\ pipefail\;\ OUT=/var/mnt/semantic-router-bench/benchmarks/round7-2026-06-25-22-14\;\ mkdir\ -p\ \"\$OUT\"\;\ podman\ run\ --rm\ --network\ vsr-bench\ --security-opt=label=disable\ -v\ /var/mnt/semantic-router-bench/traffic:/traffic:Z\ -v\ /var/mnt/semantic-router-bench/benchmarks:/benchmarks:Z\ --entrypoint\ python3\ docker.io/vllm/vllm-openai:latest\ /traffic/budget_probe.py\ --mode\ request-params\ --base-url\ http://vsr-envoy:8888/v1\ --output\ /benchmarks/round7-2026-06-25-22-14/request-params-sdk-results.jsonl\;\ echo\ \"\#\#\ results\"\;\ cat\ \"\$OUT/request-params-sdk-results.jsonl\"\;\ echo\ \"\#\#\ envoy\"\;\ podman\ logs\ --tail\ 20\ vsr-envoy\;\ echo\ \"\#\#\ router\ plugin\"\;\ podman\ logs\ --tail\ 160\ vsr-router\ \|\ grep\ -E\ \"request_params\|budget-request\|routing_decision\|startup_complete\|plugin\"\ \|\|\ true ` |
| Exit code | 0 |
| stdout | [remote-request-params-sdk-.stdout.txt](files/wzh-steps-2026-06-25-22-14/remote-request-params-sdk-.stdout.txt) (10 lines, 3234 bytes) |
| stderr | [remote-request-params-sdk-.stderr.txt](files/wzh-steps-2026-06-25-22-14/remote-request-params-sdk-.stderr.txt) (69 lines, 18363 bytes) |
| meta | [remote-request-params-sdk-.meta.txt](files/wzh-steps-2026-06-25-22-14/remote-request-params-sdk-.meta.txt) |

### remote-sync-ratelimit-budget

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:27:10+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh -c zsh\ wzh-steps/files/wzh-steps-2026-06-25-22-14/scp_to_vm.zsh\ wzh-solution/files/wzh-solution-2026-06-25-22-14/router-budget-ratelimit-no-fallback.yaml\ /var/mnt/semantic-router-bench/configs/router-budget-ratelimit-no-fallback.yaml\ \&\&\ zsh\ wzh-steps/files/wzh-steps-2026-06-25-22-14/scp_to_vm.zsh\ wzh-solution/files/wzh-solution-2026-06-25-22-14/budget_probe.py\ /var/mnt/semantic-router-bench/traffic/budget_probe.py ` |
| Exit code | 0 |
| stdout | [remote-sync-ratelimit-budget-.stdout.txt](files/wzh-steps-2026-06-25-22-14/remote-sync-ratelimit-budget-.stdout.txt) (0 lines, 0 bytes) |
| stderr | [remote-sync-ratelimit-budget-.stderr.txt](files/wzh-steps-2026-06-25-22-14/remote-sync-ratelimit-budget-.stderr.txt) (2 lines, 200 bytes) |
| meta | [remote-sync-ratelimit-budget-.meta.txt](files/wzh-steps-2026-06-25-22-14/remote-sync-ratelimit-budget-.meta.txt) |

### remote-start-ratelimit-budget

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:27:40+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh wzh-steps/files/wzh-steps-2026-06-25-22-14/remote.zsh set\ -euo\ pipefail\;\ MP=/var/mnt/semantic-router-bench\;\ podman\ rm\ -f\ vsr-router\ vsr-envoy\ \>/dev/null\ 2\>\&1\ \|\|\ true\;\ podman\ run\ -d\ --name\ vsr-router\ --network\ vsr-bench\ --security-opt=label=disable\ -p\ 18080:8080\ -p\ 15051:50051\ -p\ 19190:9190\ -e\ AI_BINDING=candle\ -v\ \"\$MP/configs/router-budget-ratelimit-no-fallback.yaml:/app/config.yaml:Z\"\ -v\ \"\$MP/models:/app/models:Z\"\ -v\ \"\$MP/logs:/logs:Z\"\ ghcr.io/vllm-project/semantic-router/vllm-sr:latest\ /app/config.yaml\;\ podman\ run\ -d\ --name\ vsr-envoy\ --network\ vsr-bench\ --security-opt=label=disable\ -p\ 18888:8888\ -p\ 19901:9901\ -v\ \"\$MP/configs/envoy-vsr.yaml:/etc/envoy/envoy.yaml:Z\"\ docker.io/envoyproxy/envoy:v1.34-latest\ -c\ /etc/envoy/envoy.yaml\ --log-level\ warn\;\ for\ i\ in\ \$\(seq\ 1\ 90\)\;\ do\ if\ curl\ -fsS\ http://127.0.0.1:18080/health\ \>/dev/null\ 2\>\&1\ \&\&\ curl\ -fsS\ http://127.0.0.1:18888/v1/models\ \>/dev/null\ 2\>\&1\;\ then\ echo\ \"ready_attempt=\$i\"\;\ break\;\ fi\;\ if\ !\ podman\ ps\ --format\ \"\{\{.Names\}\}\"\ \|\ grep\ -qx\ vsr-router\;\ then\ echo\ router_exited\;\ podman\ logs\ --tail\ 240\ vsr-router\ \|\|\ true\;\ exit\ 1\;\ fi\;\ sleep\ 2\;\ done\;\ curl\ -fsS\ http://127.0.0.1:18080/health\;\ echo\;\ curl\ -fsS\ http://127.0.0.1:18888/v1/models\;\ echo\;\ podman\ logs\ --tail\ 100\ vsr-router\ \|\ grep\ -E\ \"RateLimit\|startup_complete\|rate_limit\"\ \|\|\ true ` |
| Exit code | 0 |
| stdout | [remote-start-ratelimit-budget-.stdout.txt](files/wzh-steps-2026-06-25-22-14/remote-start-ratelimit-budget-.stdout.txt) (5 lines, 1013 bytes) |
| stderr | [remote-start-ratelimit-budget-.stderr.txt](files/wzh-steps-2026-06-25-22-14/remote-start-ratelimit-budget-.stderr.txt) (55 lines, 12484 bytes) |
| meta | [remote-start-ratelimit-budget-.meta.txt](files/wzh-steps-2026-06-25-22-14/remote-start-ratelimit-budget-.meta.txt) |

### remote-ratelimit-budget-sdk

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:28:04+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh wzh-steps/files/wzh-steps-2026-06-25-22-14/remote.zsh set\ -euo\ pipefail\;\ OUT=/var/mnt/semantic-router-bench/benchmarks/round7-2026-06-25-22-14\;\ mkdir\ -p\ \"\$OUT\"\;\ podman\ run\ --rm\ --network\ vsr-bench\ --security-opt=label=disable\ -v\ /var/mnt/semantic-router-bench/traffic:/traffic:Z\ -v\ /var/mnt/semantic-router-bench/benchmarks:/benchmarks:Z\ --entrypoint\ python3\ docker.io/vllm/vllm-openai:latest\ /traffic/budget_probe.py\ --mode\ ratelimit\ --base-url\ http://vsr-envoy:8888/v1\ --output\ /benchmarks/round7-2026-06-25-22-14/ratelimit-sdk-results.jsonl\ \|\|\ true\;\ echo\ \"\#\#\ results\"\;\ cat\ \"\$OUT/ratelimit-sdk-results.jsonl\"\;\ echo\ \"\#\#\ envoy\"\;\ podman\ logs\ --tail\ 20\ vsr-envoy\;\ echo\ \"\#\#\ router\ ratelimit\"\;\ podman\ logs\ --tail\ 120\ vsr-router\ \|\ grep\ -E\ \"rate_limit\|RateLimit\|StaticSelector\|routing_decision\|selected\"\ \|\|\ true ` |
| Exit code | 0 |
| stdout | [remote-ratelimit-budget-sdk-.stdout.txt](files/wzh-steps-2026-06-25-22-14/remote-ratelimit-budget-sdk-.stdout.txt) (9 lines, 905 bytes) |
| stderr | [remote-ratelimit-budget-sdk-.stderr.txt](files/wzh-steps-2026-06-25-22-14/remote-ratelimit-budget-sdk-.stderr.txt) (72 lines, 17283 bytes) |
| meta | [remote-ratelimit-budget-sdk-.meta.txt](files/wzh-steps-2026-06-25-22-14/remote-ratelimit-budget-sdk-.meta.txt) |

### remote-restore-fused-config

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:29:39+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh wzh-steps/files/wzh-steps-2026-06-25-22-14/remote.zsh set\ -euo\ pipefail\;\ MP=/var/mnt/semantic-router-bench\;\ podman\ rm\ -f\ vsr-router\ vsr-envoy\ \>/dev/null\ 2\>\&1\ \|\|\ true\;\ podman\ run\ -d\ --name\ vsr-router\ --network\ vsr-bench\ --security-opt=label=disable\ -p\ 18080:8080\ -p\ 15051:50051\ -p\ 19190:9190\ -e\ AI_BINDING=candle\ -v\ \"\$MP/configs/router-fused-signals-hybrid.yaml:/app/config.yaml:Z\"\ -v\ \"\$MP/models:/app/models:Z\"\ -v\ \"\$MP/logs:/logs:Z\"\ ghcr.io/vllm-project/semantic-router/vllm-sr:latest\ /app/config.yaml\;\ podman\ run\ -d\ --name\ vsr-envoy\ --network\ vsr-bench\ --security-opt=label=disable\ -p\ 18888:8888\ -p\ 19901:9901\ -v\ \"\$MP/configs/envoy-vsr.yaml:/etc/envoy/envoy.yaml:Z\"\ docker.io/envoyproxy/envoy:v1.34-latest\ -c\ /etc/envoy/envoy.yaml\ --log-level\ warn\;\ for\ i\ in\ \$\(seq\ 1\ 90\)\;\ do\ if\ curl\ -fsS\ http://127.0.0.1:18080/health\ \>/dev/null\ 2\>\&1\ \&\&\ curl\ -fsS\ http://127.0.0.1:18888/v1/models\ \>/dev/null\ 2\>\&1\;\ then\ echo\ \"ready_attempt=\$i\"\;\ break\;\ fi\;\ sleep\ 2\;\ done\;\ curl\ -fsS\ http://127.0.0.1:18080/health\;\ echo\;\ curl\ -fsS\ http://127.0.0.1:18888/v1/models\;\ echo\;\ podman\ ps\ --format\ \"\{\{.Names\}\}\ \{\{.Status\}\}\ \{\{.Ports\}\}\"\ \|\ grep\ -E\ \"vsr-router\|vsr-envoy\|vsr-qwen\" ` |
| Exit code | 0 |
| stdout | [remote-restore-fused-config-.stdout.txt](files/wzh-steps-2026-06-25-22-14/remote-restore-fused-config-.stdout.txt) (9 lines, 1289 bytes) |
| stderr | [remote-restore-fused-config-.stderr.txt](files/wzh-steps-2026-06-25-22-14/remote-restore-fused-config-.stderr.txt) (1 lines, 100 bytes) |
| meta | [remote-restore-fused-config-.meta.txt](files/wzh-steps-2026-06-25-22-14/remote-restore-fused-config-.meta.txt) |

### local-copy-budget-results

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:29:57+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh -c cp\ wzh-steps/files/wzh-steps-2026-06-25-22-14/remote-cost-ceiling-sdk-file-.stdout.txt\ wzh-solution/files/wzh-solution-2026-06-25-22-14/cost-ceiling-sdk-output.txt\ \&\&\ cp\ wzh-steps/files/wzh-steps-2026-06-25-22-14/remote-request-params-sdk-.stdout.txt\ wzh-solution/files/wzh-solution-2026-06-25-22-14/request-params-sdk-output.txt\ \&\&\ cp\ wzh-steps/files/wzh-steps-2026-06-25-22-14/remote-ratelimit-budget-sdk-.stdout.txt\ wzh-solution/files/wzh-solution-2026-06-25-22-14/ratelimit-budget-sdk-output.txt\ \&\&\ wc\ -l\ -c\ wzh-solution/files/wzh-solution-2026-06-25-22-14/\*sdk-output.txt ` |
| Exit code | 0 |
| stdout | [local-copy-budget-results-.stdout.txt](files/wzh-steps-2026-06-25-22-14/local-copy-budget-results-.stdout.txt) (4 lines, 311 bytes) |
| stderr | [local-copy-budget-results-.stderr.txt](files/wzh-steps-2026-06-25-22-14/local-copy-budget-results-.stderr.txt) (0 lines, 0 bytes) |
| meta | [local-copy-budget-results-.meta.txt](files/wzh-steps-2026-06-25-22-14/local-copy-budget-results-.meta.txt) |

### local-secret-scan-final

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:31:12+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh -c set\ -e\;\ files=\"todo.md\ wzh-solution/wzh-solution-2026.06.25.22.14.md\ wzh-solution/files/wzh-solution-2026-06-25-22-14\ wzh-steps/wzh-steps-2026.06.25.22.14.md\ wzh-steps/files/wzh-steps-2026-06-25-22-14\"\;\ echo\ \"\#\#\ sensitive\ scan\"\;\ rg\ -n\ \"bastion\\.\[\[:alnum:\]\]\|AKIA\[0-9A-Z\]\{16\}\|AWS_SECRET_ACCESS_KEY=\|OPENAI_API_KEY=sk-\|PASSWORD=\[\^\[:space:\]\]+\|-----BEGIN\ \[A-Z\ \]\*PRIVATE\ KEY-----\"\ \$files\ \|\|\ true\;\ echo\ \"\#\#\ diff\ check\"\;\ git\ diff\ --check\;\ echo\ \"\#\#\ status\"\;\ git\ status\ --short ` |
| Exit code | 0 |
| stdout | [local-secret-scan-final-.stdout.txt](files/wzh-steps-2026-06-25-22-14/local-secret-scan-final-.stdout.txt) (19 lines, 768 bytes) |
| stderr | [local-secret-scan-final-.stderr.txt](files/wzh-steps-2026-06-25-22-14/local-secret-scan-final-.stderr.txt) (1 lines, 443 bytes) |
| meta | [local-secret-scan-final-.meta.txt](files/wzh-steps-2026-06-25-22-14/local-secret-scan-final-.meta.txt) |

### local-secret-scan-final-fixed

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T22:31:30+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh -c set\ -e\;\ echo\ \"\#\#\ sensitive\ scan\"\;\ rg\ -n\ \"bastion\\.\[\[:alnum:\]\]\|AKIA\[0-9A-Z\]\{16\}\|AWS_SECRET_ACCESS_KEY=\|OPENAI_API_KEY=sk-\|PASSWORD=\[\^\[:space:\]\]+\|-----BEGIN\ \[A-Z\ \]\*PRIVATE\ KEY-----\"\ todo.md\ wzh-solution/wzh-solution-2026.06.25.22.14.md\ wzh-solution/files/wzh-solution-2026-06-25-22-14\ wzh-steps/wzh-steps-2026.06.25.22.14.md\ wzh-steps/files/wzh-steps-2026-06-25-22-14\ \|\|\ true\;\ echo\ \"\#\#\ diff\ check\"\;\ git\ diff\ --check\;\ echo\ \"\#\#\ status\"\;\ git\ status\ --short ` |
| Exit code | 0 |
| stdout | [local-secret-scan-final-fixed-.stdout.txt](files/wzh-steps-2026-06-25-22-14/local-secret-scan-final-fixed-.stdout.txt) (22 lines, 2655 bytes) |
| stderr | [local-secret-scan-final-fixed-.stderr.txt](files/wzh-steps-2026-06-25-22-14/local-secret-scan-final-fixed-.stderr.txt) (0 lines, 0 bytes) |
| meta | [local-secret-scan-final-fixed-.meta.txt](files/wzh-steps-2026-06-25-22-14/local-secret-scan-final-fixed-.meta.txt) |
