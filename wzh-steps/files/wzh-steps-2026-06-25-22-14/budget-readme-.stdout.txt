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
vllm-sr validate

# Migrate older configs to the canonical contract
vllm-sr config migrate --config old-config.yaml

# Import supported OpenClaw model providers into canonical config.yaml
vllm-sr config import --from openclaw --source openclaw.json --target config.yaml
```

### File Descriptor Limits
