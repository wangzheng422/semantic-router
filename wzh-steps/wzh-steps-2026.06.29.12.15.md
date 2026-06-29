# Round 11 Steps: self-contained operations guide

| Field | Value |
|---|---|
| Date | 2026-06-29 |
| Scope | Create a self-contained Chinese operations guide from beginner to advanced, including environment configuration |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |

## Commands

### Inspect round timestamp

| Field | Value |
|---|---|
| Command | `date '+%Y.%m.%d.%H.%M'` |
| Exit code | 0 |
| stdout | `2026.06.29.12.15` |
| stderr | empty |

### Read source artifacts

| Field | Value |
|---|---|
| Command | `sed -n '1,240p' wzh-solution/wzh-solution-2026.06.29.10.40.md` |
| Exit code | 0 |
| stdout | Read the round 10 recovery/dashboard summary. |
| stderr | empty |

| Field | Value |
|---|---|
| Command | `sed -n '1,620p' wzh-solution/files/wzh-solution-2026-06-29-10-40/router-round10-dashboard-demo.yaml` |
| Exit code | 0 |
| stdout | Read the complete complex semantic-router demo config. |
| stderr | empty |

| Field | Value |
|---|---|
| Command | `sed -n '1,260p' wzh-solution/files/wzh-solution-2026-06-29-10-40/envoy-round10-dashboard-demo.yaml` |
| Exit code | 0 |
| stdout | Read the complete Envoy ext_proc routing config. |
| stderr | empty |

| Field | Value |
|---|---|
| Command | `sed -n '1,220p' wzh-solution/files/wzh-solution-2026-06-29-10-40/traffic_round10_demo.py` |
| Exit code | 0 |
| stdout | Read the round 10 OpenAI-compatible traffic script. |
| stderr | empty |

| Field | Value |
|---|---|
| Command | `sed -n '1,220p' wzh-steps/files/wzh-steps-2026-06-29-10-40/remote-demo-traffic-final-.stdout.txt` |
| Exit code | 0 |
| stdout | Read the validated routing outputs for simple, complex, multi-turn, cache, and model-list scenarios. |
| stderr | empty |

### Create guide

| Field | Value |
|---|---|
| Command | `apply_patch` |
| Exit code | 0 |
| stdout | Updated `todo.md`, created this steps file, and created `wzh-solution/wzh-solution-2026.06.29.12.15.md`. |
| stderr | empty |

### Extend guide into customer-run experiment manual

| Field | Value |
|---|---|
| Command | `apply_patch` |
| Exit code | 0 |
| stdout | Added a customer-facing experiment runbook section with scenario goals, setup, configs, commands, request payloads, expected headers, pass/fail criteria, troubleshooting, dashboard cleanup, and acceptance checklist. |
| stderr | empty |
