
Tracing is enabled by default. Traces are visible in Jaeger under the `vllm-sr` service name.

## Configuration

### Plugin Configuration

The CLI supports configuring plugins in your routing decisions. Plugins are per-decision behaviors that customize request handling (security, caching, customization, debugging).

**Supported Plugin Types:**

- `semantic-cache` - Cache similar requests for performance
- `memory` - Retrieve and store route-local conversation memory
- `system_prompt` - Inject custom system prompts
- `header_mutation` - Add/modify HTTP headers
- `hallucination` - Detect hallucinations in responses
- `router_replay` - Record routing decisions for debugging
- `rag` - Inject retrieved knowledge into prompts
- `image_gen` - Hand a matched route off to an image generation backend
- `fast_response` - Return a route-local response immediately
- `request_params` - Sanitize or cap request body parameters before forwarding
- `response_jailbreak` - Screen model output before returning it
- `tools` - Restrict or curate tool access per route

**Plugin Examples:**

Each example shows the plugin list inside a canonical `routing.decisions[]` entry.

1. **semantic-cache** - Cache similar requests:

```yaml
routing:
  decisions:
    - name: "cached-route"
      plugins:
        - type: "semantic-cache"
          configuration:
            enabled: true
            similarity_threshold: 0.92  # 0.0-1.0, higher = more strict
            ttl_seconds: 3600  # Optional: cache TTL in seconds
```

2. **fast_response** - Return a route-local response:

```yaml
routing:
  decisions:
    - name: "guarded-route"
      plugins:
        - type: "fast_response"
          configuration:
            message: "This request was blocked by the matched route policy."
```

3. **system_prompt** - Inject custom instructions:

```yaml
routing:
  decisions:
    - name: "persona-route"
      plugins:
        - type: "system_prompt"
          configuration:
            enabled: true
            system_prompt: "You are a helpful assistant."
            mode: "replace"  # "replace" (default) or "insert" (prepend)
```

4. **header_mutation** - Modify HTTP headers:

```yaml
routing:
  decisions:
    - name: "header-route"
      plugins:
        - type: "header_mutation"
          configuration:
            add:
              - name: "X-Custom-Header"
                value: "custom-value"
            update:
              - name: "User-Agent"
                value: "SemanticRouter/1.0"
            delete:
              - "X-Old-Header"
```

5. **hallucination** - Detect hallucinations:

```yaml
routing:
  decisions:
    - name: "fact-check-route"
      plugins:
        - type: "hallucination"
          configuration:
            enabled: true
            use_nli: false  # Optional: use NLI for detailed analysis
            hallucination_action: "header"  # "header", "body", or "none"
```

6. **router_replay** - Record decisions for debugging:

```yaml
routing:
  decisions:
    - name: "debug-route"
      plugins:
        - type: "router_replay"
          configuration:
            enabled: true
            max_records: 10000  # Optional: max records in memory (default: 10000)
            capture_request_body: true  # Optional: capture request payloads (default: true)
            capture_response_body: true  # Optional: capture response payloads (default: true)
            max_body_bytes: 4096  # Optional: max bytes to capture (default: 4096)
```

7. **memory** - Retrieve route-local memory:

```yaml
routing:
  decisions:
    - name: "memory-route"
      plugins:
        - type: "memory"
          configuration:
            enabled: true
            retrieval_limit: 5
            similarity_threshold: 0.75
            auto_store: true
```

8. **rag** - Inject retrieved context:

```yaml
routing:
  decisions:
    - name: "knowledge-route"
      plugins:
        - type: "rag"
          configuration:
            enabled: true
            backend: "milvus"
            top_k: 5
            similarity_threshold: 0.8
```

9. **tools** - Restrict available tools:

```yaml
routing:
  decisions:
    - name: "tool-route"
      plugins:
        - type: "tools"
          configuration:
            enabled: true
            mode: "filtered"
            allow_tools: ["search_web"]
            block_tools: ["exec_cmd"]
```

10. **image_gen** - Route to an image backend:

```yaml
routing:
  decisions:
    - name: "image-route"
      plugins:
        - type: "image_gen"
          configuration:
            enabled: true
            backend: "vllm_omni"
            backend_config:
              base_url: "http://image-router:8005"
```

11. **request_params** - Cap or strip request parameters:

```yaml
routing:
  decisions:
    - name: "budget-route"
      plugins:
        - type: "request_params"
          configuration:
            blocked_params: ["logprobs", "top_logprobs"]
            max_tokens_limit: 512
            max_n: 1
            strip_unknown: true
```

12. **response_jailbreak** - Screen generated output:

```yaml
routing:
  decisions:
    - name: "safety-route"
      plugins:
        - type: "response_jailbreak"
          configuration:
            enabled: true
            threshold: 0.8
            action: "header"
```

Router replay records are exposed through:

- `GET /v1/router_replay?limit=20&offset=0&search=req-123&decision=foo&model=bar&cache_status=cached` - List recent records with pagination metadata. Default page size is `20`; larger `limit` values are capped at `100`.
- `GET /v1/router_replay/aggregate?search=req-123&decision=foo&model=bar&cache_status=cached` - Return summary and chart aggregates for the filtered replay set.
- `GET /v1/router_replay/{id}` - Fetch a single replay record.

If a replay page would exceed the ext-proc gRPC message budget, the router returns `413 Payload Too Large` instead of failing the stream.

**Validation Rules:**

- **Plugin Type**: Must be one of: `semantic-cache`, `memory`, `system_prompt`, `header_mutation`, `hallucination`, `router_replay`, `rag`, `image_gen`, `fast_response`, `request_params`, `response_jailbreak`, `tools`, `tool_selection`
- **enabled**: Must be a boolean (required for most plugins)
- **similarity_threshold/min_confidence_threshold**: Must be a float between 0.0 and 1.0
- **max_records/max_body_bytes**: Must be a positive integer
- **ttl_seconds**: Must be a non-negative integer
- **system_prompt**: Must be a string (if provided)
- **mode**: Must be "replace" or "insert" (if provided)
- **injection_mode**: Must be `tool_role` or `system_prompt` (if provided)
- **on_failure**: Must be `skip`, `block`, or `warn` (if provided)
- **action**: Must be `block`, `header`, or `none` (if provided)

**CLI Commands:**

```bash
# Validate configuration (including plugins)
