# Round 8 steps: semantic-router feature coverage audit

| Field | Value |
|---|---|
| Date | 2026-06-26 |
| Repository | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Goal | Audit which semantic-router features were not tested in rounds 1-7, especially after missing budget coverage until prompted. |
| Scope | Repository docs/code inspection and comparison against existing local reports/evidence. |
| Raw output directory | [files/wzh-steps-2026-06-26-10-55](files/wzh-steps-2026-06-26-10-55) |

## Notes

- This round is an inventory and gap analysis, not a claim that every missing feature has now been validated.
- The output must distinguish runtime-tested, config-started only, code/docs-only, and not tested.

### agent-report

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:56:11+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `make agent-report ENV=cpu CHANGED_FILES=todo.md\ wzh-steps/wzh-steps-2026.06.26.10.55.md\ wzh-solution/wzh-solution-2026.06.26.10.55.md ` |
| Exit code | 0 |
| stdout | [agent-report-.stdout.txt](files/wzh-steps-2026-06-26-10-55/agent-report-.stdout.txt) (59 lines, 4720 bytes) |
| stderr | [agent-report-.stderr.txt](files/wzh-steps-2026-06-26-10-55/agent-report-.stderr.txt) (1 lines, 276 bytes) |
| meta | [agent-report-.meta.txt](files/wzh-steps-2026-06-26-10-55/agent-report-.meta.txt) |

### read-plugin-readme

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:56:32+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 180,410p src/vllm-sr/README.md ` |
| Exit code | 0 |
| stdout | [read-plugin-readme-.stdout.txt](files/wzh-steps-2026-06-26-10-55/read-plugin-readme-.stdout.txt) (231 lines, 6822 bytes) |
| stderr | [read-plugin-readme-.stderr.txt](files/wzh-steps-2026-06-26-10-55/read-plugin-readme-.stderr.txt) (0 lines, 0 bytes) |
| meta | [read-plugin-readme-.meta.txt](files/wzh-steps-2026-06-26-10-55/read-plugin-readme-.meta.txt) |

### read-config-types

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:56:32+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,180p src/semantic-router/pkg/config/config.go ` |
| Exit code | 0 |
| stdout | [read-config-types-.stdout.txt](files/wzh-steps-2026-06-26-10-55/read-config-types-.stdout.txt) (180 lines, 6166 bytes) |
| stderr | [read-config-types-.stderr.txt](files/wzh-steps-2026-06-26-10-55/read-config-types-.stderr.txt) (0 lines, 0 bytes) |
| meta | [read-config-types-.meta.txt](files/wzh-steps-2026-06-26-10-55/read-config-types-.meta.txt) |

### read-selection-methods

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:56:32+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `rg -n Method\[A-Za-z\]+\|SelectionMethod\|Registered\ algorithm\|case\ Method src/semantic-router/pkg/selection src/semantic-router/pkg/config -g \*.go ` |
| Exit code | 0 |
| stdout | [read-selection-methods-.stdout.txt](files/wzh-steps-2026-06-26-10-55/read-selection-methods-.stdout.txt) (246 lines, 25409 bytes) |
| stderr | [read-selection-methods-.stderr.txt](files/wzh-steps-2026-06-26-10-55/read-selection-methods-.stderr.txt) (0 lines, 0 bytes) |
| meta | [read-selection-methods-.meta.txt](files/wzh-steps-2026-06-26-10-55/read-selection-methods-.meta.txt) |

### read-global-services

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:56:32+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,130p src/semantic-router/pkg/config/canonical_global.go ` |
| Exit code | 0 |
| stdout | [read-global-services-.stdout.txt](files/wzh-steps-2026-06-26-10-55/read-global-services-.stdout.txt) (130 lines, 5608 bytes) |
| stderr | [read-global-services-.stderr.txt](files/wzh-steps-2026-06-26-10-55/read-global-services-.stderr.txt) (0 lines, 0 bytes) |
| meta | [read-global-services-.meta.txt](files/wzh-steps-2026-06-26-10-55/read-global-services-.meta.txt) |

### processor-files-list

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:56:49+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `rg --files src/semantic-router/pkg/extproc ` |
| Exit code | 0 |
| stdout | [processor-files-list-.stdout.txt](files/wzh-steps-2026-06-26-10-55/processor-files-list-.stdout.txt) (177 lines, 10458 bytes) |
| stderr | [processor-files-list-.stderr.txt](files/wzh-steps-2026-06-26-10-55/processor-files-list-.stderr.txt) (0 lines, 0 bytes) |
| meta | [processor-files-list-.meta.txt](files/wzh-steps-2026-06-26-10-55/processor-files-list-.meta.txt) |

### prior-reports-summary

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:56:49+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `rg -n semantic-cache\|semantic_cache\|fast_response\|system_prompt\|header_mutation\|router_replay\|memory\|rag\|image_gen\|response_jailbreak\|hallucination\|tools\|tool_selection\|ratelimit\|request_params\|budget\|multi_factor\|latency_aware\|rl_driven\|gmtrouter\|knn\|kmeans\|svm\|mlp\|elo\|session_aware\|router_dc\|automix\|hybrid\|semantic\ cache\|cache\|looper\|authz\|reasoning\|stream\|Anthropic\|response\ api\|response_api wzh-solution/wzh-solution-2026.06.25.09.21.md wzh-solution/wzh-solution-2026.06.25.10.59.md wzh-solution/wzh-solution-2026.06.25.11.30.md wzh-solution/wzh-solution-2026.06.25.15.25.md wzh-solution/wzh-solution-2026.06.25.19.50.md wzh-solution/wzh-solution-2026.06.25.21.45.md wzh-solution/wzh-solution-2026.06.25.22.14.md wzh-solution/files/wzh-solution-2026-06-25-09-21/envoy-vsr.yaml wzh-solution/files/wzh-solution-2026-06-25-09-21/router-aggressive-large.yaml wzh-solution/files/wzh-solution-2026-06-25-09-21/router-basic.yaml wzh-solution/files/wzh-solution-2026-06-25-10-59/router-multisignal.yaml wzh-solution/files/wzh-solution-2026-06-25-10-59/router-selection-algorithms.yaml wzh-solution/files/wzh-solution-2026-06-25-15-25/router-elo-probe.yaml wzh-solution/files/wzh-solution-2026-06-25-15-25/router-fused-signals-hybrid.yaml wzh-solution/files/wzh-solution-2026-06-25-15-25/router-session-aware-probe.yaml wzh-solution/files/wzh-solution-2026-06-25-22-14/router-budget-cost-ceiling.yaml wzh-solution/files/wzh-solution-2026-06-25-22-14/router-budget-ratelimit-no-fallback.yaml wzh-solution/files/wzh-solution-2026-06-25-22-14/router-budget-request-params.yaml wzh-solution/files/wzh-solution-2026-06-25-09-21/traffic_scenarios.py wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_multisignal.py wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_selection_algorithms.py wzh-solution/files/wzh-solution-2026-06-25-15-25/traffic_fused_audit.py wzh-solution/files/wzh-solution-2026-06-25-22-14/budget_probe.py ` |
| Exit code | 0 |
| stdout | [prior-reports-summary-.stdout.txt](files/wzh-steps-2026-06-26-10-55/prior-reports-summary-.stdout.txt) (493 lines, 64742 bytes) |
| stderr | [prior-reports-summary-.stderr.txt](files/wzh-steps-2026-06-26-10-55/prior-reports-summary-.stderr.txt) (0 lines, 0 bytes) |
| meta | [prior-reports-summary-.meta.txt](files/wzh-steps-2026-06-26-10-55/prior-reports-summary-.meta.txt) |

### plugin-runtime-rg

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:56:49+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `rg -n execute.\*Plugin\|Get.\*Config\|PluginConfig\|request_params\|fast_response\|system_prompt\|header_mutation\|router_replay\|semantic-cache\|semantic_cache\|memory\|rag\|tools\|tool_selection\|image_gen\|response_jailbreak\|hallucination src/semantic-router/pkg/extproc src/semantic-router/pkg/config src/semantic-router/pkg/dsl -g \*.go ` |
| Exit code | 0 |
| stdout | [plugin-runtime-rg-.stdout.txt](files/wzh-steps-2026-06-26-10-55/plugin-runtime-rg-.stdout.txt) (2369 lines, 295918 bytes) |
| stderr | [plugin-runtime-rg-.stderr.txt](files/wzh-steps-2026-06-26-10-55/plugin-runtime-rg-.stderr.txt) (0 lines, 0 bytes) |
| meta | [plugin-runtime-rg-.meta.txt](files/wzh-steps-2026-06-26-10-55/plugin-runtime-rg-.meta.txt) |

### req-rag-tools

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:57:04+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,260p src/semantic-router/pkg/extproc/processor_req_body_rag.go src/semantic-router/pkg/extproc/processor_req_body_tools.go ` |
| Exit code | 1 |
| stdout | [req-rag-tools-.stdout.txt](files/wzh-steps-2026-06-26-10-55/req-rag-tools-.stdout.txt) (0 lines, 0 bytes) |
| stderr | [req-rag-tools-.stderr.txt](files/wzh-steps-2026-06-26-10-55/req-rag-tools-.stderr.txt) (2 lines, 182 bytes) |
| meta | [req-rag-tools-.meta.txt](files/wzh-steps-2026-06-26-10-55/req-rag-tools-.meta.txt) |

### req-plugin-files

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:57:04+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,260p src/semantic-router/pkg/extproc/processor_req_body_plugins.go ` |
| Exit code | 1 |
| stdout | [req-plugin-files-.stdout.txt](files/wzh-steps-2026-06-26-10-55/req-plugin-files-.stdout.txt) (0 lines, 0 bytes) |
| stderr | [req-plugin-files-.stderr.txt](files/wzh-steps-2026-06-26-10-55/req-plugin-files-.stderr.txt) (1 lines, 94 bytes) |
| meta | [req-plugin-files-.meta.txt](files/wzh-steps-2026-06-26-10-55/req-plugin-files-.meta.txt) |

### res-plugin-files

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:57:04+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,280p src/semantic-router/pkg/extproc/processor_res_body.go src/semantic-router/pkg/extproc/processor_res_usage.go ` |
| Exit code | 0 |
| stdout | [res-plugin-files-.stdout.txt](files/wzh-steps-2026-06-26-10-55/res-plugin-files-.stdout.txt) (280 lines, 9593 bytes) |
| stderr | [res-plugin-files-.stderr.txt](files/wzh-steps-2026-06-26-10-55/res-plugin-files-.stderr.txt) (0 lines, 0 bytes) |
| meta | [res-plugin-files-.meta.txt](files/wzh-steps-2026-06-26-10-55/res-plugin-files-.meta.txt) |

### plugin-config-types

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:57:04+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `rg -n type\ .\*PluginConfig\|Get.\*Config\|PluginType\|Supported\ inline\ types\|SupportedPlugins src/semantic-router/pkg/config src/semantic-router/pkg/dsl -g \*.go ` |
| Exit code | 0 |
| stdout | [plugin-config-types-.stdout.txt](files/wzh-steps-2026-06-26-10-55/plugin-config-types-.stdout.txt) (97 lines, 10819 bytes) |
| stderr | [plugin-config-types-.stderr.txt](files/wzh-steps-2026-06-26-10-55/plugin-config-types-.stderr.txt) (0 lines, 0 bytes) |
| meta | [plugin-config-types-.meta.txt](files/wzh-steps-2026-06-26-10-55/plugin-config-types-.meta.txt) |

### req-filter-plugins

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:57:28+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,220p src/semantic-router/pkg/extproc/req_filter_request_params.go src/semantic-router/pkg/extproc/req_filter_sys_prompt.go src/semantic-router/pkg/extproc/req_filter_header_mutation.go src/semantic-router/pkg/extproc/req_filter_image_gen.go ` |
| Exit code | 0 |
| stdout | [req-filter-plugins-.stdout.txt](files/wzh-steps-2026-06-26-10-55/req-filter-plugins-.stdout.txt) (220 lines, 6873 bytes) |
| stderr | [req-filter-plugins-.stderr.txt](files/wzh-steps-2026-06-26-10-55/req-filter-plugins-.stderr.txt) (0 lines, 0 bytes) |
| meta | [req-filter-plugins-.meta.txt](files/wzh-steps-2026-06-26-10-55/req-filter-plugins-.meta.txt) |

### fast-response-replay

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:57:28+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,220p src/semantic-router/pkg/extproc/utils_fast.go src/semantic-router/pkg/extproc/router_replay_setup.go src/semantic-router/pkg/extproc/router_replay_api.go ` |
| Exit code | 0 |
| stdout | [fast-response-replay-.stdout.txt](files/wzh-steps-2026-06-26-10-55/fast-response-replay-.stdout.txt) (220 lines, 6442 bytes) |
| stderr | [fast-response-replay-.stderr.txt](files/wzh-steps-2026-06-26-10-55/fast-response-replay-.stderr.txt) (0 lines, 0 bytes) |
| meta | [fast-response-replay-.meta.txt](files/wzh-steps-2026-06-26-10-55/fast-response-replay-.meta.txt) |

### response-filter-plugins

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:57:28+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,220p src/semantic-router/pkg/extproc/res_filter_jailbreak.go src/semantic-router/pkg/extproc/res_filter_hallucination.go src/semantic-router/pkg/extproc/processor_res_header_mutation.go src/semantic-router/pkg/extproc/processor_res_cache.go ` |
| Exit code | 0 |
| stdout | [response-filter-plugins-.stdout.txt](files/wzh-steps-2026-06-26-10-55/response-filter-plugins-.stdout.txt) (220 lines, 7268 bytes) |
| stderr | [response-filter-plugins-.stderr.txt](files/wzh-steps-2026-06-26-10-55/response-filter-plugins-.stderr.txt) (0 lines, 0 bytes) |
| meta | [response-filter-plugins-.meta.txt](files/wzh-steps-2026-06-26-10-55/response-filter-plugins-.meta.txt) |

### rag-tools-memory

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:57:28+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,220p src/semantic-router/pkg/extproc/req_filter_rag.go src/semantic-router/pkg/extproc/req_filter_tools.go src/semantic-router/pkg/extproc/req_tool_selection_plugin.go src/semantic-router/pkg/extproc/req_filter_memory_context.go ` |
| Exit code | 0 |
| stdout | [rag-tools-memory-.stdout.txt](files/wzh-steps-2026-06-26-10-55/rag-tools-memory-.stdout.txt) (220 lines, 7144 bytes) |
| stderr | [rag-tools-memory-.stderr.txt](files/wzh-steps-2026-06-26-10-55/rag-tools-memory-.stderr.txt) (0 lines, 0 bytes) |
| meta | [rag-tools-memory-.meta.txt](files/wzh-steps-2026-06-26-10-55/rag-tools-memory-.meta.txt) |

### coverage-audit-script

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T10:57:53+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `python wzh-solution/files/wzh-solution-2026-06-26-10-55/coverage_audit.py ` |
| Exit code | 0 |
| stdout | [coverage-audit-script-.stdout.txt](files/wzh-steps-2026-06-26-10-55/coverage-audit-script-.stdout.txt) (57 lines, 3582 bytes) |
| stderr | [coverage-audit-script-.stderr.txt](files/wzh-steps-2026-06-26-10-55/coverage-audit-script-.stderr.txt) (0 lines, 0 bytes) |
| meta | [coverage-audit-script-.meta.txt](files/wzh-steps-2026-06-26-10-55/coverage-audit-script-.meta.txt) |

### local-secret-scan

| Field | Value |
|---|---|
| Timestamp | 2026-06-26T11:01:38+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh -c set\ -e\;\ echo\ \"\#\#\ sensitive\ scan\"\;\ rg\ -n\ \"bastion\\.\[\[:alnum:\]\]\|AKIA\[0-9A-Z\]\{16\}\|AWS_SECRET_ACCESS_KEY=\|OPENAI_API_KEY=sk-\|PASSWORD=\[\^\[:space:\]\]+\|-----BEGIN\ \[A-Z\ \]\*PRIVATE\ KEY-----\"\ todo.md\ wzh-solution/wzh-solution-2026.06.26.10.55.md\ wzh-solution/files/wzh-solution-2026-06-26-10-55\ \|\|\ true\;\ echo\ \"\#\#\ diff\ check\"\;\ git\ diff\ --check\;\ echo\ \"\#\#\ status\"\;\ git\ status\ --short ` |
| Exit code | 0 |
| stdout | [local-secret-scan-.stdout.txt](files/wzh-steps-2026-06-26-10-55/local-secret-scan-.stdout.txt) (23 lines, 960 bytes) |
| stderr | [local-secret-scan-.stderr.txt](files/wzh-steps-2026-06-26-10-55/local-secret-scan-.stderr.txt) (0 lines, 0 bytes) |
| meta | [local-secret-scan-.meta.txt](files/wzh-steps-2026-06-26-10-55/local-secret-scan-.meta.txt) |
