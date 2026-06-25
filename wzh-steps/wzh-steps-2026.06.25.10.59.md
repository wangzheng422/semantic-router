# Round 2 command audit: non-keyword routing and model-selection algorithms

| Field | Value |
|---|---|
| Timestamp | 2026-06-25 10:59 Asia/Shanghai |
| Workspace | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Remote VM workspace | `/var/mnt/semantic-router-bench` |
| Scope | Extend round 1 VM validation beyond keyword routing to project-supported signals and model-selection algorithms. |

## Command log

Raw command logs are stored under [files/wzh-steps-2026-06-25-10-59](files/wzh-steps-2026-06-25-10-59/). Each logged command has a `.meta.txt`, `.stdout.txt`, and `.stderr.txt` file.

## Evidence artifacts

- [round 2 result archive](files/wzh-steps-2026-06-25-10-59/semantic-router-round2-results-2026-06-25-10-59.tgz): complete remote result bundle copied back from the GPU VM.
- [extracted round 2 results](files/wzh-steps-2026-06-25-10-59/extracted-round2/benchmarks/round2-2026-06-25-10-59/): unpacked JSONL, summaries, and router logs.
- [multi-signal summary](files/wzh-steps-2026-06-25-10-59/extracted-round2/benchmarks/round2-2026-06-25-10-59/multisignal-summary.json): 20 OpenAI SDK scenarios, 20 successful responses, 11 routed to `qwen35-27b-fp8`, 9 routed to `qwen35-2b`.
- [model-selection summary](files/wzh-steps-2026-06-25-10-59/extracted-round2/benchmarks/round2-2026-06-25-10-59/selection-algorithms-summary.json): 10 OpenAI SDK scenarios, 10 successful responses, covering router_dc, automix, hybrid, multi_factor, and latency_aware.
- [multi-signal raw JSONL](files/wzh-steps-2026-06-25-10-59/extracted-round2/benchmarks/round2-2026-06-25-10-59/multisignal-results.jsonl): full per-request headers and preview fields.
- [model-selection raw JSONL](files/wzh-steps-2026-06-25-10-59/extracted-round2/benchmarks/round2-2026-06-25-10-59/selection-algorithms-results.jsonl): full per-request headers and preview fields.
- The final `remote_selection_only.sh` run restored `vsr-router` to `router-basic.yaml`.

### local-py-compile

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:05:09+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `python -m py_compile wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_multisignal.py wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_selection_algorithms.py ` |
| Exit code | 0 |
| stdout | [local-py-compile-.stdout.txt](files/wzh-steps-2026-06-25-10-59/local-py-compile-.stdout.txt) (0 lines, 0 bytes) |
| stderr | [local-py-compile-.stderr.txt](files/wzh-steps-2026-06-25-10-59/local-py-compile-.stderr.txt) (0 lines, 0 bytes) |
| meta | [local-py-compile-.meta.txt](files/wzh-steps-2026-06-25-10-59/local-py-compile-.meta.txt) |

### local-yaml-parse

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:05:09+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `python -c import\ yaml\;\ from\ pathlib\ import\ Path\;\ paths=\[Path\(\'wzh-solution/files/wzh-solution-2026-06-25-10-59/router-multisignal.yaml\'\),\ Path\(\'wzh-solution/files/wzh-solution-2026-06-25-10-59/router-selection-algorithms.yaml\'\)\]\;\ \[print\(p,\ yaml.safe_load\(p.open\(\)\).get\(\'version\'\),\ len\(yaml.safe_load\(p.open\(\)\).get\(\'routing\',\ \{\}\).get\(\'decisions\',\ \[\]\)\)\)\ for\ p\ in\ paths\] ` |
| Exit code | 0 |
| stdout | [local-yaml-parse-.stdout.txt](files/wzh-steps-2026-06-25-10-59/local-yaml-parse-.stdout.txt) (2 lines, 170 bytes) |
| stderr | [local-yaml-parse-.stderr.txt](files/wzh-steps-2026-06-25-10-59/local-yaml-parse-.stderr.txt) (0 lines, 0 bytes) |
| meta | [local-yaml-parse-.meta.txt](files/wzh-steps-2026-06-25-10-59/local-yaml-parse-.meta.txt) |

### local-remote-script-sh-n

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:07:03+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `sh -n wzh-solution/files/wzh-solution-2026-06-25-10-59/remote_round2.sh ` |
| Exit code | 0 |
| stdout | [local-remote-script-sh-n-.stdout.txt](files/wzh-steps-2026-06-25-10-59/local-remote-script-sh-n-.stdout.txt) (0 lines, 0 bytes) |
| stderr | [local-remote-script-sh-n-.stderr.txt](files/wzh-steps-2026-06-25-10-59/local-remote-script-sh-n-.stderr.txt) (0 lines, 0 bytes) |
| meta | [local-remote-script-sh-n-.meta.txt](files/wzh-steps-2026-06-25-10-59/local-remote-script-sh-n-.meta.txt) |

### local-py-compile-after-error-capture

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:07:03+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `python -m py_compile wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_multisignal.py wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_selection_algorithms.py ` |
| Exit code | 0 |
| stdout | [local-py-compile-after-error-capture-.stdout.txt](files/wzh-steps-2026-06-25-10-59/local-py-compile-after-error-capture-.stdout.txt) (0 lines, 0 bytes) |
| stderr | [local-py-compile-after-error-capture-.stderr.txt](files/wzh-steps-2026-06-25-10-59/local-py-compile-after-error-capture-.stderr.txt) (0 lines, 0 bytes) |
| meta | [local-py-compile-after-error-capture-.meta.txt](files/wzh-steps-2026-06-25-10-59/local-py-compile-after-error-capture-.meta.txt) |

### local-yaml-parse-after-patch

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:07:03+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `python -c import\ yaml\;\ from\ pathlib\ import\ Path\;\ paths=\[Path\(\'wzh-solution/files/wzh-solution-2026-06-25-10-59/router-multisignal.yaml\'\),\ Path\(\'wzh-solution/files/wzh-solution-2026-06-25-10-59/router-selection-algorithms.yaml\'\)\]\;\ \[print\(p,\ yaml.safe_load\(p.open\(\)\).get\(\'version\'\),\ len\(yaml.safe_load\(p.open\(\)\).get\(\'routing\',\ \{\}\).get\(\'decisions\',\ \[\]\)\)\)\ for\ p\ in\ paths\] ` |
| Exit code | 0 |
| stdout | [local-yaml-parse-after-patch-.stdout.txt](files/wzh-steps-2026-06-25-10-59/local-yaml-parse-after-patch-.stdout.txt) (2 lines, 170 bytes) |
| stderr | [local-yaml-parse-after-patch-.stderr.txt](files/wzh-steps-2026-06-25-10-59/local-yaml-parse-after-patch-.stderr.txt) (0 lines, 0 bytes) |
| meta | [local-yaml-parse-after-patch-.meta.txt](files/wzh-steps-2026-06-25-10-59/local-yaml-parse-after-patch-.meta.txt) |

### remote-round2-preflight

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:07:20+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ -o\ ConnectTimeout=20\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'set\ -euo\ pipefail\;\ hostname\;\ date\ -Is\;\ podman\ ps\ --format\ \"\{\{.Names\}\}\ \{\{.Status\}\}\ \{\{.Ports\}\}\"\ \|\ grep\ -E\ \"vsr-qwen\|vsr-router\|vsr-envoy\"\;\ curl\ -fsS\ http://127.0.0.1:18888/v1/models\ \|\ head\ -c\ 1000\;\ echo\' ` |
| Exit code | 0 |
| stdout | [remote-round2-preflight-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-round2-preflight-.stdout.txt) (7 lines, 947 bytes) |
| stderr | [remote-round2-preflight-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-round2-preflight-.stderr.txt) (1 lines, 106 bytes) |
| meta | [remote-round2-preflight-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-round2-preflight-.meta.txt) |

### remote-sync-round2-artifacts

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:07:53+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'mkdir\ -p\ /var/mnt/semantic-router-bench/configs\ /var/mnt/semantic-router-bench/traffic\ /var/mnt/semantic-router-bench/benchmarks/round2-2026-06-25-10-59\'\;\ sshpass\ -e\ scp\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ wzh-solution/files/wzh-solution-2026-06-25-10-59/router-multisignal.yaml\ wzh-solution/files/wzh-solution-2026-06-25-10-59/router-selection-algorithms.yaml\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com:/var/mnt/semantic-router-bench/configs/\;\ sshpass\ -e\ scp\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_multisignal.py\ wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_selection_algorithms.py\ wzh-solution/files/wzh-solution-2026-06-25-10-59/remote_round2.sh\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com:/var/mnt/semantic-router-bench/traffic/\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'chmod\ +x\ /var/mnt/semantic-router-bench/traffic/\*.py\ /var/mnt/semantic-router-bench/traffic/remote_round2.sh\;\ ls\ -l\ /var/mnt/semantic-router-bench/configs/router-multisignal.yaml\ /var/mnt/semantic-router-bench/configs/router-selection-algorithms.yaml\ /var/mnt/semantic-router-bench/traffic/traffic_multisignal.py\ /var/mnt/semantic-router-bench/traffic/traffic_selection_algorithms.py\ /var/mnt/semantic-router-bench/traffic/remote_round2.sh\' ` |
| Exit code | 139 |
| stdout | [remote-sync-round2-artifacts-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-round2-artifacts-.stdout.txt) (0 lines, 0 bytes) |
| stderr | [remote-sync-round2-artifacts-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-round2-artifacts-.stderr.txt) (4 lines, 288 bytes) |
| meta | [remote-sync-round2-artifacts-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-round2-artifacts-.meta.txt) |

### remote-sync-round2-artifacts-exported

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:08:28+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc export\ SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'mkdir\ -p\ /var/mnt/semantic-router-bench/configs\ /var/mnt/semantic-router-bench/traffic\ /var/mnt/semantic-router-bench/benchmarks/round2-2026-06-25-10-59\'\;\ sshpass\ -e\ scp\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ wzh-solution/files/wzh-solution-2026-06-25-10-59/router-multisignal.yaml\ wzh-solution/files/wzh-solution-2026-06-25-10-59/router-selection-algorithms.yaml\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com:/var/mnt/semantic-router-bench/configs/\;\ sshpass\ -e\ scp\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_multisignal.py\ wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_selection_algorithms.py\ wzh-solution/files/wzh-solution-2026-06-25-10-59/remote_round2.sh\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com:/var/mnt/semantic-router-bench/traffic/\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'chmod\ +x\ /var/mnt/semantic-router-bench/traffic/\*.py\ /var/mnt/semantic-router-bench/traffic/remote_round2.sh\;\ ls\ -l\ /var/mnt/semantic-router-bench/configs/router-multisignal.yaml\ /var/mnt/semantic-router-bench/configs/router-selection-algorithms.yaml\ /var/mnt/semantic-router-bench/traffic/traffic_multisignal.py\ /var/mnt/semantic-router-bench/traffic/traffic_selection_algorithms.py\ /var/mnt/semantic-router-bench/traffic/remote_round2.sh\' ` |
| Exit code | 0 |
| stdout | [remote-sync-round2-artifacts-exported-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-round2-artifacts-exported-.stdout.txt) (5 lines, 574 bytes) |
| stderr | [remote-sync-round2-artifacts-exported-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-round2-artifacts-exported-.stderr.txt) (4 lines, 424 bytes) |
| meta | [remote-sync-round2-artifacts-exported-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-round2-artifacts-exported-.meta.txt) |

### remote-run-round2

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:09:09+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc export\ SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ -o\ ServerAliveInterval=20\ -o\ ServerAliveCountMax=6\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'/var/mnt/semantic-router-bench/traffic/remote_round2.sh\' ` |
| Exit code | 22 |
| stdout | [remote-run-round2-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-run-round2-.stdout.txt) (5 lines, 317 bytes) |
| stderr | [remote-run-round2-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-run-round2-.stderr.txt) (2 lines, 155 bytes) |
| meta | [remote-run-round2-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-run-round2-.meta.txt) |

### remote-debug-multisignal-models-500

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:09:37+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc export\ SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'set\ +e\;\ echo\ \"\#\#\ health\"\;\ curl\ -i\ http://127.0.0.1:18080/health\;\ echo\;\ echo\ \"\#\#\ direct\ models\"\;\ curl\ -i\ http://127.0.0.1:18080/v1/models\;\ echo\;\ echo\ \"\#\#\ envoy\ models\"\;\ curl\ -i\ http://127.0.0.1:18888/v1/models\;\ echo\;\ echo\ \"\#\#\ router\ logs\"\;\ podman\ logs\ --tail=220\ vsr-router\;\ echo\ \"\#\#\ envoy\ logs\"\;\ podman\ logs\ --tail=120\ vsr-envoy\' ` |
| Exit code | 0 |
| stdout | [remote-debug-multisignal-models-500-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-debug-multisignal-models-500-.stdout.txt) (91 lines, 8239 bytes) |
| stderr | [remote-debug-multisignal-models-500-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-debug-multisignal-models-500-.stderr.txt) (24 lines, 4684 bytes) |
| meta | [remote-debug-multisignal-models-500-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-debug-multisignal-models-500-.meta.txt) |

### local-round2-fix-validate

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:10:47+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc python\ -c\ \"import\ yaml\;\ from\ pathlib\ import\ Path\;\ paths=\[Path\(\\\"wzh-solution/files/wzh-solution-2026-06-25-10-59/router-multisignal.yaml\\\"\),\ Path\(\\\"wzh-solution/files/wzh-solution-2026-06-25-10-59/router-selection-algorithms.yaml\\\"\)\]\;\ \[print\(p,\ yaml.safe_load\(p.open\(\)\).get\(\\\"version\\\"\),\ len\(yaml.safe_load\(p.open\(\)\).get\(\\\"routing\\\",\ \{\}\).get\(\\\"decisions\\\",\ \[\]\)\)\)\ for\ p\ in\ paths\]\"\;\ python\ -m\ py_compile\ wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_multisignal.py\ wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_selection_algorithms.py\;\ sh\ -n\ wzh-solution/files/wzh-solution-2026-06-25-10-59/remote_round2.sh ` |
| Exit code | 0 |
| stdout | [local-round2-fix-validate-.stdout.txt](files/wzh-steps-2026-06-25-10-59/local-round2-fix-validate-.stdout.txt) (2 lines, 170 bytes) |
| stderr | [local-round2-fix-validate-.stderr.txt](files/wzh-steps-2026-06-25-10-59/local-round2-fix-validate-.stderr.txt) (0 lines, 0 bytes) |
| meta | [local-round2-fix-validate-.meta.txt](files/wzh-steps-2026-06-25-10-59/local-round2-fix-validate-.meta.txt) |

### remote-sync-round2-fixes

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:11:04+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc export\ SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\;\ sshpass\ -e\ scp\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ wzh-solution/files/wzh-solution-2026-06-25-10-59/router-multisignal.yaml\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com:/var/mnt/semantic-router-bench/configs/router-multisignal.yaml\;\ sshpass\ -e\ scp\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ wzh-solution/files/wzh-solution-2026-06-25-10-59/remote_round2.sh\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com:/var/mnt/semantic-router-bench/traffic/remote_round2.sh\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'chmod\ +x\ /var/mnt/semantic-router-bench/traffic/remote_round2.sh\;\ ls\ -l\ /var/mnt/semantic-router-bench/configs/router-multisignal.yaml\ /var/mnt/semantic-router-bench/traffic/remote_round2.sh\' ` |
| Exit code | 0 |
| stdout | [remote-sync-round2-fixes-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-round2-fixes-.stdout.txt) (2 lines, 219 bytes) |
| stderr | [remote-sync-round2-fixes-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-round2-fixes-.stderr.txt) (3 lines, 318 bytes) |
| meta | [remote-sync-round2-fixes-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-round2-fixes-.meta.txt) |

### remote-run-round2-fixed

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:11:30+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc export\ SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ -o\ ServerAliveInterval=20\ -o\ ServerAliveCountMax=12\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'/var/mnt/semantic-router-bench/traffic/remote_round2.sh\' ` |
| Exit code | 70 |
| stdout | [remote-run-round2-fixed-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-run-round2-fixed-.stdout.txt) (270 lines, 81844 bytes) |
| stderr | [remote-run-round2-fixed-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-run-round2-fixed-.stderr.txt) (1 lines, 106 bytes) |
| meta | [remote-run-round2-fixed-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-run-round2-fixed-.meta.txt) |

### local-round2-authz-elo-fix-validate

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:13:12+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc python\ -c\ \"import\ yaml\;\ from\ pathlib\ import\ Path\;\ paths=\[Path\(\\\"wzh-solution/files/wzh-solution-2026-06-25-10-59/router-multisignal.yaml\\\"\),\ Path\(\\\"wzh-solution/files/wzh-solution-2026-06-25-10-59/router-selection-algorithms.yaml\\\"\)\]\;\ \[print\(p,\ yaml.safe_load\(p.open\(\)\).get\(\\\"version\\\"\),\ len\(yaml.safe_load\(p.open\(\)\).get\(\\\"routing\\\",\ \{\}\).get\(\\\"decisions\\\",\ \[\]\)\)\)\ for\ p\ in\ paths\]\"\;\ python\ -m\ py_compile\ wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_multisignal.py\ wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_selection_algorithms.py\;\ sh\ -n\ wzh-solution/files/wzh-solution-2026-06-25-10-59/remote_round2.sh ` |
| Exit code | 0 |
| stdout | [local-round2-authz-elo-fix-validate-.stdout.txt](files/wzh-steps-2026-06-25-10-59/local-round2-authz-elo-fix-validate-.stdout.txt) (2 lines, 170 bytes) |
| stderr | [local-round2-authz-elo-fix-validate-.stderr.txt](files/wzh-steps-2026-06-25-10-59/local-round2-authz-elo-fix-validate-.stderr.txt) (0 lines, 0 bytes) |
| meta | [local-round2-authz-elo-fix-validate-.meta.txt](files/wzh-steps-2026-06-25-10-59/local-round2-authz-elo-fix-validate-.meta.txt) |

### remote-sync-round2-authz-elo-fixes

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:13:27+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc export\ SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\;\ sshpass\ -e\ scp\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ wzh-solution/files/wzh-solution-2026-06-25-10-59/router-selection-algorithms.yaml\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com:/var/mnt/semantic-router-bench/configs/router-selection-algorithms.yaml\;\ sshpass\ -e\ scp\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_multisignal.py\ wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_selection_algorithms.py\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com:/var/mnt/semantic-router-bench/traffic/\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'chmod\ +x\ /var/mnt/semantic-router-bench/traffic/traffic_multisignal.py\ /var/mnt/semantic-router-bench/traffic/traffic_selection_algorithms.py\;\ ls\ -l\ /var/mnt/semantic-router-bench/configs/router-selection-algorithms.yaml\ /var/mnt/semantic-router-bench/traffic/traffic_multisignal.py\ /var/mnt/semantic-router-bench/traffic/traffic_selection_algorithms.py\' ` |
| Exit code | 0 |
| stdout | [remote-sync-round2-authz-elo-fixes-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-round2-authz-elo-fixes-.stdout.txt) (3 lines, 352 bytes) |
| stderr | [remote-sync-round2-authz-elo-fixes-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-round2-authz-elo-fixes-.stderr.txt) (3 lines, 318 bytes) |
| meta | [remote-sync-round2-authz-elo-fixes-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-round2-authz-elo-fixes-.meta.txt) |

### remote-run-round2-authz-elo-fixed

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:13:55+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc export\ SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ -o\ ServerAliveInterval=20\ -o\ ServerAliveCountMax=12\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'/var/mnt/semantic-router-bench/traffic/remote_round2.sh\' ` |
| Exit code | 70 |
| stdout | [remote-run-round2-authz-elo-fixed-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-run-round2-authz-elo-fixed-.stdout.txt) (384 lines, 85155 bytes) |
| stderr | [remote-run-round2-authz-elo-fixed-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-run-round2-authz-elo-fixed-.stderr.txt) (1 lines, 106 bytes) |
| meta | [remote-run-round2-authz-elo-fixed-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-run-round2-authz-elo-fixed-.meta.txt) |

### local-round2-selection-only-validate

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:17:37+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc python\ -c\ \"import\ yaml\;\ from\ pathlib\ import\ Path\;\ p=Path\(\\\"wzh-solution/files/wzh-solution-2026-06-25-10-59/router-selection-algorithms.yaml\\\"\)\;\ data=yaml.safe_load\(p.open\(\)\)\;\ print\(p,\ data.get\(\\\"version\\\"\),\ len\(data.get\(\\\"routing\\\",\ \{\}\).get\(\\\"decisions\\\",\ \[\]\)\)\)\"\;\ python\ -m\ py_compile\ wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_selection_algorithms.py\;\ sh\ -n\ wzh-solution/files/wzh-solution-2026-06-25-10-59/remote_selection_only.sh ` |
| Exit code | 0 |
| stdout | [local-round2-selection-only-validate-.stdout.txt](files/wzh-steps-2026-06-25-10-59/local-round2-selection-only-validate-.stdout.txt) (1 lines, 89 bytes) |
| stderr | [local-round2-selection-only-validate-.stderr.txt](files/wzh-steps-2026-06-25-10-59/local-round2-selection-only-validate-.stderr.txt) (0 lines, 0 bytes) |
| meta | [local-round2-selection-only-validate-.meta.txt](files/wzh-steps-2026-06-25-10-59/local-round2-selection-only-validate-.meta.txt) |

### remote-sync-selection-only

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:17:56+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc export\ SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\;\ sshpass\ -e\ scp\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ wzh-solution/files/wzh-solution-2026-06-25-10-59/router-selection-algorithms.yaml\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com:/var/mnt/semantic-router-bench/configs/router-selection-algorithms.yaml\;\ sshpass\ -e\ scp\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ wzh-solution/files/wzh-solution-2026-06-25-10-59/traffic_selection_algorithms.py\ wzh-solution/files/wzh-solution-2026-06-25-10-59/remote_selection_only.sh\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com:/var/mnt/semantic-router-bench/traffic/\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'chmod\ +x\ /var/mnt/semantic-router-bench/traffic/traffic_selection_algorithms.py\ /var/mnt/semantic-router-bench/traffic/remote_selection_only.sh\;\ ls\ -l\ /var/mnt/semantic-router-bench/configs/router-selection-algorithms.yaml\ /var/mnt/semantic-router-bench/traffic/traffic_selection_algorithms.py\ /var/mnt/semantic-router-bench/traffic/remote_selection_only.sh\' ` |
| Exit code | 0 |
| stdout | [remote-sync-selection-only-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-selection-only-.stdout.txt) (3 lines, 354 bytes) |
| stderr | [remote-sync-selection-only-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-selection-only-.stderr.txt) (3 lines, 318 bytes) |
| meta | [remote-sync-selection-only-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-sync-selection-only-.meta.txt) |

### remote-selection-progress-check

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:22:14+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc export\ SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'set\ +e\;\ f=/var/mnt/semantic-router-bench/benchmarks/round2-2026-06-25-10-59/selection-algorithms-results.jsonl\;\ ls\ -l\ \"\$f\"\;\ wc\ -l\ \"\$f\"\;\ tail\ -5\ \"\$f\"\;\ echo\ \"\#\#\ ps\"\;\ podman\ ps\ --format\ \"\{\{.Names\}\}\ \{\{.Status\}\}\"\ \|\ grep\ -E\ \"vsr-router\|vllm\|envoy\"\;\ echo\ \"\#\#\ recent\ envoy\"\;\ podman\ logs\ --tail=20\ vsr-envoy\' ` |
| Exit code | 0 |
| stdout | [remote-selection-progress-check-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-selection-progress-check-.stdout.txt) (31 lines, 6961 bytes) |
| stderr | [remote-selection-progress-check-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-selection-progress-check-.stderr.txt) (1 lines, 106 bytes) |
| meta | [remote-selection-progress-check-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-selection-progress-check-.meta.txt) |

### remote-run-selection-only

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:19:15+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc export\ SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ -o\ ServerAliveInterval=20\ -o\ ServerAliveCountMax=12\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'/var/mnt/semantic-router-bench/traffic/remote_selection_only.sh\' ` |
| Exit code | 0 |
| stdout | [remote-run-selection-only-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-run-selection-only-.stdout.txt) (133 lines, 19236 bytes) |
| stderr | [remote-run-selection-only-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-run-selection-only-.stderr.txt) (1 lines, 106 bytes) |
| meta | [remote-run-selection-only-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-run-selection-only-.meta.txt) |

### remote-fetch-round2-results

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:22:50+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc export\ SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\;\ sshpass\ -e\ scp\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com:/var/mnt/semantic-router-bench/benchmarks/semantic-router-round2-results-2026-06-25-10-59.tgz\ wzh-steps/files/wzh-steps-2026-06-25-10-59/semantic-router-round2-results-2026-06-25-10-59.tgz\;\ tar\ tzf\ wzh-steps/files/wzh-steps-2026-06-25-10-59/semantic-router-round2-results-2026-06-25-10-59.tgz\ \|\ sed\ -n\ \"1,120p\"\;\ ls\ -lh\ wzh-steps/files/wzh-steps-2026-06-25-10-59/semantic-router-round2-results-2026-06-25-10-59.tgz ` |
| Exit code | 0 |
| stdout | [remote-fetch-round2-results-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-fetch-round2-results-.stdout.txt) (18 lines, 1110 bytes) |
| stderr | [remote-fetch-round2-results-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-fetch-round2-results-.stderr.txt) (1 lines, 106 bytes) |
| meta | [remote-fetch-round2-results-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-fetch-round2-results-.meta.txt) |

### remote-final-basic-health

| Field | Value |
|---|---|
| Timestamp | 2026-06-25T11:24:27+0800 |
| Working directory | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Command | `/bin/zsh -lc export\ SSHPASS=\"\$\(awk\ \'f\{print\;exit\}/Password/\{f=1\}\'\ .wzh/env.txt\)\"\;\ sshpass\ -e\ ssh\ -o\ StrictHostKeyChecking=no\ -o\ UserKnownHostsFile=/dev/null\ cloud-user@bastion.75s2z.sandbox2921.opentlc.com\ \'set\ -euo\ pipefail\;\ curl\ -fsS\ http://127.0.0.1:18080/health\;\ echo\;\ podman\ ps\ --format\ \"\{\{.Names\}\}\ \{\{.Status\}\}\ \{\{.Ports\}\}\"\ \|\ grep\ -E\ \"vsr-router\|vsr-envoy\|vsr-qwen\"\;\ podman\ inspect\ vsr-router\ --format\ \"\{\{range\ .Mounts\}\}\{\{println\ .Source\ \\\"-\>\\\"\ .Destination\}\}\{\{end\}\}\"\ \|\ grep\ config.yaml\' ` |
| Exit code | 0 |
| stdout | [remote-final-basic-health-.stdout.txt](files/wzh-steps-2026-06-25-10-59/remote-final-basic-health-.stdout.txt) (6 lines, 416 bytes) |
| stderr | [remote-final-basic-health-.stderr.txt](files/wzh-steps-2026-06-25-10-59/remote-final-basic-health-.stderr.txt) (1 lines, 106 bytes) |
| meta | [remote-final-basic-health-.meta.txt](files/wzh-steps-2026-06-25-10-59/remote-final-basic-health-.meta.txt) |
