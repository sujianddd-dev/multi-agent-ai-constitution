# 多智能体记忆系统设计方案 v0.2（重构建议）

> **日期**：2026-10-22 ｜ **依据**：原设计稿 v0.1 + Hy-Memory / MemHub 调研 + GitHub/论文/EigenFlux 公开信号
>
> **一句话**：原设计不是“方向错了”，而是**把已经有人做好的东西又写了一遍**。v0.2 做减法：**一个共享记忆 Runtime + 一个人工 canonical 层 + 一个交接证据层**。

---

## 1. 为什么需要重构

原设计是「四层 + 一路由 + 六类记忆」：

- 原始会话层（JSONL/SQLite）
- 会话索引层（Qdrant/pgvector/deja-vu）
- 语义事实层（mem0）
- 权威知识层（Obsidian）
- Memory Gateway（自建 MCP）

调研后，最直接的重叠是腾讯开源的 **Hy-Memory** 及其 **MemHub**：

- **Hy-Memory**：双系统认知记忆引擎 + Python SDK；Chat 8 层（L0–L7）、Working/Coding 两层（facts + experiences）、Coding 版本演化链；ChromaDB/Qdrant/FAISS + Kuzu/Neo4j + SQLite；OpenAI 兼容 LLM/Embedding（可用 DeepSeek）。
- **MemHub**：本地优先的**共享记忆 Hub**；把 DSH、Hermes、Pi、Claude Code、Cursor、Codex、OpenCode、Qwen Code 等会话/编码轨迹汇总到**一份本地记忆**，再按授权给各 Host  Recall；有 Evidence → Hy Memory → Governance → Matters/Wiki 链路。
- **DSH 接入**：Profile 级 MCP Patch（`@deepseek-ai/dsh-mcp-client`），Core 扫描 `$DSH_HOME/sessions`；没有 Skill、没有 Capture Hook、没有 Prefetch。
- **权限边界**：Source grant / Harness sync / Model-content egress / Host recall 四个独立授权；Python Core 是唯一业务数据写入者；SQLite 单写者。
- **不做**：屏幕、Accessibility/AXTree、OCR、键鼠、剪贴板、后台录音。

也就是说，原设计的“共享记忆 + 路由 + 权限 + 来源 + 冲突”大部分已经被 MemHub 实现，而且实现得比 v0.1 更细。

**但 MemHub 有三个硬约束**：

1. **Windows 不支持**：v1.0.4 只发 Linux x64/arm64 与 macOS arm64/x64；Windows 无制品。
2. **很新**：2026-10-15 开源，v1.0.4，preview，45 个 open issues；不是“广泛认可/成熟”的生产依赖。
3. **默认授权偏宽**：DSH Profile 安装的默认授权可能包含 `all-apps`、所有 Source 和 Workspace；官方文档自己提示要复核。

所以结论不是“无脑换成 MemHub”，而是：**按 MemHub 的形态重构设计，同时保留 Windows 的回退路线。**

### 1.1 实际广播 / Issue 暴露的方向性问题（v0.2.1 修正）

> 2026-10-22 复核了 10+ 条 EigenFlux `demand` 与 Hy-Memory 的 45 个 open issues。以下是**方向级**问题，不是小 bug；v0.2 已按它们修正。

| 实际问题 | 证据 | 设计修正 |
|---|---|---|
| 索引 ≠ 处理；`empty` 与 `read_failure` 混为成功；读时 digest 冻结掩盖写后覆盖 | EigenFlux `370490645829124096`、`367567531889655808` | **Memory Authority Receipt**：`processed_receipt`、`authority_version`、`write_epoch`；`empty_confirmed` / `read_failure` 分列；覆盖写失败 |
| 上游空输出/截断被当成功；双写导致 digest 分叉 | `368688314619789312`、`359999804404662272`、`369922548206403584` | 单写者 + append-only evidence + 只读快照；fail-closed；四证据点 + digest |
| 摘要当事实底座：规则一变，50% 真值无法重算 | `365651562971791360` | 事件级 evidence 为真源；摘要/索引是 materialized view；保留 outcome/rule/exclusion |
| 固化/合并会提权：48/49 配置 authority collapse；来源污染最高 1.0 攻击成功率 | `352267496838922240`、`356289574164496384` | authority 与 confidence 分离；合并不继承权限；`authority_epoch`；使用前再验权；冲突 HOLD |
| 自动推断直接写 confirmed；episode L3 写侧静默吞、读侧默认关 | Hy-Memory [#120](https://github.com/Tencent-Hunyuan/Hy-Memory/issues/120)、[#121](https://github.com/Tencent-Hunyuan/Hy-Memory/issues/121) | `proposed → active` 闸；模型推断只能 `proposed`；无诊断不写 canonical |
| 固化/合并/回填的工程 bug：重复、deadlock、stranded jobs、ultra evolve 不收敛 | Hy-Memory [#26](https://github.com/Tencent-Hunyuan/Hy-Memory/issues/26)、[#72](https://github.com/Tencent-Hunyuan/Hy-Memory/issues/72)、[#88](https://github.com/Tencent-Hunyuan/Hy-Memory/issues/88)、[#105](https://github.com/Tencent-Hunyuan/Hy-Memory/issues/105)、[#118](https://github.com/Tencent-Hunyuan/Hy-Memory/issues/118)、[#119](https://github.com/Tencent-Hunyuan/Hy-Memory/issues/119) | 固化是 fenced write；no-op 合法；post-write verify；幂等回填；不无限自动重试 |
| DSH Profile Host ID 被拒、v3/v4 会话未导入；Windows 无制品 | Hy-Memory [#69](https://github.com/Tencent-Hunyuan/Hy-Memory/issues/69)、[#9](https://github.com/Tencent-Hunyuan/Hy-Memory/issues/9) | 测试 profile + dry-run；不把自动导入当正确性；Windows 走 MemOS/WSL |
| 跨设备权威副本不明；同步回执与本地时钟冲突 | `367567531889655808`、`370022538165616640` | `authority_version` + sync receipt；单一 canonical；冲突 HOLD |
| 召回不记 query/task：14,736 次注入无法证明“越用越聪明” | `368113353198927872` | 记录 why-recall（触发任务摘要/查询指纹）；评测表独立 |
| 淘汰只删原文，摘要/索引/缓存仍可恢复约 20% | `368885205588508672` | 淘汰级联清 derived；tombstone + purge receipt |
| 长会话压缩丢已确认决策 | `361010117786730496` | 决策单独 canonical；摘要必须 link `decision_id`；不可只靠压缩 |
| 导入边界：超长消息循环、子 Agent 转录被当用户会话、>2GiB schema 拒绝 | Hy-Memory [#68](https://github.com/Tencent-Hunyuan/Hy-Memory/issues/68)、[#117](https://github.com/Tencent-Hunyuan/Hy-Memory/issues/117)、[#102](https://github.com/Tencent-Hunyuan/Hy-Memory/issues/102) | 显式 adapter + dry-run + quarantine；长度/角色/来源校验 |
| 双写 Obsidian + 共享 Runtime 会分叉 | `368688314619789312`；v0.1 设计 | Obsidian 只做单写者 Curator/导出；不参与运行时写路径 |

**方向级结论**：问题不在“用哪个记忆库”，而在**记忆写入/固化/召回缺少权威回执与权限边界**。v0.2 必须先把这层补上，再谈接入哪个 Runtime。

---

## 2. v0.2 架构

```text
┌─────────────────────────────────────────────────────┐
│ Hosts：DSH / Hermes / Pi / Cursor / Codex / ...      │
│ 通过 MCP（DSH 为 Profile 级 Patch）或 Skill/CLI 调用  │
└───────────────────────┬─────────────────────────────┘
                        │  只读 Recall + 受控写入
                        ▼
┌─────────────────────────────────────────────────────┐
│ 共享记忆 Runtime：MemHub（首选）或 MemOS（Windows）   │
│  - Evidence → Hy Memory → Governance → Matters/Wiki  │
│  - 单写者 SQLite + 向量/图存储                        │
│  - Source / Sync / Model egress / Host recall 四授权 │
└───────────────────────┬─────────────────────────────┘
                        │  可选导出/审阅
                        ▼
┌─────────────────────────────────────────────────────┐
│ 人工 canonical：Obsidian Vault（可选，但推荐保留）     │
│  - Markdown + Git；人类可读、可回滚                   │
│  - Agent 只写 inbox，Curator 提升到 canonical         │
│  - 只放“已确认”的决策/项目知识，不复制原始会话         │
└───────────────────────┬─────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────┐
│ 交接证据层（四证据点）                                │
│ 输入来源/版本 · 交付物路径 · 执行回执 · 检查结果       │
│ 缺一 → pending-review，不得写“完成”                   │
└─────────────────────────────────────────────────────┘
```

> **横切层：Memory Integrity / Authority**（不存业务内容，只做约束）
> 单写者 · append-only evidence · `processed_receipt` / `read_receipt` · `authority_epoch` · `proposed → active` 闸 · 使用前再验权 · 固化 = fenced write · `no-op` 合法 · 冲突 HOLD · 淘汰级联清 derived。

### 组件职责

| 组件 | 职责 | 不做什么 |
|---|---|---|
| MemHub / Hy-Memory | 会话/编码轨迹导入、抽取、去重、冲突、检索、治理、Matters/Wiki | 不负责人工 Markdown 编辑与 Git |
| Memory Integrity / Authority | 单写者、receipt、authority vs confidence、proposed→active、use-time auth、consolidation fence | 不存业务内容 |
| Obsidian | 人类可读 canonical、决策/项目知识、Git 版本；只收 `active` | 不做向量检索、不做自动抽取、不做多 Agent 并发 |
| 四证据点 | 交接回执与验收 | 不替代记忆检索 |
| 薄 Host 适配 | Windows ↔ WSL/Linux 的 MCP/stdio 桥（如需要） | 不实现存储/检索/抽取 |

---

## 3. 保留 / 删除 / 只写这五样

### 保留

- Obsidian 作为**人类可读 canonical**（如果这是硬需求；否则可用 MemHub 的 Matters/Wiki）。
- Agent 只写 `00-inbox/<agent>/`，Curator 提升到 canonical；只收 `active`。
- 跨 Agent 默认只读；来源、版本、trust/taint、撤销。
- 四证据点（已进 PR 模板）。
- 本地优先、原始会话不默认离开本机。
- `processed_receipt` / `read_receipt` + `authority_epoch`；单写者 + append-only evidence + 只读快照。
- `proposed → active` 闸：模型推断只能 `proposed`，不能直接 confirmed。
- authority 与 confidence 分离；合并/固化不继承权限；使用前再验权。
- 生命周期：`no-op` 合法、冲突 HOLD、淘汰级联清 derived。

### 删除

- 自建 Memory Gateway（用 MemHub 的 MCP/Host Bridge）。
- 自建 Qdrant 会话索引（Hy-Memory 已支持 Chroma/Qdrant/FAISS）。
- 自建 mem0 语义层（Hy-Memory 已有 facts/experiences；Mem0 只在需要时作为补充）。
- 自建六类记忆 taxonomy（Hy-Memory 8 层 + Working/Coding 两层；MIRIX 六类可参考）。
- 自建冲突/去重/生命周期引擎（Hy-Memory / MemHub Governance 已有）。
- 自建 Memory UI（MemHub 有 Memory Viewer / Matters/Wiki）。
- 自动 confirmed 写入；把摘要/索引当事实底座。

### 只写这五样

1. **Memory Contract**：来源、版本、trust/taint、scope、`evidence_id`、`supersedes`、`status`（`proposed/active/superseded/conflict`）、`authority` 与 `confidence` 分开。
2. **Memory Integrity / Authority**：单写者、append-only evidence、`processed_receipt` / `read_receipt`、`authority_epoch`、`proposed→active` 闸、use-time auth、consolidation fenced write、`no-op`/HOLD。
3. **Host 适配/策略**：Windows↔WSL 的 MCP 桥（如需要）、DSH Profile 授权收敛、跨 Agent 只读、导入 dry-run/quarantine。
4. **Obsidian Curator Workflow**：inbox → 审阅 → canonical → Git；只存已确认知识；摘要必须 link `decision_id`。
5. **Evaluation Harness**：CMB / LoCoMo / LongMemEval + 交接/冲突/撤销/并发/污染/召回归因场景。

---

## 4. 两条落地路线

### 路线 A：WSL/Linux 跑 MemHub（推荐，如果接受 WSL）

- 在 WSL2 Ubuntu 安装 MemHub Linux Runtime（官方支持 Linux x64）。
- DSH 通过 Profile 级 MCP Patch 连接；Windows DSH 需要把 MCP command 指向 `wsl.exe -d Ubuntu -- ...`（**非官方路径，需要薄桥**）。
- Hermes / Pi 按官方 harness-support 文档接入。
- Obsidian 保留，作为人工 canonical；MemHub 的 Matters/Wiki 作为治理视图。
- 先跑 2 周测试 profile，不动生产。

**适合**：能接受 WSL 常驻、愿意做一次薄桥、想尽快用上共享记忆。

### 路线 B：Windows 原生，先用 MemOS（保守）

- DSH 用 **MemOS 本地插件**（官方支持 DSH、Windows PowerShell、SQLite + FTS5 + 向量、L1/L2/L3、多 Agent）。
- Hermes/Pi 先用各自记忆或轻量 MCP；Obsidian 作为 canonical。
- MemHub 作为“Windows 支持后再评估”的候选，不阻塞当前工作。
- 先跑 2 周 A/B，再决定是否迁移。

**适合**：不想引入 WSL 常驻、要求 Windows 原生、对 preview 项目谨慎。

---

## 5. 从 v0.1 迁移的最小步骤

1. **冻结旧四层写路径**：不再新增 Qdrant/mem0 自建管线；已有数据保留只读。
2. **先上 Integrity 闸**：单写者、append-only evidence、`processed_receipt`/`read_receipt`、`authority_epoch`、`proposed→active`；没有这层，不接任何 Runtime。
3. **选一个共享 Runtime**：MemHub（WSL）或 MemOS（Windows）。
4. **建 Memory Contract**：把原设计的 frontmatter 扩展为 `evidence_id / source / trust / taint / supersedes / scope / authority / confidence / status`。
5. **Obsidian 只做 canonical**：Agent 写 inbox；Curator 提升；只收 `active`；摘要必须 link `decision_id`。
6. **收敛 DSH 授权**：不要默认 `all-apps` + 所有 Source/Workspace；按 Profile/Project 最小授权。
7. **接入四证据点**：PR 模板已加；后续所有交接按此验收。
8. **评测**：CMB（编码）、LoCoMo/LongMemEval（对话）、自建交接/冲突/撤销/并发/污染/召回归因场景；有数据再决定是否保留 Obsidian/Mem0。

---

## 6. 需要人类拍板的 7 个问题

1. **Windows 是否必须原生？** 是 → 路线 B（MemOS）；否/可 WSL → 路线 A（MemHub）。
2. **Obsidian + Git 是否硬需求？** 是 → 保留 canonical 层；否 → MemHub Matters/Wiki 可能足够。
3. **MemHub preview 风险是否接受？** 只用于测试 profile，还是生产？
4. **License**：Hy-Memory 是 Apache-2.0（自定义头，GitHub 显示 Other）；MemHub 的 LICENSE 需单独核对；MemOS 是 Apache-2.0。
5. **默认授权**：DSH Profile 是否只给当前项目/来源，而不是 `all-apps` + 全部 Workspace？
6. **是否允许模型推断直接 confirmed？** 建议默认不允许：只能 `proposed`，由 Curator/人类或明确策略提升。
7. **authority 与 confidence 是否分开？** 建议必须分开；合并/固化不能继承权限，工具调用前按 action-relevant memories 再验权。

---

## 7. 结论

- **要重构，但不是重写**：把“四层 + 自建网关”收缩为“一个共享 Runtime + 一个 Obsidian canonical + 四证据点 + 一层 Integrity/Authority”。
- **实际广播/Issue 暴露的问题比“选哪个库”更根本**：索引≠处理、静默失败、双写分叉、固化提权、摘要当事实底座、自动 confirmed、淘汰残留。v0.2.1 已把这些写进硬约束。
- **Hy-Memory/MemHub 是目前最接近你目标的方案**，但 Windows 不支持 + preview，不能直接当生产依赖。
- **Windows 原生今天可落地的是 MemOS**；MemHub 值得在 WSL 做 2 周试点。
- **无论选哪条**，都不要再自建 Qdrant/mem0/六类/网关；把精力放在 **Integrity/Authority + canonical 治理 + 交接证据 + 评测**。

---

## 8. 参考

- [Hy-Memory](https://github.com/Tencent-Hunyuan/Hy-Memory) ｜ [MemHub README](https://github.com/Tencent-Hunyuan/Hy-Memory/blob/main/memhub/README.md)
- [DSH 接入说明](https://github.com/Tencent-Hunyuan/Hy-Memory/blob/main/memhub/docs/harness-support/deepseek-harness.md)
- [Harness 支持矩阵](https://github.com/Tencent-Hunyuan/Hy-Memory/blob/main/memhub/docs/harness-support/README.md)
- [MemHub 架构](https://github.com/Tencent-Hunyuan/Hy-Memory/blob/main/memhub/docs/ARCHITECTURE.md)
- [Memory Beyond Recall（EMNLP 2026）](https://arxiv.org/abs/2606.09483)
- [Hy-Memory-30B-A3B 技术报告](https://arxiv.org/abs/2610.22196)
- [调研全文](./MEMORY-SYSTEMS-RESEARCH.md)
