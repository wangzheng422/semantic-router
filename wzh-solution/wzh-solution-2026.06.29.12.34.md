# Round 12: Red Hat 风格 E2E 汇报 PPT 交付说明

| 字段 | 值 |
|---|---|
| 日期 | 2026-06-29 |
| 目标 | 基于 round 11 E2E 运维文档制作一份面向客户汇报的 PPT |
| 设计工作流 | `baoyu-design` deck workflow + editable PPTX export |
| 风格 | Red Hat publication style: 白底、红色规则线、黑/灰正文、克制版式 |
| 字号要求 | 用户要求最小 16 号；本 deck 最小 CSS 字号为 22px，约 16.5pt |

## 交付物

- HTML deck: [Semantic Router E2E Report.html](../designs/semantic-router-redhat-report/Semantic%20Router%20E2E%20Report.html)
- 可编辑 PPTX: [semantic-router-e2e-redhat-report.pptx](../designs/semantic-router-redhat-report/semantic-router-e2e-redhat-report.pptx)
- 浏览器预览截图: [preview.png](../designs/semantic-router-redhat-report/preview.png)
- PPTX 导出配置: [pptx-config.json](../designs/semantic-router-redhat-report/pptx-config.json)
- 设计 scratchpad: [scratchpad.md](../designs/semantic-router-redhat-report/scratchpad.md)
- deck-stage runtime: [deck-stage.js](../designs/semantic-router-redhat-report/deck-stage.js)

## 内容结构

Deck 共 16 页，按“客户汇报”叙事组织：

1. 标题页：vLLM Semantic Router E2E 实验汇报
2. 本次实验回答六个运维问题
3. 端到端链路由五层组成
4. 环境基线先解决重启恢复问题
5. 两个 Qwen 后端形成成本与能力梯度
6. 场景一用固定小模型验证链路
7. 场景二用关键词建立第一层分流
8. 场景三用模型卡片解释选择依据
9. 场景四用 hybrid 平衡质量与成本
10. 场景五验证多轮主题切换
11. 场景六用 semantic-cache 降低重复请求成本
12. Dashboard 把路由配置和状态交给运维
13. 客户可以按 runbook 完成全量实验
14. 交付验收看响应头、模型和端口
15. 生产化需要补齐治理和边界验证
16. 建议按五周路径推进落地

## 设计说明

本 deck 使用白色背景、顶部 Red Hat 红色规则线、灰色信息块、红色强调边线、黑色大标题和灰色辅助文本。未使用渐变、深色满屏背景、装饰性圆点或复杂插画，保持出版物和客户技术汇报的克制风格。

PPTX 通过 `gen-pptx` 从 HTML deck 导出。导出验证显示 PPTX slide XML 中包含 `<a:t>` 文本节点，例如第一页标题、正文和页脚，因此不是单纯截图扁平化。

## 校验结果

- HTML deck 页数: 16
- PPTX 页数: 16
- PPTX 文件大小: 473,265 bytes
- 最小字号: 22px，约 16.5pt
- 预览服务: `http://127.0.0.1:4311/semantic-router-redhat-report/Semantic%20Router%20E2E%20Report.html`
- 浏览器截图: 已生成 [preview.png](../designs/semantic-router-redhat-report/preview.png)
- 敏感信息扫描: 未发现真实密码、token、API key、私钥或远端 host；命中项仅为普通技术词，如 `tokens`、价格模型字段。

## 注意事项

PPTX 导出器提示 `no_speaker_notes`，表示 deck 没有 speaker notes。这是当前汇报版本的预期状态，不影响可编辑 PPTX 和展示。
