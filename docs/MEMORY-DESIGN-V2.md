# 多智能体记忆系统设计方案 v0.2（重构建议）

> **版本**：v0.2.5（2026-10-22，含 Dream 整合） ｜ **依据**：原设计稿 v0.1 + Hy-Memory / MemHub 调研 + GitHub/论文/EigenFlux 公开信号 + 首批广播回复
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

### 1.2 首批回复带来的修正（v0.2.2）

> 2026-10-22 收到两条一线工程回复，均为真实踩坑；已抽象进设计。

| 反馈的问题 | 设计修正 |
|---|---|
| 摘要生成后旧段原文被压缩；口径/模型版本变了无法重算 | 摘要必须带 `generator_version` / `rule_version` / `model_version`；版本变更后旧段标 `NOT_COMPARABLE` 并隔离，不覆盖 |
| SQLite 向量库不可用时静默 fallback 到 JSON；召回质量变了但调用方无感知 | 每个 evidence point 记录 `execution_path`（`primary/degraded/skipped`）+ `degraded_reason`；降级必须显式进回执 |
| 提交侧 `rc=0`/计数增加，但真实状态没落库（`processed != landed`） | 拆成 `processed_receipt`（提交侧）与 `landed_receipt`（消费侧读回签名）；提交计数只当导航 |
| 长耗时阶段持 DB 连接，空闲被服务端静默断开，故障延迟出现 | 用前 pre-ping；任务幂等可重跑；不长期持有空闲连接 |
| `authority_epoch` 若全局单调，会作废其他 Agent 的 `proposed` | `authority_epoch` 按 `(agent_id, scope)` 分片单调；跨 Agent 用 `authority_epoch_set`，不做全局计数器 |

**v0.2.2 结论**：Integrity 不只是“有没有回执”，还要回答**哪条路径、哪个版本、谁读回、哪个 scope 的 authority**。

### 1.3 读时版本戳（v0.2.3）

> 2026-10-22 收到一条补充：**“读后旧版本覆盖”和“召回不记 query/task”是同一个根因**——读的时候没有绑定读取意图的版本快照，写回时就分不清自己是基于哪一版做出的判断。

| 问题 | 设计修正 |
|---|---|
| 读后旧版本覆盖：读到的版本与写回时的当前版本不一致，静默覆盖 | `read_receipt` 记录 `read_version` + `read_intent`（query/task fingerprint）；写回必须带 `base_version`，与当前版本比对；不匹配 → `STALE_READ`，拒绝覆盖，要求 re-read / retry / merge |
| 召回不记 query/task，无法证明“为什么召回” | `read_intent` 与 why-recall 共用同一个 intent fingerprint；读、写、评测三处可对账 |

**v0.2.3 结论**：只加 `processed/landed` 还不够；**读也要带版本戳，写回要验 base_version**。否则“读到了”与“基于哪一版写回”仍然是两笔糊涂账。

### 1.4 B 段验收字段（v0.2.4）

> 2026-10-22 B 段匿名样本对拍后，补两个回执验收格。

| 字段 | 规则 |
|---|---|
| `retrieval_backend` | 显式落在 receipt 的 `schema_version` 栏：`primary=sqlite/vector`、`degraded=keyword/json`、`skipped=null`；不能只写 `execution_path` |
| `fallback_reason` | `degraded/skipped` 必填（`embed_timeout` / `quota_guard` / ...）；与 `degraded_reason` 同源 |
| `cmp_source` | `NOT_COMPARABLE` 只能由 comparator 产出，标 `cmp_source=comparator`；读表人不能手填 |
| `cmp_receipt` | 绑定两段 `spec` 与 digest；旧段按行内 spec 判定，不补算 |

**v0.2.4 结论**：回执要能回答“用的哪个 retrieval backend、为什么降级、谁判定不可比”，而不是只记录一个 `execution_path`。

### 1.5 Dream 模式：空闲整合（v0.2.5）

> 参考：**PilotDeck**（OpenBMB/清华 THUNLP/面壁）的 Dream Mode：空闲窗口整理记忆碎片、白盒可查、一键回滚；**Claude Dreams** 也把“读取现有记忆 + 历史会话，整理重复/冲突/过时内容”做成异步任务。两者都证明“整合”是独立阶段，不是写入的副作用。

Dream 不是自动把摘要变成事实；它是**产生 proposed 候选 + 可回滚回执**的整合流程。

| 风险 | 硬约束 |
|---|---|
| 摘要覆盖原始证据 | 原始 fragment 只追加、不修改；Dream 只读快照，不改 raw |
| 旧版本内容被静默合并 | 输入带 `read_version`；版本不一致 → `NOT_COMPARABLE`，不重算 |
| 模型“归纳”被当成事实 | 输出一律 `status=proposed`、`authority=candidate`；不得直接 `active` |
| 整合后无法追责/回滚 | 产出 `dream_receipt`：`dream_id`、输入清单与版本、before/after、计数、rollback 指针 |
| 外部内容被提升 | `trust/taint` 原样保留；外部广播/私信不得因 Dream 获得 authority |
| 半途失败留下半成品 | 幂等、可重跑；`execution_path` + `landed_receipt`；失败不覆盖 canonical |

**流程**：

1. 触发：空闲窗口、owner 明确请求，或累计 N 个未整合 fragment；**不是每轮对话**。
2. 快照：记录输入 note 的 `read_version`；raw fragments 不变。
3. 聚类/去重/冲突：按 scope、实体、时间窗；旧 spec/旧 generator 段直接 `NOT_COMPARABLE`。
4. 生成候选：`summary` 带 `generator/rule/model_version`、source ids、`read_version`；写入 `proposed`。
5. 回执：`dream_receipt` + 可回滚快照；one-click rollback 只新增回滚版本，不删除历史。
6. 审核：Curator 逐条 diff；只有明确批准的条目才能 `proposed → active`；其余留在 proposed/archive。

**Dream 的最小验收**：重复项不重复、冲突不被静默合并、过期项不覆盖新项、raw 可追溯、回滚可恢复、负控样本必红、正控干净批次不得红。

**当前落地**：`@jacklika/dsh-memory` + Obsidian vault 已能保存 raw note；本日已做一次 **手动 Dream pass**：`shared/notes/2026-10-22-dream-proposal.md`（proposed，未提升），输入为 activation note 与 session digest。自动触发器和 `dream_receipt` 运行时仍未实现。

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
> 单写者 · append-only evidence · `processed_receipt` / `landed_receipt` / `read_receipt` · `read_version` / `base_version` / `STALE_READ` · `retrieval_backend` / `fallback_reason` / `cmp_source` · `authority_epoch`（per agent/scope） · `execution_path` · `generator_version` · `dream_receipt` / `dream_id` / rollback · `proposed → active` 闸 · 使用前再验权 · 固化 = fenced write · `no-op` 合法 · 冲突 HOLD · 淘汰级联清 derived。

### 组件职责

| 组件 | 职责 | 不做什么 |
|---|---|---|
| MemHub / Hy-Memory | 会话/编码轨迹导入、抽取、去重、冲突、检索、治理、Matters/Wiki | 不负责人工 Markdown 编辑与 Git |
| Memory Integrity / Authority | 单写者、receipt、authority vs confidence、proposed→active、use-time auth、consolidation fence、`execution_path`、`generator_version`、`landed_receipt`、`read_version`/`base_version`/`STALE_READ`、`retrieval_backend`/`fallback_reason`/`cmp_source`、`dream_receipt`/`dream_id`/rollback | 不存业务内容 |
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
- `processed_receipt` / `read_receipt` + `authority_epoch`；单写者 + append-only evidence + 只读快照；`read_version`/`base_version`，不匹配即 `STALE_READ`。
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
2. **Memory Integrity / Authority**：单写者、append-only evidence、`processed_receipt` / `landed_receipt` / `read_receipt`、`read_version` / `base_version` / `STALE_READ`、`retrieval_backend` / `fallback_reason` / `cmp_source`、`dream_receipt` / `dream_id` / rollback、`authority_epoch`（per agent/scope）、`authority_epoch_set`、`execution_path`、`generator_version`、`proposed→active` 闸、use-time auth、consolidation fenced write、`no-op`/HOLD、pre-ping + 幂等重跑。
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

## 6. 需要人类拍板的 8 个问题

1. **Windows 是否必须原生？** 是 → 路线 B（MemOS）；否/可 WSL → 路线 A（MemHub）。
2. **Obsidian + Git 是否硬需求？** 是 → 保留 canonical 层；否 → MemHub Matters/Wiki 可能足够。
3. **MemHub preview 风险是否接受？** 只用于测试 profile，还是生产？
4. **License**：Hy-Memory 是 Apache-2.0（自定义头，GitHub 显示 Other）；MemHub 的 LICENSE 需单独核对；MemOS 是 Apache-2.0。
5. **默认授权**：DSH Profile 是否只给当前项目/来源，而不是 `all-apps` + 全部 Workspace？
6. **是否允许模型推断直接 confirmed？** 建议默认不允许：只能 `proposed`，由 Curator/人类或明确策略提升。
7. **authority 与 confidence 是否分开？** 建议必须分开；合并/固化不能继承权限，工具调用前按 action-relevant memories 再验权。
8. **authority epoch 的 scope？** 建议按 `(agent_id, scope)` 分片单调；跨 Agent 用 `authority_epoch_set`；不要全局计数器，否则一个 Agent 的 epoch 推进会误伤其他 Agent 的 `proposed`。

---

## 7. 结论

- **要重构，但不是重写**：把“四层 + 自建网关”收缩为“一个共享 Runtime + 一个 Obsidian canonical + 四证据点 + 一层 Integrity/Authority”。
- **实际广播/Issue/首批回复暴露的问题比“选哪个库”更根本**：索引≠处理、静默失败、双写分叉、固化提权、摘要当事实底座、自动 confirmed、淘汰残留、静默降级、`processed != landed`、全局 epoch 误伤、读后旧版覆盖、retrieval backend/不可比来源不透明、Dream 误合并。v0.2.5 已把这些写进硬约束。
- **Dream 是独立阶段，不是写入副作用**：PilotDeck 与 Claude Dreams 都证明“空闲整合 + 白盒 + 回滚”有价值；但整合必须产出 proposed + `dream_receipt`，不能把摘要直接提升为事实。
- **Hy-Memory/MemHub 是目前最接近你目标的方案**，但 Windows 不支持 + preview，不能直接当生产依赖。
- **Windows 原生今天可落地的是 MemOS**；MemHub 值得在 WSL 做 2 周试点。
- **无论选哪条**，都不要再自建 Qdrant/mem0/六类/网关；把精力放在 **Integrity/Authority + canonical 治理 + 交接证据 + 评测**。

---

## 8. 参考

- [PilotDeck](https://github.com/OpenBMB/PilotDeck)（Dream Mode：空闲整合、白盒记忆、一键回滚）
- [Claude Dreams 文档](https://platform.claude.com/docs/zh-CN/managed-agents/dreams)（读取现有记忆 + 历史会话，整理重复/冲突/过时内容）
- [Hy-Memory](https://github.com/Tencent-Hunyuan/Hy-Memory) ｜ [MemHub README](https://github.com/Tencent-Hunyuan/Hy-Memory/blob/main/memhub/README.md)
- [DSH 接入说明](https://github.com/Tencent-Hunyuan/Hy-Memory/blob/main/memhub/docs/harness-support/deepseek-harness.md)
- [Harness 支持矩阵](https://github.com/Tencent-Hunyuan/Hy-Memory/blob/main/memhub/docs/harness-support/README.md)
- [MemHub 架构](https://github.com/Tencent-Hunyuan/Hy-Memory/blob/main/memhub/docs/ARCHITECTURE.md)
- [Memory Beyond Recall（EMNLP 2026）](https://arxiv.org/abs/2606.09483)
- [Hy-Memory-30B-A3B 技术报告](https://arxiv.org/abs/2610.22196)
- [调研全文](./MEMORY-SYSTEMS-RESEARCH.md)
