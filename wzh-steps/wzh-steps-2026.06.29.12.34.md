# Round 12 Steps: Red Hat 风格 E2E 汇报 PPT

## Environment

| 字段 | 值 |
|---|---|
| CWD | `/Users/zhengwan/Desktop/dev/semantic-router` |
| Shell | `zsh` |
| 日期 | 2026-06-29 |
| 本地预览 URL | `http://127.0.0.1:4311/semantic-router-redhat-report/Semantic%20Router%20E2E%20Report.html` |

## Command Log

### 1. Inspect generated deck font sizes and palette

```console
$ pwd && rg -n "font-size|#[0-9A-Fa-f]{6}" "designs/semantic-router-redhat-report/Semantic Router E2E Report.html"
/Users/zhengwan/Desktop/dev/semantic-router
11:      --rh-red: #EE0000;
12:      --rh-dark-red: #A60000;
13:      --rh-maroon: #5F0000;
14:      --rh-pale-red: #FFF0F0;
15:      --rh-soft-red-gray: #F8EAEA;
16:      --ink: #151515;
17:      --charcoal: #2B2B2B;
18:      --gray: #6A6E73;
19:      --mid-gray: #8A8D90;
20:      --rule-gray: #D2D2D2;
21:      --light-gray: #F4F4F4;
22:      --white: #FFFFFF;
75:      font-size: var(--footer);
82:      font-size: 24px;
92:      font-size: var(--title);
101:      font-size: var(--subtitle);
110:      font-size: var(--section-title);
174:      font-size: 31px;
182:      font-size: var(--body-sm);
189:      font-size: 82px;
204:      font-size: var(--body);
214:      font-size: 25px;
240:      font-size: 22px;
268:      font-size: 44px;
278:      font-size: 24px;
285:      font-size: 29px;
293:      font-size: 23px;
322:      font-size: 25px;
338:      font-size: 29px;
346:      font-size: 23px;
358:      font-size: 24px;
378:      font-size: 62px;
386:      font-size: 24px;
403:      font-size: 27px;
411:      font-size: 31px;
425:      font-size: 82px;
434:      font-size: 35px;
453:      font-size: 25px;
461:      font-size: 58px;
469:      font-size: 27px;
494:      font-size: 30px;
500:      font-size: 30px;
508:      font-size: 24px;
```

Exit code: `0`

### 2. Register baoyu-design asset

```console
$ node /Users/zhengwan/Desktop/self/dev_sec/cline_env/2026/2026.01.daily.job/.agent/skills/baoyu-design-repo/skills/baoyu-design/agents/record-asset.mjs designs/semantic-router-redhat-report "Semantic Router E2E Report.html"
Recorded asset "Semantic Router E2E Report" → Semantic Router E2E Report.html  (status: needs-review, 1 version)
designs/semantic-router-redhat-report/_d_meta.json: written.
```

Exit code: `0`

### 3. Verify minimum font size

```console
$ node -e 'const fs=require("fs"); const p="designs/semantic-router-redhat-report/Semantic Router E2E Report.html"; const s=fs.readFileSync(p,"utf8"); const vars={}; for (const m of s.matchAll(/--([a-z0-9-]+):\s*([0-9]+)px/g)) vars[m[1]]=Number(m[2]); const vals=[]; for (const m of s.matchAll(/font-size:\s*([^;]+);/g)) { let v=m[1].trim(); let px=null; if (v.endsWith("px")) px=Number(v.replace("px","")); const vm=v.match(/^var\(--([a-z0-9-]+)\)$/); if (vm) px=vars[vm[1]]; vals.push({value:v,px}); } const missing=vals.filter(x=>x.px==null); const min=Math.min(...vals.map(x=>x.px).filter(Number.isFinite)); console.log(JSON.stringify({count:vals.length,minPx:min,minPtApprox:+(min*0.75).toFixed(2),missing,all:vals}, null, 2));'
{
  "count": 31,
  "minPx": 22,
  "minPtApprox": 16.5,
  "missing": [],
  "all": [
    {
      "value": "var(--footer)",
      "px": 22
    },
    {
      "value": "24px",
      "px": 24
    },
    {
      "value": "var(--title)",
      "px": 58
    },
    {
      "value": "var(--subtitle)",
      "px": 34
    },
    {
      "value": "var(--section-title)",
      "px": 72
    },
    {
      "value": "31px",
      "px": 31
    },
    {
      "value": "var(--body-sm)",
      "px": 25
    },
    {
      "value": "82px",
      "px": 82
    },
    {
      "value": "var(--body)",
      "px": 30
    },
    {
      "value": "25px",
      "px": 25
    },
    {
      "value": "22px",
      "px": 22
    },
    {
      "value": "44px",
      "px": 44
    },
    {
      "value": "24px",
      "px": 24
    },
    {
      "value": "29px",
      "px": 29
    },
    {
      "value": "23px",
      "px": 23
    },
    {
      "value": "25px",
      "px": 25
    },
    {
      "value": "29px",
      "px": 29
    },
    {
      "value": "23px",
      "px": 23
    },
    {
      "value": "24px",
      "px": 24
    },
    {
      "value": "62px",
      "px": 62
    },
    {
      "value": "24px",
      "px": 24
    },
    {
      "value": "27px",
      "px": 27
    },
    {
      "value": "31px",
      "px": 31
    },
    {
      "value": "82px",
      "px": 82
    },
    {
      "value": "35px",
      "px": 35
    },
    {
      "value": "25px",
      "px": 25
    },
    {
      "value": "58px",
      "px": 58
    },
    {
      "value": "27px",
      "px": 27
    },
    {
      "value": "30px",
      "px": 30
    },
    {
      "value": "30px",
      "px": 30
    },
    {
      "value": "24px",
      "px": 24
    }
  ]
}
```

Exit code: `0`

### 4. Start local preview server

First sandboxed attempt failed because local port binding was blocked:

```console
$ python -m http.server 4311 --directory designs
Traceback (most recent call last):
  File "<frozen runpy>", line 198, in _run_module_as_main
  File "<frozen runpy>", line 88, in _run_code
  File "/opt/anaconda3/envs/py312/lib/python3.12/http/server.py", line 1314, in <module>
    test(
  File "/opt/anaconda3/envs/py312/lib/python3.12/http/server.py", line 1261, in test
    with ServerClass(addr, HandlerClass) as httpd:
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/opt/anaconda3/envs/py312/lib/python3.12/socketserver.py", line 457, in __init__
    self.server_bind()
  File "/opt/anaconda3/envs/py312/lib/python3.12/http/server.py", line 1308, in server_bind
    return super().server_bind()
           ^^^^^^^^^^^^^^^^^^^^^
  File "/opt/anaconda3/envs/py312/lib/python3.12/socketserver.py", line 136, in server_bind
    socketserver.TCPServer.server_bind(self)
  File "/opt/anaconda3/envs/py312/lib/python3.12/socketserver.py", line 478, in server_bind
    self.socket.bind(self.server_address)
PermissionError: [Errno 1] Operation not permitted
```

Exit code: `1`

Then the server was started in a detached screen with approved escalation:

```console
$ screen -dmS semantic_router_deck_server zsh -lc 'cd /Users/zhengwan/Desktop/dev/semantic-router && python -m http.server 4311 --directory designs'
```

Exit code: `0`

### 5. Verify preview URL

```console
$ curl -I 'http://127.0.0.1:4311/semantic-router-redhat-report/Semantic%20Router%20E2E%20Report.html'
HTTP/1.0 200 OK
Server: SimpleHTTP/0.6 Python/3.12.9
Date: Mon, 29 Jun 2026 04:35:44 GMT
Content-type: text/html
Content-Length: 32912
Last-Modified: Mon, 29 Jun 2026 04:33:49 GMT
```

Exit code: `0`

### 6. Capture browser preview

```console
$ playwright screenshot --viewport-size=1600,900 'http://127.0.0.1:4311/semantic-router-redhat-report/Semantic%20Router%20E2E%20Report.html' designs/semantic-router-redhat-report/preview.png
Navigating to http://127.0.0.1:4311/semantic-router-redhat-report/Semantic%20Router%20E2E%20Report.html
Capturing screenshot into designs/semantic-router-redhat-report/preview.png
```

Exit code: `0`

Evidence: [preview.png](../designs/semantic-router-redhat-report/preview.png)

### 7. Export editable PPTX

```console
$ node /Users/zhengwan/Desktop/self/dev_sec/cline_env/2026/2026.01.daily.job/.agent/skills/baoyu-design-repo/skills/baoyu-design/agents/gen-pptx/dist/cli.mjs --url 'http://127.0.0.1:4311/semantic-router-redhat-report/Semantic%20Router%20E2E%20Report.html' --config designs/semantic-router-redhat-report/pptx-config.json --out designs/semantic-router-redhat-report
{"ok":true,"file":"/Users/zhengwan/Desktop/dev/semantic-router/designs/semantic-router-redhat-report/semantic-router-e2e-redhat-report.pptx","slides":16,"bytes":473265,"flags":[{"code":"no_speaker_notes","message":"No speaker notes found in the deck (neither data-speaker-notes attributes nor a #speaker-notes JSON block). Expected if the deck has no notes."}],"warnings":[],"speakerNotes":[]}
```

Exit code: `0`

Evidence: [semantic-router-e2e-redhat-report.pptx](../designs/semantic-router-redhat-report/semantic-router-e2e-redhat-report.pptx)

### 8. Verify PPTX has editable text

```console
$ unzip -p designs/semantic-router-redhat-report/semantic-router-e2e-redhat-report.pptx ppt/slides/slide1.xml | rg -o '<a:t>[^<]+' | sed -n '1,30p'
<a:t>TECHNICAL CUSTOMER BRIEFING
<a:t>vLLM Semantic Router E2E 实验汇报
<a:t>从环境恢复、双模型部署、语义分流到 dashboard 验收的客户实验路径。
<a:t>VALIDATED SETUP
<a:t>2B + 27B FP8
<a:t>面向资深 IT 运维客户：用可复制的 runbook 完成语义路由实验，并用响应头解释每一次模型选择。
<a:t>vLLM Semantic Router E2E
<a:t>01
```

Exit code: `0`

### 9. Count slides and artifact sizes

```console
$ node -e 'const fs=require("fs"); const s=fs.readFileSync("designs/semantic-router-redhat-report/Semantic Router E2E Report.html","utf8"); console.log((s.match(/<section data-label=/g)||[]).length)'
16
```

Exit code: `0`

```console
$ find designs/semantic-router-redhat-report -maxdepth 1 -type f -print -exec wc -c {} \;
designs/semantic-router-redhat-report/deck-stage.js
   84237 designs/semantic-router-redhat-report/deck-stage.js
designs/semantic-router-redhat-report/semantic-router-e2e-redhat-report.pptx
  473265 designs/semantic-router-redhat-report/semantic-router-e2e-redhat-report.pptx
designs/semantic-router-redhat-report/preview.png
  111806 designs/semantic-router-redhat-report/preview.png
designs/semantic-router-redhat-report/_d_meta.json
     411 designs/semantic-router-redhat-report/_d_meta.json
designs/semantic-router-redhat-report/Semantic Router E2E Report.html
   32920 designs/semantic-router-redhat-report/Semantic Router E2E Report.html
designs/semantic-router-redhat-report/pptx-config.json
    2539 designs/semantic-router-redhat-report/pptx-config.json
designs/semantic-router-redhat-report/scratchpad.md
    1194 designs/semantic-router-redhat-report/scratchpad.md
```

Exit code: `0`

### 10. Secret scan generated design artifacts

```console
$ rg -n "password|passwd|secret|token|api[_-]?key|AKIA[0-9A-Z]{16}|hf_[A-Za-z0-9_=-]{10,}|sk-[A-Za-z0-9]{20,}|bastion\.|sandbox[0-9]+\.opentlc\.com|sshpass|BEGIN (RSA|OPENSSH|PRIVATE) KEY" designs/semantic-router-redhat-report
designs/semantic-router-redhat-report/Semantic Router E2E Report.html:571:          <div class="node"><strong>请求数据</strong><span>model, messages, headers, max_tokens</span></div>
designs/semantic-router-redhat-report/Semantic Router E2E Report.html:618:          <p class="panel-body">后端模型：Qwen/Qwen3.5-2B<br>定位：简单问题、短摘要、轻量客服<br>价格模型：prompt 0.20 / completion 0.40 per 1M tokens</p>
designs/semantic-router-redhat-report/Semantic Router E2E Report.html:623:          <p class="panel-body">后端模型：Qwen/Qwen3.5-27B-FP8<br>定位：事故分析、架构、代码、安全、多轮推理<br>价格模型：prompt 8.00 / completion 16.00 per 1M tokens</p>
designs/semantic-router-redhat-report/Semantic Router E2E Report.html:704:        <div class="flow-step"><div class="flow-label">Input</div><div class="flow-title">用户请求</div><div class="flow-body">messages + headers + max_tokens</div></div>
```

Exit code: `0`

The matches are benign references to token counts and request fields, not credentials.
