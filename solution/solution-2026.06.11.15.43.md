# vLLM Semantic Router 架构总结

> 日期: 2026-06-11<br>
> 项目: vLLM Semantic Router<br>
> 目的: 全面梳理流量入口、路由决策、后端模型注册的完整架构

---

## 一、项目定位

vLLM Semantic Router 是一个**信号驱动的智能 LLM 请求路由器**，用于 Mixture-of-Models（混合模型）场景。它以 **Envoy External Processing（ExtProc）gRPC 过滤器**的形式运行，拦截经过 Envoy 代理的 HTTP 请求，通过内嵌的 ML 推理能力对请求进行语义分析和分类，然后将请求路由到最合适的后端 LLM 模型。

核心价值：**根据请求的语义内容（而非简单的 URL/Header 匹配）智能选择最佳后端模型**——例如将简单问题路由到轻量模型，将复杂推理问题路由到大型推理模型。

---

## 二、整体架构概览

```
┌─────────────────────────────────────────────────────────────────┐
│                        客户端请求                                │
│                   (OpenAI 兼容 API 格式)                         │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Envoy Proxy                                │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │           ExtProc Filter (ext_proc)                       │  │
│  │     gRPC 双向流连接到 Semantic Router                      │  │
│  └───────────────────────────────────────────────────────────┘  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ gRPC (端口 50051)
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Semantic Router (Go)                           │
│                                                                 │
│  ┌─────────┐  ┌──────────┐  ┌──────────┐  ┌────────────────┐  │
│  │ Signal  │→│Projection│→│ Decision │→│  Model Select  │  │
│  │ 信号提取 │  │  投影组合  │  │  决策判断  │  │  模型选择/路由  │  │
│  └─────────┘  └──────────┘  └──────────┘  └────────────────┘  │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │  ML Inference Bindings (Rust→Go FFI)                        ││
│  │  candle / onnx / openvino / ml-binding / nlp-binding        ││
│  └─────────────────────────────────────────────────────────────┘│
└──────────────────────────┬──────────────────────────────────────┘
                           │ 修改请求头 (cluster/host)
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Envoy Proxy (回传)                             │
│           根据修改后的头部路由到对应的后端集群                       │
└──────────┬───────────────┬───────────────┬──────────────────────┘
           │               │               │
           ▼               ▼               ▼
    ┌──────────┐    ┌──────────┐    ┌──────────┐
    │ Model A  │    │ Model B  │    │ Model C  │
    │ (轻量级)  │    │ (通用型)  │    │ (推理型)  │
    │  vLLM    │    │  vLLM    │    │  vLLM    │
    └──────────┘    └──────────┘    └──────────┘
```

---

## 三、流量入口 — 请求如何进来

### 3.1 入口路径

流量通过标准的 **OpenAI 兼容 API** 格式进入系统：

```
客户端 → Envoy Proxy (HTTP) → ExtProc gRPC Filter → Semantic Router
```

1. **客户端** 发送标准的 OpenAI Chat Completion 请求（`POST /v1/chat/completions`）
2. **Envoy Proxy** 作为前端代理接收 HTTP 请求
3. Envoy 的 **ExtProc 过滤器** 通过 gRPC 双向流将请求头和请求体发送给 Semantic Router
4. Semantic Router 分析请求，返回路由指令（修改请求头，指定目标集群）
5. Envoy 根据修改后的头部将请求转发到对应的后端模型

### 3.2 ExtProc 处理流程

Semantic Router 的 gRPC 服务监听在 **端口 50051**，实现 Envoy 的 `ExternalProcessorServer` 接口。请求处理是一个双向流，按以下顺序接收和处理 4 种消息：

| 阶段 | Envoy 消息类型 | Router 处理 |
|------|---------------|------------|
| 1 | `RequestHeaders` | 提取路径、Content-Type、Authorization 等元数据；判断是否为 `/v1/chat/completions` 路径 |
| 2 | `RequestBody` | **核心阶段**：解析 JSON body，提取 `messages`、`model`、`stream` 等字段，运行信号检测和路由决策 |
| 3 | `ResponseHeaders` | 处理响应头（可注入追踪头、指标等） |
| 4 | `ResponseBody` | 处理响应体（可用于反馈学习等） |

### 3.3 请求体解析

在 `RequestBody` 阶段，Router 解析 OpenAI 格式的 JSON body：

```json
{
  "model": "any-model-name",
  "messages": [
    {"role": "system", "content": "..."},
    {"role": "user", "content": "请解释量子纠缠原理"}
  ],
  "stream": true
}
```

关键提取的字段：
- **`messages`** — 对话历史，用于语义分析
- **`model`** — 客户端请求的模型名（可被路由覆盖）
- **`stream`** — 是否流式响应
- 用户消息的最后一条是主要分析目标

---

## 四、路由决策 — 如何判断流量去哪个后端

### 4.1 四层架构模型

路由决策遵循 **Signal → Projection → Decision → Plugin** 四层架构：

```
┌─────────────────────────────────────────────────────┐
│  Layer 1: Signal（信号层）                            │
│  从请求中提取各种语义特征                               │
│  关键词、嵌入向量、领域分类、复杂度、安全检测等           │
├─────────────────────────────────────────────────────┤
│  Layer 2: Projection（投影层）                        │
│  将原始信号组合成衍生路由输入                            │
│  分区(partition)、评分(score)、阈值映射(threshold-band) │
├─────────────────────────────────────────────────────┤
│  Layer 3: Decision（决策层）                          │
│  基于信号输出做布尔逻辑判断，选择目标模型                 │
│  支持 AND/OR/NOT 条件组合，按优先级排序                  │
├─────────────────────────────────────────────────────┤
│  Layer 4: Plugin（插件层）                            │
│  路由后的增强处理                                      │
│  提示词重写、思考标签处理、安全过滤、负载均衡策略等        │
└─────────────────────────────────────────────────────┘
```

### 4.2 Signal（信号层）— 17 种信号家族

信号是原子检测单元，从请求中提取事实。项目内置 **17 种信号类型**：

| 信号类型 | 说明 | 典型用途 |
|---------|------|---------|
| **keyword** | 关键词/正则匹配（BM25/N-gram/fuzzy） | 检测代码生成、数学公式等关键词 |
| **embedding** | 语义嵌入相似度 | 与候选短语的语义距离比较 |
| **domain** | 领域分类（基于 MMLU 分类体系） | 识别请求属于哪个学科领域 |
| **complexity** | 复杂度估计 | 区分简单问答和复杂推理 |
| **jailbreak** | 越狱攻击检测 | 安全防护 |
| **pii** | 个人身份信息检测 | 隐私保护 |
| **language** | 语言检测 | 多语言路由 |
| **modality** | 模态分类（文本/图像/音频） | 多模态路由 |
| **structure** | 结构检测（正则/密度/序列） | 检测 JSON、代码块等结构 |
| **conversation** | 对话形态分析 | 多轮对话特征 |
| **feedback** | 用户反馈/重问检测 | 质量优化 |
| **preference** | 用户偏好匹配 | 个性化路由 |
| **kb_label** | 知识库标签匹配 | 专业领域路由 |
| **context_length** | 上下文长度检查 | 长文本路由 |
| **role** | 角色/授权绑定 | 基于角色的路由 |
| **event** | 事件匹配 | 基于事件触发 |
| **reasoning** | 推理模式检测 | 思维链路由 |

### 4.3 信号的 ML 推理后端

信号检测依赖 **5 个 Rust→Go FFI 绑定层**，在 Router 进程内执行本地 ML 推理：

| 绑定 | 技术栈 | 功能 |
|------|-------|------|
| **candle-binding** | Candle（Rust 深度学习框架） | ModernBERT 序列分类和嵌入生成 |
| **onnx-binding** | ONNX Runtime | mmBERT 嵌入生成（支持 2D Matryoshka） |
| **openvino-binding** | Intel OpenVINO | ModernBERT 分类和嵌入（Intel 优化） |
| **ml-binding** | Linfa（Rust ML 库） | KNN/KMeans/SVM 模型选择 |
| **nlp-binding** | BM25 + ngrammatic | BM25 关键词评分和 N-gram 模糊匹配 |

架构模式：Rust crate 实现算法 → 编译为 `.so`/`.dylib` 共享库 → 通过 C FFI 暴露给 Go → Go 侧包装为安全的 Go API。

### 4.4 Decision（决策层）— 路由规则

决策规则是一系列**按优先级排序的条件-动作对**：

```yaml
# 示例：决策规则配置
decisions:
  - name: "route-to-reasoning-model"
    priority: 1
    conditions:
      - signal: complexity
        operator: gte
        value: 0.8
      - signal: reasoning
        operator: eq
        value: true
    action:
      model: "deepseek-r1"      # 路由到推理模型
      
  - name: "route-to-code-model"
    priority: 2
    conditions:
      - signal: keyword
        type: code
        operator: eq
        value: true
    action:
      model: "qwen-coder"       # 路由到代码模型

  - name: "default-route"
    priority: 99
    conditions: []               # 无条件匹配
    action:
      model: "llama-3"          # 默认路由到通用模型
```

决策引擎的执行逻辑：
1. 按优先级从高到低遍历所有决策规则
2. 对每条规则，评估其条件（AND/OR/NOT 组合）
3. **第一个满足条件的规则生效**，返回目标模型名
4. 如果没有规则匹配，使用默认模型

### 4.5 路由执行 — 如何修改 Envoy 请求

Router 做出决策后，通过修改 Envoy 请求头来实现路由：

```go
// 核心路由逻辑（简化示意）
func (r *OpenAIRouter) handleRequestBody(ctx context.Context, body []byte) {
    // 1. 解析 OpenAI 请求
    chatReq := parseOpenAIChatRequest(body)
    
    // 2. 运行信号检测
    signals := r.evaluateSignals(chatReq)
    
    // 3. 执行决策
    targetModel := r.makeDecision(signals)
    
    // 4. 查找 model_map 获取后端集群
    backend := r.config.ModelMap[targetModel]
    
    // 5. 返回头部修改指令给 Envoy
    //    设置 :authority 和 x-route-model 等头
    //    Envoy 根据这些头部将请求转发到正确的后端集群
}
```

### 4.6 Plugin（插件层）— 路由后增强

路由决策完成后，插件层可以对请求进行额外处理：

| 插件类型 | 功能 |
|---------|------|
| **prompt-rewrite** | 重写系统提示词以适配目标模型 |
| **thinking-tag** | 处理推理模型的思考标签 |
| **guard** | 安全过滤（越狱检测、PII 过滤） |
| **load-balance** | 多副本负载均衡策略 |
| **cache** | 语义缓存（相似请求直接返回缓存结果） |
| **tool-routing** | 工具调用路由 |

---

## 五、后端模型注册 — 模型如何接入

### 5.1 注册方式概览

后端模型有 **三种注册/发现方式**：

```
┌────────────────────────────────────────────────────────┐
│              后端模型注册方式                             │
├───────────────┬──────────────────┬─────────────────────┤
│   方式 1       │     方式 2        │      方式 3         │
│   KServe      │   Service 直连    │    LlamaStack      │
│   自动发现      │   手动指定        │    标签选择器发现     │
├───────────────┼──────────────────┼─────────────────────┤
│ 通过 KServe   │ 直接指定 K8s     │ 通过 label selector │
│ Inference-    │ Service 的       │ 在命名空间内发现     │
│ Service 名称  │ name/ns/port     │ 匹配的 Service      │
│ 自动构造端点   │                  │                     │
└───────────────┴──────────────────┴─────────────────────┘
```

### 5.2 方式一：KServe InferenceService（自动发现）

最推荐的方式，适用于已使用 KServe 部署模型的环境：

```yaml
# SemanticRouter CRD 中的配置
spec:
  vllmEndpoints:
    - name: reasoning-model
      model: "deepseek-r1-0528"
      reasoningFamily: "deepseek"
      backend:
        type: kserve
        inferenceServiceName: "deepseek-r1-isvc"
      weight: 1
```

发现流程：
1. Operator 读取 `inferenceServiceName`
2. 查找对应的 KServe `InferenceService` CRD
3. 自动构造端点地址：`{name}-predictor.{namespace}.svc.cluster.local:8443`
4. 生成 Envoy 集群配置

### 5.3 方式二：Kubernetes Service（直连）

最简单直接的方式，手动指定后端 Service：

```yaml
spec:
  vllmEndpoints:
    - name: general-model
      model: "llama-3.1-8b"
      backend:
        type: service
        serviceBackend:
          name: "vllm-llama3"
          namespace: "models"
          port: 8000
      weight: 1
```

适用场景：
- 直接部署的 vLLM 实例
- 非 KServe 部署的模型服务
- 开发/测试环境

### 5.4 方式三：LlamaStack（标签发现）

通过 Kubernetes 标签选择器动态发现后端：

```yaml
spec:
  vllmEndpoints:
    - name: llama-stack-model
      model: "llama-3"
      backend:
        type: llamastack
        discoveryLabels:
          app: llama-stack
          model-family: llama
```

发现流程：
1. Operator 使用 `discoveryLabels` 构造标签选择器
2. 在当前命名空间中搜索匹配的 Kubernetes Service
3. 动态注册发现的后端

### 5.5 配置文件中的 Model Map

无论使用哪种注册方式，最终都会在 Router 的配置中生成 **model_map** —— 模型名到后端集群的映射：

```yaml
# config.yaml 中的模型映射
providers:
  models:
    - name: "deepseek-r1"           # 路由决策中使用的模型名
      provider: model-a             # 后端提供者标识
      backend_refs:
        - name: model-a-backend     # 对应 vllmEndpoints 中的 name
          weight: 100
          
    - name: "llama-3"
      provider: model-b
      backend_refs:
        - name: model-b-backend
          weight: 100
```

### 5.6 LoRA 适配器支持

后端模型还可以注册 LoRA 适配器，实现更细粒度的路由：

```yaml
spec:
  vllmEndpoints:
    - name: base-model
      model: "llama-3.1-8b"
      loras:
        - name: "medical-lora"
          description: "医学领域微调"
        - name: "legal-lora"
          description: "法律领域微调"
      backend:
        type: service
        serviceBackend:
          name: "vllm-llama3"
          port: 8000
```

---

## 六、Operator 和部署架构

### 6.1 Kubernetes Operator

项目提供了一个 **Kubernetes Operator**，通过 `SemanticRouter` CRD（vllm.ai/v1alpha1）管理整个系统的生命周期：

```
┌────────────────────────────────────────────────────┐
│            SemanticRouter CRD                       │
│                                                     │
│  spec:                                              │
│    image: ...                                       │
│    replicas: 2                                      │
│    config:                                          │
│      routing: (信号/决策/插件配置)                    │
│    vllmEndpoints:                                   │
│      - name: model-a                                │
│        model: "deepseek-r1"                         │
│        backend: {type: kserve, ...}                 │
│      - name: model-b                                │
│        model: "llama-3"                             │
│        backend: {type: service, ...}                │
│    autoscaling: ...                                 │
│    gateway: (K8s Gateway API 集成)                  │
│                                                     │
│  Operator Controller:                               │
│  1. 创建 Envoy + Router Deployment                  │
│  2. 发现后端模型端点                                  │
│  3. 生成 Envoy 配置 (clusters + routes)              │
│  4. 生成 Router 配置 (signals + decisions)           │
│  5. 管理 ConfigMap、Service、PVC                     │
│  6. 处理 Gateway API 集成                            │
└────────────────────────────────────────────────────┘
```

### 6.2 部署拓扑

```
┌─ Kubernetes Cluster ──────────────────────────────────────┐
│                                                            │
│  ┌─ SemanticRouter Pod ─────────────────────────────────┐  │
│  │                                                       │  │
│  │  ┌──────────────┐       ┌──────────────────────────┐ │  │
│  │  │  Envoy Proxy │◄─────►│  Semantic Router (Go)    │ │  │
│  │  │  (Sidecar)   │ gRPC  │  + ML Bindings (Rust)    │ │  │
│  │  │  Port: 8080  │ :50051│  Port: 50051             │ │  │
│  │  └──────┬───────┘       │  Metrics: 9190           │ │  │
│  │         │               │  API: 8080               │ │  │
│  │         │               └──────────────────────────┘ │  │
│  └─────────┼────────────────────────────────────────────┘  │
│            │                                                │
│            ├────────────► Model A (vLLM Pod)                │
│            ├────────────► Model B (vLLM Pod)                │
│            └────────────► Model C (KServe InferenceService) │
│                                                            │
│  ┌─ Dashboard Pod ──────────────────────────────────────┐  │
│  │  Frontend (React) + Backend (Go)                      │  │
│  │  可视化监控路由决策和模型性能                              │  │
│  └───────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────┘
```

---

## 七、热更新与配置重载

Router 支持**热配置重载**，无需重启即可更新路由规则：

1. **文件监听**: Router 监控配置文件变化
2. **原子交换**: 检测到变更后，创建新的 `OpenAIRouter` 实例
3. **无缝切换**: 通过 `RouterService.Swap()` 原子替换，正在处理的请求不受影响
4. **Operator 联动**: Operator 更新 ConfigMap → 触发 Pod 内的配置重载

---

## 八、完整请求生命周期

以一个具体例子说明完整的请求处理流程：

```
用户发送: "请用递归方法实现归并排序，并分析时间复杂度"

1. [客户端] → POST /v1/chat/completions → [Envoy :8080]

2. [Envoy] → ExtProc RequestHeaders → [Router]
   Router 识别为 /v1/chat/completions 路径，请求读取 body

3. [Envoy] → ExtProc RequestBody → [Router]
   Router 解析 JSON body，提取 messages

4. [Router 信号检测]
   ├── keyword 信号: 检测到 "递归"、"归并排序"、"时间复杂度" → 代码/算法类
   ├── embedding 信号: 与 "coding" 候选短语相似度 0.87
   ├── complexity 信号: 估计复杂度 0.72（中高）
   ├── domain 信号: 分类为 "computer_science"
   └── structure 信号: 未检测到代码块

5. [Router 决策引擎]
   ├── 规则1 "route-to-reasoning": complexity>=0.8? → 否 (0.72 < 0.8)
   ├── 规则2 "route-to-code": keyword=code? → 是
   └── 决策: 路由到 "qwen-coder" 模型

6. [Router 插件处理]
   ├── prompt-rewrite: 添加代码生成相关的系统提示
   └── thinking-tag: 配置思考标签处理

7. [Router] → 返回头部修改给 Envoy
   ├── :authority → qwen-coder-backend.models.svc.cluster.local
   ├── x-route-model → qwen-coder
   └── x-route-reason → keyword:code

8. [Envoy] → 根据修改后的头部转发请求 → [qwen-coder vLLM Pod]

9. [vLLM Pod] → 生成响应 → [Envoy] → [客户端]
```

---

## 九、Recipe（配方）示例

项目提供预定义的 Recipe 文件，快速配置常见场景：

```yaml
# deploy/recipes/balance.yaml 示例结构
# 均衡路由配方：将流量按能力分配到不同模型

signals:
  - type: complexity
    config: ...
  - type: domain
    config: ...

decisions:
  - name: hard-to-reasoning
    conditions: [{signal: complexity, gte: 0.8}]
    action: {model: reasoning-model}
    
  - name: code-to-coder
    conditions: [{signal: keyword, type: code}]
    action: {model: code-model}
    
  - name: default
    conditions: []
    action: {model: general-model}

plugins:
  - type: load-balance
    strategy: weighted-round-robin
```

---

## 十、关键技术亮点

| 特性 | 说明 |
|------|------|
| **进程内 ML 推理** | 通过 Rust FFI 绑定在路由进程内直接执行 ML 推理，无需外部推理服务，延迟极低 |
| **多后端支持** | 支持 CPU（candle/onnx）、Intel（openvino）、AMD GPU（onnx-rocm）多种推理后端 |
| **热配置重载** | 无需重启即可更新路由规则和信号配置 |
| **语义缓存** | 基于语义相似度的请求缓存，减少重复推理 |
| **会话感知** | 支持会话粘性路由，保持对话上下文一致性 |
| **可观测性** | Prometheus 指标（端口 9190）、OpenTelemetry 追踪、Dashboard 可视化 |
| **安全防护** | 内置越狱检测、PII 过滤、提示词注入防护 |
| **Kubernetes 原生** | CRD + Operator 完整的云原生部署和管理 |
| **Gateway API 集成** | 支持 Kubernetes Gateway API 进行流量管理 |

---

## 十一、单 VM 部署（不依赖 Kubernetes）

### 11.1 结论：完全可以在单个 VM 上运行

项目提供了**一等公民级别的 Docker 本地部署模式**，Kubernetes 只是可选部署目标，不是必须的。

### 11.2 本地部署架构

`vllm-sr serve` 命令（Python CLI）在本地启动一组 Docker 容器，共享一个 Docker 网络：

```
┌─ 单个 VM / 本地机器 ────────────────────────────────────────┐
│                                                              │
│  ┌─ Docker Network: vllm-sr-network ──────────────────────┐  │
│  │                                                         │  │
│  │  ┌──────────────────┐     ┌──────────────────────────┐  │  │
│  │  │  Envoy Proxy     │────►│  Semantic Router (Go)    │  │  │
│  │  │  端口: 8801      │gRPC │  端口: 50051             │  │  │
│  │  │  (容器)          │     │  (容器)                   │  │  │
│  │  └──────┬───────────┘     └──────────────────────────┘  │  │
│  │         │                                                │  │
│  │         ├──────────► vLLM 后端 (本机或远程)              │  │
│  │         ├──────────► OpenAI API (远程)                   │  │
│  │         └──────────► Anthropic API (远程)                │  │
│  │                                                         │  │
│  │  ┌──────────────────┐                                   │  │
│  │  │  Dashboard (可选) │                                   │  │
│  │  │  端口: 8501      │                                   │  │
│  │  │  (容器)          │                                   │  │
│  │  └──────────────────┘                                   │  │
│  └─────────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐    │
│  │  vLLM 推理服务 (可以是容器或直接进程)                    │    │
│  │  端口: 8000                                           │    │
│  │  模型: deepseek-r1 / llama-3 / ...                    │    │
│  └──────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────┘
```

### 11.3 具体操作步骤

```bash
# 1. 构建本地开发镜像
make vllm-sr-dev

# 2. 启动所有组件（Envoy + Router + Dashboard）
vllm-sr serve --image-pull-policy never

# 对于 AMD GPU 平台
make vllm-sr-dev VLLM_SR_PLATFORM=amd
vllm-sr serve --image-pull-policy never --platform amd
```

### 11.4 本地模式下后端模型的配置

在本地模式下，后端模型通过**配置文件**（而非 K8s CRD）指定。你可以在 `config.yaml` 或 Recipe 文件中指定后端地址：

```yaml
# 后端可以是本机的 vLLM 实例
providers:
  models:
    - name: "my-model"
      provider: local-vllm
      backend_refs:
        - name: local-backend
          url: "http://localhost:8000"   # 本机 vLLM
          weight: 100
```

Envoy 配置会自动生成，将不同模型名映射到不同的后端地址。你也可以混合使用本地 vLLM 和远程 API（OpenAI、Anthropic）。

### 11.5 典型单 VM 使用场景

```
同一台 VM 上:
1. 运行 vLLM 服务 (GPU, 端口 8000) → 加载你的 LLM 模型
2. 运行 vllm-sr serve (Docker) → 启动 Router + Envoy
3. 客户端请求发到 Envoy 端口 (8801)
4. Router 分析请求语义，决定路由到本地 vLLM 还是远程 API
```

---

## 十二、ML 推理绑定层 — 模型权重从哪来

### 12.1 这些「模型」是什么

5 个 Rust→Go FFI 绑定层运行的**不是大语言模型（LLM）本身**，而是**小型分类/嵌入模型**，用于分析请求内容以做出路由决策。它们的作用类似于一个「智能分拣员」——快速判断请求的类型，然后决定把请求送到哪个大模型。

```
┌─────────────────────────────────────────────────────────┐
│  这些小模型的角色（在 Router 进程内运行）                    │
│                                                          │
│  用户请求 → [ModernBERT 分类器] → "这是代码问题"            │
│          → [嵌入模型] → 与候选短语计算相似度                 │
│          → [BM25/N-gram] → 关键词匹配得分                  │
│          → [KNN/SVM] → 复杂度/领域分类                     │
│                                                          │
│  路由决策: → 发送到 "代码专用大模型"                         │
└─────────────────────────────────────────────────────────┘
```

### 12.2 模型权重从 HuggingFace 下载

**模型权重不在代码库里，不在程序代码中。** 它们在**启动时从 HuggingFace 自动下载**。

启动流程：
```
程序启动 → ensureModelsDownloadedOrFatal()
         → 读取配置中引用的所有模型
         → 查询 ModelRegistry（本地路径 → HF Repo ID 映射表）
         → 检查本地是否已存在（看 config.json + 权重文件）
         → 缺失的模型调用 huggingface-cli download 下载
         → 下载完成后初始化 ML 推理运行时
```

### 12.3 模型注册表（Model Registry）

在 `src/semantic-router/pkg/config/registry.go` 中定义了 `DefaultModelRegistry`，包含约 20+ 个模型规格，每个映射一个本地路径到 HuggingFace 仓库：

| 本地路径 | HuggingFace Repo ID | 用途 | 大小 |
|---------|---------------------|------|------|
| `models/mom-embedding-pro` | `Qwen/Qwen3-Embedding-0.6B` | 语义嵌入 | ~600MB |
| `models/mom-classifier` | ModernBERT 分类器 | 领域/意图分类 | ~150MB |
| `models/mom-jailbreak` | 安全分类器 | 越狱检测 | ~150MB |
| `models/mom-complexity` | 复杂度估计器 | 难度评估 | ~150MB |
| ... | ... | ... | ... |

### 12.4 模型存储位置

```
/models/                          # 容器内的模型目录
├── mom-embedding-pro/            # Qwen3 嵌入模型
│   ├── config.json
│   ├── model.safetensors         # ← 这就是权重文件
│   └── tokenizer.json
├── mom-classifier/               # ModernBERT 分类器
│   ├── config.json
│   ├── model.safetensors
│   └── tokenizer.json
├── mom-jailbreak/                # 越狱检测模型
└── ...                           # 其他小模型
```

- **Docker 部署**: 模型下载到容器内，可通过 Volume 持久化
- **K8s 部署**: 通过 PVC 持久化，避免每次重启都重新下载
- **模型总大小**: 通常 1-3GB（都是小模型，不是 LLM）

### 12.5 与大模型（LLM）的关系

```
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  Router 内的小模型          后端的大模型 (vLLM)            │
│  ───────────────          ──────────────────              │
│  ModernBERT (~150MB)      DeepSeek-R1 (数十GB)           │
│  Qwen3-Embedding (600MB)  Llama-3.1-70B (数十GB)         │
│  BM25 (纯算法,无权重)       Qwen-Coder (数GB)             │
│                                                          │
│  作用: 分析请求语义         作用: 实际生成回答              │
│  延迟: <10ms              延迟: 100ms-数秒                │
│  运行位置: Router 进程内    运行位置: vLLM 独立服务          │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**总结**: 代码库里没有模型权重文件。5 个 Rust FFI 绑定层是**推理引擎**（类似于 PyTorch/TensorFlow 的角色），模型权重是**数据文件**，在启动时从 HuggingFace 自动下载。这些都是用于路由决策的小型模型（百MB级），不是真正做文本生成的大语言模型（数十GB级）。

---

## 十三、项目目录结构速览

```
semantic-router/
├── src/semantic-router/        # Go 主路由器（Envoy ExtProc 服务）
│   ├── cmd/                    #   启动入口
│   └── pkg/                    #   核心包
│       ├── extproc/            #     ExtProc 处理器和路由逻辑
│       ├── config/             #     配置解析和管理
│       └── server/             #     HTTP API 服务
├── candle-binding/             # Rust→Go FFI: ModernBERT 分类/嵌入
├── onnx-binding/               # Rust→Go FFI: ONNX Runtime 嵌入
├── openvino-binding/           # Rust→Go FFI: OpenVINO 推理
├── ml-binding/                 # Rust→Go FFI: KNN/SVM 传统 ML
├── nlp-binding/                # Rust→Go FFI: BM25/N-gram 文本匹配
├── config/                     # 路由配置文件
│   ├── signal/                 #   信号配置（17 种类型）
│   ├── decision/               #   决策规则
│   ├── algorithm/              #   算法参数
│   └── plugin/                 #   插件配置
├── deploy/                     # 部署相关
│   ├── operator/               #   K8s Operator（CRD + Controller）
│   ├── helm/                   #   Helm Chart
│   ├── recipes/                #   预定义配方
│   └── kubernetes/             #   原生 K8s 清单
├── dashboard/                  # Web 监控面板
│   ├── frontend/               #   React 前端
│   └── backend/                #   Go 后端
├── e2e/                        # 端到端测试
├── bench/                      # 性能基准测试
└── docs/                       # 文档
    └── architecture/           #   架构文档
```
