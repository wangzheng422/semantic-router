# Round 5 steps: consolidated beginner-to-advanced semantic-router report

| Field | Value |
|---|---|
| Date | 2026-06-25 |
| Repository | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Goal | Merge earlier beginner, routing, algorithm, and fused-routing reports into one detailed Chinese "from beginner to advanced" report. |
| Scope | Local repository documentation and evidence consolidation only; no VM changes and no runtime redeployment. |
| Raw output directory | [files/wzh-steps-2026-06-25-19-50](files/wzh-steps-2026-06-25-19-50) |

## Notes

- Commands below were re-run locally to preserve the exact evidence used for this round.
- Earlier exploratory reads in the chat established the structure of previous reports; this steps file records the final evidence commands used to write and verify the consolidated report.

### report-headings

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:53:34+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `rg -n \^\(\#\|\#\#\|\#\#\#\)\  solution/solution-2026.06.11.15.43.md wzh-solution/wzh-solution-2026.06.25.09.21.md wzh-solution/wzh-solution-2026.06.25.10.59.md wzh-solution/wzh-solution-2026.06.25.11.30.md wzh-solution/wzh-solution-2026.06.25.15.25.md ` |
| Exit code | 0 |
| stdout | [report-headings-.stdout.txt](files/wzh-steps-2026-06-25-19-50/report-headings-.stdout.txt) (142 lines, 11815 bytes) |
| stderr | [report-headings-.stderr.txt](files/wzh-steps-2026-06-25-19-50/report-headings-.stderr.txt) (0 lines, 0 bytes) |
| meta | [report-headings-.meta.txt](files/wzh-steps-2026-06-25-19-50/report-headings-.meta.txt) |

### config-files-list

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:53:41+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `find wzh-solution/files -maxdepth 2 -type f \( -name router-basic.yaml -o -name router-aggressive-large.yaml -o -name router-multisignal.yaml -o -name router-selection-algorithms.yaml -o -name router-fused-signals-hybrid.yaml -o -name traffic_fused_audit.py \) -print ` |
| Exit code | 0 |
| stdout | [config-files-list-.stdout.txt](files/wzh-steps-2026-06-25-19-50/config-files-list-.stdout.txt) (6 lines, 454 bytes) |
| stderr | [config-files-list-.stderr.txt](files/wzh-steps-2026-06-25-19-50/config-files-list-.stderr.txt) (0 lines, 0 bytes) |
| meta | [config-files-list-.meta.txt](files/wzh-steps-2026-06-25-19-50/config-files-list-.meta.txt) |

### router-basic-config

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:53:49+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,220p wzh-solution/files/wzh-solution-2026-06-25-09-21/router-basic.yaml ` |
| Exit code | 0 |
| stdout | [router-basic-config-.stdout.txt](files/wzh-steps-2026-06-25-19-50/router-basic-config-.stdout.txt) (132 lines, 3276 bytes) |
| stderr | [router-basic-config-.stderr.txt](files/wzh-steps-2026-06-25-19-50/router-basic-config-.stderr.txt) (0 lines, 0 bytes) |
| meta | [router-basic-config-.meta.txt](files/wzh-steps-2026-06-25-19-50/router-basic-config-.meta.txt) |

### router-multisignal-config

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:53:55+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,620p wzh-solution/files/wzh-solution-2026-06-25-10-59/router-multisignal.yaml ` |
| Exit code | 0 |
| stdout | [router-multisignal-config-.stdout.txt](files/wzh-steps-2026-06-25-19-50/router-multisignal-config-.stdout.txt) (459 lines, 11971 bytes) |
| stderr | [router-multisignal-config-.stderr.txt](files/wzh-steps-2026-06-25-19-50/router-multisignal-config-.stderr.txt) (0 lines, 0 bytes) |
| meta | [router-multisignal-config-.meta.txt](files/wzh-steps-2026-06-25-19-50/router-multisignal-config-.meta.txt) |

### router-selection-algorithms-config

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:54:00+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,340p wzh-solution/files/wzh-solution-2026-06-25-10-59/router-selection-algorithms.yaml ` |
| Exit code | 0 |
| stdout | [router-selection-algorithms-config-.stdout.txt](files/wzh-steps-2026-06-25-19-50/router-selection-algorithms-config-.stdout.txt) (226 lines, 5882 bytes) |
| stderr | [router-selection-algorithms-config-.stderr.txt](files/wzh-steps-2026-06-25-19-50/router-selection-algorithms-config-.stderr.txt) (0 lines, 0 bytes) |
| meta | [router-selection-algorithms-config-.meta.txt](files/wzh-steps-2026-06-25-19-50/router-selection-algorithms-config-.meta.txt) |

### router-fused-config

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:54:05+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,380p wzh-solution/files/wzh-solution-2026-06-25-15-25/router-fused-signals-hybrid.yaml ` |
| Exit code | 0 |
| stdout | [router-fused-config-.stdout.txt](files/wzh-steps-2026-06-25-19-50/router-fused-config-.stdout.txt) (354 lines, 9923 bytes) |
| stderr | [router-fused-config-.stderr.txt](files/wzh-steps-2026-06-25-19-50/router-fused-config-.stderr.txt) (0 lines, 0 bytes) |
| meta | [router-fused-config-.meta.txt](files/wzh-steps-2026-06-25-19-50/router-fused-config-.meta.txt) |

### fused-results-summary

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:54:12+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,260p wzh-steps/files/wzh-steps-2026-06-25-15-25/round4-fused-analysis-summary.json ` |
| Exit code | 0 |
| stdout | [fused-results-summary-.stdout.txt](files/wzh-steps-2026-06-25-19-50/fused-results-summary-.stdout.txt) (249 lines, 9492 bytes) |
| stderr | [fused-results-summary-.stderr.txt](files/wzh-steps-2026-06-25-19-50/fused-results-summary-.stderr.txt) (0 lines, 0 bytes) |
| meta | [fused-results-summary-.meta.txt](files/wzh-steps-2026-06-25-19-50/fused-results-summary-.meta.txt) |

### fused-scenario-table

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:54:17+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,220p wzh-steps/files/wzh-steps-2026-06-25-15-25/round4-fused-scenario-table.csv ` |
| Exit code | 0 |
| stdout | [fused-scenario-table-.stdout.txt](files/wzh-steps-2026-06-25-19-50/fused-scenario-table-.stdout.txt) (19 lines, 3652 bytes) |
| stderr | [fused-scenario-table-.stderr.txt](files/wzh-steps-2026-06-25-19-50/fused-scenario-table-.stderr.txt) (0 lines, 0 bytes) |
| meta | [fused-scenario-table-.meta.txt](files/wzh-steps-2026-06-25-19-50/fused-scenario-table-.meta.txt) |

### fused-jsonl-sample

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:54:23+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,3p wzh-steps/files/wzh-steps-2026-06-25-15-25/extracted-round4-final/benchmarks/round4-2026-06-25-15-25/fused-results.jsonl ` |
| Exit code | 0 |
| stdout | [fused-jsonl-sample-.stdout.txt](files/wzh-steps-2026-06-25-19-50/fused-jsonl-sample-.stdout.txt) (3 lines, 8323 bytes) |
| stderr | [fused-jsonl-sample-.stderr.txt](files/wzh-steps-2026-06-25-19-50/fused-jsonl-sample-.stderr.txt) (0 lines, 0 bytes) |
| meta | [fused-jsonl-sample-.meta.txt](files/wzh-steps-2026-06-25-19-50/fused-jsonl-sample-.meta.txt) |

### selection-source-excerpts

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:54:29+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 360,430p src/semantic-router/pkg/extproc/req_filter_classification.go ` |
| Exit code | 0 |
| stdout | [selection-source-excerpts-.stdout.txt](files/wzh-steps-2026-06-25-19-50/selection-source-excerpts-.stdout.txt) (71 lines, 2874 bytes) |
| stderr | [selection-source-excerpts-.stderr.txt](files/wzh-steps-2026-06-25-19-50/selection-source-excerpts-.stderr.txt) (0 lines, 0 bytes) |
| meta | [selection-source-excerpts-.meta.txt](files/wzh-steps-2026-06-25-19-50/selection-source-excerpts-.meta.txt) |

### router-selection-source

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:54:35+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,260p src/semantic-router/pkg/extproc/router_selection.go ` |
| Exit code | 0 |
| stdout | [router-selection-source-.stdout.txt](files/wzh-steps-2026-06-25-19-50/router-selection-source-.stdout.txt) (260 lines, 8949 bytes) |
| stderr | [router-selection-source-.stderr.txt](files/wzh-steps-2026-06-25-19-50/router-selection-source-.stderr.txt) (0 lines, 0 bytes) |
| meta | [router-selection-source-.meta.txt](files/wzh-steps-2026-06-25-19-50/router-selection-source-.meta.txt) |

### algorithm-source-excerpts

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:54:42+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh -lc sed\ -n\ \'120,240p\'\ src/semantic-router/pkg/selection/hybrid.go\;\ sed\ -n\ \'260,340p\'\ src/semantic-router/pkg/selection/router_dc.go\;\ sed\ -n\ \'250,340p\'\ src/semantic-router/pkg/selection/automix.go\;\ sed\ -n\ \'100,190p\'\ src/semantic-router/pkg/selection/multi_factor.go\;\ sed\ -n\ \'50,125p\'\ src/semantic-router/pkg/selection/latency_aware.go ` |
| Exit code | 0 |
| stdout | [algorithm-source-excerpts-.stdout.txt](files/wzh-steps-2026-06-25-19-50/algorithm-source-excerpts-.stdout.txt) (460 lines, 15186 bytes) |
| stderr | [algorithm-source-excerpts-.stderr.txt](files/wzh-steps-2026-06-25-19-50/algorithm-source-excerpts-.stderr.txt) (0 lines, 0 bytes) |
| meta | [algorithm-source-excerpts-.meta.txt](files/wzh-steps-2026-06-25-19-50/algorithm-source-excerpts-.meta.txt) |

### previous-secret-scan

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:54:49+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sed -n 1,220p wzh-steps/files/wzh-steps-2026-06-25-15-25/round4-secret-scan-final-.stdout.txt ` |
| Exit code | 0 |
| stdout | [previous-secret-scan-.stdout.txt](files/wzh-steps-2026-06-25-19-50/previous-secret-scan-.stdout.txt) (4 lines, 179 bytes) |
| stderr | [previous-secret-scan-.stderr.txt](files/wzh-steps-2026-06-25-19-50/previous-secret-scan-.stderr.txt) (0 lines, 0 bytes) |
| meta | [previous-secret-scan-.meta.txt](files/wzh-steps-2026-06-25-19-50/previous-secret-scan-.meta.txt) |

### git-status-before-report

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T19:54:54+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `git status --short ` |
| Exit code | 0 |
| stdout | [git-status-before-report-.stdout.txt](files/wzh-steps-2026-06-25-19-50/git-status-before-report-.stdout.txt) (7 lines, 293 bytes) |
| stderr | [git-status-before-report-.stderr.txt](files/wzh-steps-2026-06-25-19-50/git-status-before-report-.stderr.txt) (0 lines, 0 bytes) |
| meta | [git-status-before-report-.meta.txt](files/wzh-steps-2026-06-25-19-50/git-status-before-report-.meta.txt) |

### report-wc-headings

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T20:01:00+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh -lc wc\ -l\ wzh-solution/wzh-solution-2026.06.25.19.50.md\ wzh-steps/wzh-steps-2026.06.25.19.50.md\;\ rg\ -n\ \'\^\(\#\|\#\#\|\#\#\#\)\ \'\ wzh-solution/wzh-solution-2026.06.25.19.50.md ` |
| Exit code | 0 |
| stdout | [report-wc-headings-.stdout.txt](files/wzh-steps-2026-06-25-19-50/report-wc-headings-.stdout.txt) (59 lines, 2463 bytes) |
| stderr | [report-wc-headings-.stderr.txt](files/wzh-steps-2026-06-25-19-50/report-wc-headings-.stderr.txt) (0 lines, 0 bytes) |
| meta | [report-wc-headings-.meta.txt](files/wzh-steps-2026-06-25-19-50/report-wc-headings-.meta.txt) |

### new-artifact-secret-scan

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T20:01:12+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh -lc rg\ -n\ -i\ \'\(AKIA\[0-9A-Z\]\{16\}\|aws_secret\|secret_access_key\|BEGIN\ \(RSA\|OPENSSH\|EC\)\ PRIVATE\ KEY\|hf_\[A-Za-z0-9\]\{20,\}\|sk-\[A-Za-z0-9\]\{20,\}\|sshpass\|SSHPASS\|bastion\\.\|password\[:=\]\|token\[:=\]\|api\[_-\]\?key\[:=\]\)\'\ todo.md\ wzh-solution/wzh-solution-2026.06.25.19.50.md\ wzh-steps/wzh-steps-2026.06.25.19.50.md\ wzh-steps/files/wzh-steps-2026-06-25-19-50\ \|\|\ true ` |
| Exit code | 0 |
| stdout | [new-artifact-secret-scan-.stdout.txt](files/wzh-steps-2026-06-25-19-50/new-artifact-secret-scan-.stdout.txt) (1 lines, 496 bytes) |
| stderr | [new-artifact-secret-scan-.stderr.txt](files/wzh-steps-2026-06-25-19-50/new-artifact-secret-scan-.stderr.txt) (0 lines, 0 bytes) |
| meta | [new-artifact-secret-scan-.meta.txt](files/wzh-steps-2026-06-25-19-50/new-artifact-secret-scan-.meta.txt) |

### new-report-secret-scan

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T20:01:30+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh -lc rg\ -n\ -i\ \'\(AKIA\[0-9A-Z\]\{16\}\|aws_secret\|secret_access_key\|BEGIN\ \(RSA\|OPENSSH\|EC\)\ PRIVATE\ KEY\|hf_\[A-Za-z0-9\]\{20,\}\|sk-\[A-Za-z0-9\]\{20,\}\|sshpass\|SSHPASS\|bastion\\.\|password\[:=\]\|token\[:=\]\|api\[_-\]\?key\[:=\]\)\'\ todo.md\ wzh-solution/wzh-solution-2026.06.25.19.50.md\ wzh-steps/wzh-steps-2026.06.25.19.50.md\ \|\|\ true ` |
| Exit code | 0 |
| stdout | [new-report-secret-scan-.stdout.txt](files/wzh-steps-2026-06-25-19-50/new-report-secret-scan-.stdout.txt) (1 lines, 468 bytes) |
| stderr | [new-report-secret-scan-.stderr.txt](files/wzh-steps-2026-06-25-19-50/new-report-secret-scan-.stderr.txt) (0 lines, 0 bytes) |
| meta | [new-report-secret-scan-.meta.txt](files/wzh-steps-2026-06-25-19-50/new-report-secret-scan-.meta.txt) |

### new-report-body-secret-scan

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T20:01:50+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `zsh -lc rg\ -n\ -i\ \'\(AKIA\[0-9A-Z\]\{16\}\|aws_secret\|secret_access_key\|BEGIN\ \(RSA\|OPENSSH\|EC\)\ PRIVATE\ KEY\|hf_\[A-Za-z0-9\]\{20,\}\|sk-\[A-Za-z0-9\]\{20,\}\|sshpass\|SSHPASS\|bastion\\.\|password\[:=\]\|token\[:=\]\|api\[_-\]\?key\[:=\]\)\'\ todo.md\ wzh-solution/wzh-solution-2026.06.25.19.50.md\ \|\|\ true ` |
| Exit code | 0 |
| stdout | [new-report-body-secret-scan-.stdout.txt](files/wzh-steps-2026-06-25-19-50/new-report-body-secret-scan-.stdout.txt) (0 lines, 0 bytes) |
| stderr | [new-report-body-secret-scan-.stderr.txt](files/wzh-steps-2026-06-25-19-50/new-report-body-secret-scan-.stderr.txt) (0 lines, 0 bytes) |
| meta | [new-report-body-secret-scan-.meta.txt](files/wzh-steps-2026-06-25-19-50/new-report-body-secret-scan-.meta.txt) |

### final-todo-status

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T20:02:40+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `tail -40 todo.md ` |
| Exit code | 0 |
| stdout | [final-todo-status-.stdout.txt](files/wzh-steps-2026-06-25-19-50/final-todo-status-.stdout.txt) (40 lines, 4355 bytes) |
| stderr | [final-todo-status-.stderr.txt](files/wzh-steps-2026-06-25-19-50/final-todo-status-.stderr.txt) (0 lines, 0 bytes) |
| meta | [final-todo-status-.meta.txt](files/wzh-steps-2026-06-25-19-50/final-todo-status-.meta.txt) |

### git-status-final

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T20:02:53+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `git status --short ` |
| Exit code | 0 |
| stdout | [git-status-final-.stdout.txt](files/wzh-steps-2026-06-25-19-50/git-status-final-.stdout.txt) (8 lines, 342 bytes) |
| stderr | [git-status-final-.stderr.txt](files/wzh-steps-2026-06-25-19-50/git-status-final-.stderr.txt) (0 lines, 0 bytes) |
| meta | [git-status-final-.meta.txt](files/wzh-steps-2026-06-25-19-50/git-status-final-.meta.txt) |

### agent-report-final

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T20:03:06+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `make agent-report ENV=cpu CHANGED_FILES=todo.md\ wzh-solution/wzh-solution-2026.06.25.19.50.md\ wzh-steps/wzh-steps-2026.06.25.19.50.md\ wzh-steps/files/wzh-steps-2026-06-25-19-50/runlog.zsh ` |
| Exit code | 0 |
| stdout | [agent-report-final-.stdout.txt](files/wzh-steps-2026-06-25-19-50/agent-report-final-.stdout.txt) (59 lines, 4720 bytes) |
| stderr | [agent-report-final-.stderr.txt](files/wzh-steps-2026-06-25-19-50/agent-report-final-.stderr.txt) (1 lines, 276 bytes) |
| meta | [agent-report-final-.meta.txt](files/wzh-steps-2026-06-25-19-50/agent-report-final-.meta.txt) |

### git-status-after-agent-report

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T20:03:14+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `git status --short ` |
| Exit code | 0 |
| stdout | [git-status-after-agent-report-.stdout.txt](files/wzh-steps-2026-06-25-19-50/git-status-after-agent-report-.stdout.txt) (8 lines, 342 bytes) |
| stderr | [git-status-after-agent-report-.stderr.txt](files/wzh-steps-2026-06-25-19-50/git-status-after-agent-report-.stderr.txt) (0 lines, 0 bytes) |
| meta | [git-status-after-agent-report-.meta.txt](files/wzh-steps-2026-06-25-19-50/git-status-after-agent-report-.meta.txt) |
