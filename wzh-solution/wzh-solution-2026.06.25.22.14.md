# Round 7: semantic-router budget 行为专项验证

| 字段 | 值 |
|---|---|
| 日期 | 2026-06-25 |
| 目标 | 验证项目里所谓 budget 模式是否支持“某模型预算不足时自动切到仍有预算的模型” |
| 结论 | 当前验证到的是参数预算、成本上限过滤、token rate-limit 拒绝；没有验证到“预算耗尽后自动 fallback 到另一个模型” |
| 步骤审计 | [../wzh-steps/wzh-steps-2026.06.25.22.14.md](../wzh-steps/wzh-steps-2026.06.25.22.14.md) |
| cost ceiling 输出 | [files/wzh-solution-2026-06-25-22-14/cost-ceiling-sdk-output.txt](files/wzh-solution-2026-06-25-22-14/cost-ceiling-sdk-output.txt) |
| request params 输出 | [files/wzh-solution-2026-06-25-22-14/request-params-sdk-output.txt](files/wzh-solution-2026-06-25-22-14/request-params-sdk-output.txt) |
| ratelimit 输出 | [files/wzh-solution-2026-06-25-22-14/ratelimit-budget-sdk-output.txt](files/wzh-solution-2026-06-25-22-14/ratelimit-budget-sdk-output.txt) |

## 先纠正上一把

上一把 round 6 我验证的是 GPU VM 重启后的环境恢复、fused router 恢复、OpenAI SDK 流量和多轮路由。那不是 budget 专项测试。这个判断你指出得对。

这一轮专门补测 budget/cost 相关能力，并把三类容易混在一起的能力拆开：

1. README 里叫 `budget-route` 的 `request_params` 插件。
2. `multi_factor.slo.max_cost_per_1m` 这种成本上限过滤。
3. `local-limiter` 的 token/request budget。

## 代码和文档结论

### 1. README 的 `budget-route` 不是余额预算

`src/vllm-sr/README.md` 里的 `budget-route` 示例是：

```yaml
plugins:
  - type: "request_params"
    configuration:
      blocked_params: ["logprobs", "top_logprobs"]
      max_tokens_limit: 512
      max_n: 1
      strip_unknown: true
```

这类 budget 是“请求参数预算”，意思是限制一次请求最多生成多少 token、最多几个 `n`、是否允许 `logprobs`。它不是“账户预算余额”，也不是“某个模型预算不够就换另一个模型”。

### 2. 成本上限存在，但它是候选过滤

`multi_factor` selector 支持：

```yaml
algorithm:
  type: multi_factor
  multi_factor:
    slo:
      max_cost_per_1m: 1.0
```

代码路径在 `src/semantic-router/pkg/selection/multi_factor.go`：

- 先看候选模型的 `providers.models[].pricing.prompt_per_1m`。
- 如果 `prompt_per_1m > max_cost_per_1m`，候选模型被过滤掉。
- 过滤以后再从剩余候选里选模型。
- 如果所有候选都被过滤，才按 `on_no_candidates` 做 `cheapest`、`first` 或 `fail`。

这更像“成本天花板”或“预算约束”，不是动态余额扣减。

### 3. token budget 存在，但耗尽时是 429

`local-limiter` 支持：

```yaml
ratelimit:
  providers:
    - type: local-limiter
      rules:
        - tokens_per_unit: 1
          unit: minute
```

代码路径是：

1. router 先完成 decision 和 model selection。
2. `applyRateLimitAndCacheChecks()` 对已选模型调用 `RateLimiter.Check()`。
3. 如果预算不足，直接 `createRateLimitResponse()` 返回 429。
4. 当前代码没有看到“429 后在剩余 candidate model 里重试选择”的 fallback 逻辑。

## VM 实测一：成本上限过滤

配置文件：[router-budget-cost-ceiling.yaml](files/wzh-solution-2026-06-25-22-14/router-budget-cost-ceiling.yaml)

核心设置：

```yaml
providers:
  models:
    - name: qwen35-2b
      pricing:
        prompt_per_1m: 0.20
    - name: qwen35-27b-fp8
      pricing:
        prompt_per_1m: 8.00

routing:
  decisions:
    - name: budget-cost-ceiling
      modelRefs:
        - model: qwen35-2b
        - model: qwen35-27b-fp8
      algorithm:
        type: multi_factor
        multi_factor:
          slo:
            max_cost_per_1m: 1.0
```

测试请求是复杂 incident/debug/root-cause 请求。按上一轮 fused hybrid 行为，这类请求常会走 27B；但在本配置里，27B 的 `prompt_per_1m=8.00` 超过 `max_cost_per_1m=1.0`，所以它应被过滤。

实测结果：

| 场景 | selected decision | selected model | 结论 |
|---|---|---|---|
| `complex_debug_budget_ceiling` | `budget-cost-ceiling` | `qwen35-2b` | 成本上限使复杂请求走 2B |
| `simple_default_budget_ceiling` | `default-small` | `qwen35-2b` | 默认小模型 |

关键响应头：

```text
x-vsr-selected-decision: budget-cost-ceiling
x-vsr-selected-model: qwen35-2b
x-vsr-matched-keywords: complex_budget_test
```

这个测试证明：当前 runtime 支持“按配置成本上限过滤高价模型”。

## VM 实测二：README budget-route 参数预算

配置文件：[router-budget-request-params.yaml](files/wzh-solution-2026-06-25-22-14/router-budget-request-params.yaml)

核心设置：

```yaml
plugins:
  - type: request_params
    configuration:
      blocked_params: ["logprobs", "top_logprobs"]
      max_tokens_limit: 16
      max_n: 1
      strip_unknown: true
```

实测结果：

| 场景 | 请求参数 | 结果 |
|---|---|---|
| `request_params_max_tokens_64` | 请求 `max_tokens=64` | 实际 `completion_tokens=16` |
| `request_params_blocked_logprobs` | 请求 `logprobs=true`、`top_logprobs=2`、`n=2` | 请求成功，说明参数被处理/剥离，没有传给后端导致失败 |

这个测试证明：README 的 `budget-route` 更准确地说是“单请求输出预算/参数预算”。

它不会在 2B/27B 之间切换，因为这个配置只定义了一个 `qwen35-2b` 模型，并且语义也不是余额扣减。

## VM 实测三：token budget 耗尽不是 fallback

配置文件：[router-budget-ratelimit-no-fallback.yaml](files/wzh-solution-2026-06-25-22-14/router-budget-ratelimit-no-fallback.yaml)

测试意图：

- decision 有两个候选：`qwen35-27b-fp8` 和 `qwen35-2b`。
- static selector 会先选第一个候选，也就是 27B。
- 给用户 `round7-budget` + 模型 `qwen35-27b-fp8` 设置 `tokens_per_unit: 1`。
- 发送一个明显超过 1 token 的请求。
- 如果支持“预算不足自动切有预算模型”，应该 fallback 到 2B。
- 如果不支持，应该返回 429。

实测结果：

```text
RateLimitError("Error code: 429 - {'error': {'message': 'Rate limit exceeded. Retry after 0 seconds.', 'type': 'rate_limit_error', 'code': 429}}")
```

router 日志关键证据：

```text
[StaticSelector] Candidates: [qwen35-27b-fp8 qwen35-2b] -> Selected: qwen35-27b-fp8
[ModelSelection] Selected qwen35-27b-fp8 (method=static...)
Rate limit DENIED by provider "local-limiter" for user=round7-budget model=qwen35-27b-fp8
rate_limit_rejected ... model="qwen35-27b-fp8"
```

这说明：

- router 确实先选了 27B。
- local-limiter 确实拒绝了 27B 的请求。
- Envoy 返回 429。
- 没有自动改选 2B。

## 最终回答

如果你说的 budget mode 是“后面的模型有成本、有预算，预算不够就切到还有预算的模型”，那我这轮没有验证到这个功能存在。

当前项目里可验证的能力是：

| 能力 | 是否存在 | 行为 |
|---|---|---|
| `request_params` budget-route | 存在 | 限制 `max_tokens`、`n`、`logprobs` 等请求参数 |
| `multi_factor.slo.max_cost_per_1m` | 存在 | 按模型定价过滤超过成本上限的候选模型 |
| `local-limiter` token budget | 存在 | 预算不足时返回 429 |
| 预算耗尽后自动换另一个仍有预算模型 | 本轮未发现/未验证到 | 实测是 429，不是 fallback |

所以正确说法应该是：

> semantic-router 当前有成本感知/成本上限/请求参数预算/rate-limit token budget，但我没有看到也没有测到“模型预算余额耗尽后自动 fallback 到另一个模型”的闭环功能。

## 环境恢复

budget 测试结束后，VM 已恢复到 round 6 的 fused 配置：

- `vsr-router` 使用 `router-fused-signals-hybrid.yaml`
- `vsr-envoy` 使用 `envoy-vsr.yaml`
- `qwen35-2b` 和 `qwen35-27b-fp8` 后端继续运行
- `/health` 和 `/v1/models` 检查通过
