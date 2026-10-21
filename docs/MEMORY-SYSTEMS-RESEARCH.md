# 多智能体记忆系统：现状调研与复用建议

> **调研日期**：2026-10-22 ｜ **范围**：一份本地「四层 + 一路由」记忆设计稿、GitHub 主流项目、EigenFlux 公开广播、近两年论文与基准
>
> **结论先行**：设计方向是对的，但**不要从零实现四层四库**。这个领域已经有 MemOS、MIRIX、Mem0、Letta、Zep/Graphiti、Cognee、Hindsight 等成熟组件；真正值得自己写的只有**薄的路由/权限/来源治理层**和**人类可读的 canonical 工作流**。

---

## 1. 设计稿在做什么

设计稿提出四层 + 一个路由：

| 层 | 职责 | 设计稿选型 |
|---|---|---|
| 原始会话层 | 只读、可追溯的会话归档 | JSONL / SQLite |
| 会话索引层 | 分块、向量化、语义检索 | Qdrant / pgvector / deja-vu |
| 语义事实层 | 偏好、决策、稳定事实 | mem0 |
| 权威知识层 | 人类可读、可 Git 管理 | Obsidian Vault |
| 路由层 | 统一检索、权限、来源、冲突 | 自建 Memory Gateway（MCP） |

记忆分类为 6 类：Working、Episodic、Semantic、Procedural、Entity、Decision。这个分类本身不新——MIRIX 的六类（Core、Episodic、Semantic、Procedural、Resource、Knowledge Vault）几乎一一对应；MemOS 则用 L1/L2/L3 和 Memory Cube 做生命周期与隔离。

**设计稿真正有差异化的部分**不是“分层”，而是：

1. **Obsidian 作为人类可读的 canonical 层**（可编辑、可 Git、可回滚）；
2. **Agent 只写 inbox，canonical 由人或 Curator 提升**；
3. **跨 Agent 默认只读 + 来源标注 + 冲突处理**；
4. 把记忆和**交接证据**（谁在什么时候、基于哪个版本写了什么）绑定。

这四点值得保留；其余存储/抽取/检索/图谱能力应优先复用。

---

## 2. GitHub 现状：谁已经做过了

> Star、License、最后 push 时间为 2026-10-21 通过 GitHub API 读取。**Star 只是热度，不代表成熟度**；本项目更看重论文、维护活跃度、License 和是否有可复用的 MCP/本地部署方式。

| 项目 | Stars | License | 最后 push | 它解决什么 | 与本设计的关系 |
|---|---:|---|---|---|---|
| [mem0ai/mem0](https://github.com/mem0ai/mem0) | 67.6k | Apache-2.0 | 2026-10-21 | 语义事实抽取、合并、检索；有 graph 变体 | 设计稿已选它；可继续用 OSS 版 |
| [vectorize-io/hindsight](https://github.com/vectorize-io/hindsight) | 52.3k | MIT | 2026-10-21 | retain / recall / reflect，强调“学习”和反馈 | 补设计稿缺的反馈/遗忘闭环 |
| [letta-ai/letta](https://github.com/letta-ai/letta) | 25.2k | Apache-2.0 | 2026-10-18 | MemGPT 的工程化：core / archival / recall 分层 | 补 Working/Archival 分层；但它是 Agent 平台，较重 |
| [getzep/graphiti](https://github.com/getzep/graphiti) | 32.1k | Apache-2.0 | 2026-10-21 | 时序知识图谱、实体关系、时间维度 | 替代“Entity + 时间”自建图谱 |
| [topoteretes/cognee](https://github.com/topoteretes/cognee) | 32.6k | Apache-2.0 | 2026-10-21 | 记忆图谱、数据管线、长期记忆平台 | 替代自建抽取/图谱管线 |
| [MemTensor/MemOS](https://github.com/MemTensor/MemOS) | 12.0k | Apache-2.0 | 2026-10-21 | Memory OS：store/retrieve/manage、生命周期、隔离、混合检索 | **最接近“四层 + 路由”的整体方案** |
| [Mirix-AI/MIRIX](https://github.com/Mirix-AI/MIRIX) | 3.5k | Apache-2.0 | 2026-10-08 | 六类记忆 + 多 Agent 协调 + 本地 Postgres | **最接近设计稿的 6 类分类** |
| [TencentCloud/TencentDB-Agent-Memory](https://github.com/TencentCloud/TencentDB-Agent-Memory) | 29.7k | Other（README 标 MIT） | 2026-10-21 | 团队级记忆 Hub：Chat Memory / Skill / LLM-Wiki / Code-Graph | 最接近“多 Agent 共享记忆” |
| [MemoriLabs/Memori](https://github.com/MemoriLabs/Memori) | 17.2k | Other | 2026-10-03 | Agent 原生结构化状态、企业部署 | 可参考，但 License 需先核对 |
| [basicmachines-co/basic-memory](https://github.com/basicmachines-co/basic-memory) | 4.3k | AGPL-3.0 | 2026-10-21 | Markdown + MCP 的 AI 记忆 | 最接近“Obsidian canonical + MCP” |
| [langchain-ai/langmem](https://github.com/langchain-ai/langmem) | 1.7k | MIT | 2026-10-02 | 热路径/后台记忆形成 | 若已在 LangGraph 生态可复用 |
| [langchain-ai/langgraph](https://github.com/langchain-ai/langgraph) | 43.7k | MIT | 2026-10-21 | checkpointer / long-term store | 持久化状态与线程记忆的成熟底座 |
| [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) | 91.4k | Other | 2026-10-19 | 官方 MCP 参考 server（含 memory） | 简单知识图谱；不适合多 Agent 规模化 |
| [crewAIInc/crewAI](https://github.com/crewAIInc/crewAI) | 60.0k | MIT | 2026-10-21 | 多 Agent 框架，内置短/长/实体记忆 | 若用 CrewAI，直接用它的 memory |
| [microsoft/autogen](https://github.com/microsoft/autogen) | 61.5k | CC-BY-4.0 | 2026-10-16 | 多 Agent 框架 | 记忆多靠外部集成（如 Mem0） |
| [openai/openai-agents-python](https://github.com/openai/openai-agents-python) | 30.2k | MIT | 2026-10-20 | Agents SDK + Sessions | 会话记忆；不是跨 Agent 语义记忆 |

### 2.1 最值得先看的四个

1. **MemOS**：唯一明确提供 **DeepSeek Harness 本地插件**（Windows PowerShell 安装、SQLite + FTS5 + 向量、去重、L1/L2/L3、多 Agent 协作、Memory Viewer）的项目。它已经覆盖设计稿的“会话索引 + 语义 + 路由 + 生命周期”大半。
2. **MIRIX**：六类记忆 + 多 Agent 协调，和设计稿的 6 类几乎同构；论文报 LOCOMO 85.4%，本地 Postgres，适合做“分类与多 Agent 协调”的参考实现。
3. **Hindsight**：强调“学习而不只是记住”，有 retain/recall/reflect 和反馈闭环；补设计稿缺的遗忘与反思。
4. **basic-memory**：Markdown + MCP，最接近“Obsidian canonical”的现成实现；但 **AGPL-3.0**，嵌入前要评估许可证。

### 2.2 许可证与成熟度提醒

- **TencentDB-Agent-Memory**：README 标 MIT，但 GitHub License 检测为 **Other**；商用/嵌入前必须读 LICENSE。
- **Memori**：License 检测为 **Other**，不适合直接当核心依赖。
- **basic-memory**：**AGPL-3.0**；若修改并通过网络提供服务，可能触发 copyleft 义务。
- **Star 通胀**：2026 年出现大量高 Star 的“agent memory”仓库，部分是新项目/营销驱动；不要只看 Star，至少看论文、release、最近 commit、issue 响应和独立复现。

---

## 3. 论文与基准：哪些结论可以信

### 3.1 综述

- **《Memory for Autonomous LLM Agents: Mechanisms, Evaluation, and Emerging Frontiers》**（arXiv:2603.07670，2026-03）把记忆形式化为 **write–manage–read** 循环，给出时间范围、表示载体、控制策略三维分类，并总结五类机制：上下文压缩、检索存储、反思式自我改进、层级虚拟上下文、策略学习管理。它明确指出当前评测正从静态回忆转向多会话 agentic 测试，开放问题包括持续巩固、因果检索、可信反思、学习式遗忘、多模态记忆。
- **《Memory in the Age of AI Agents》**（arXiv:2512.13564，2025-12）从 forms / functions / dynamics 三个轴整理记忆，适合作为术语表。

### 3.2 代表系统

| 系统 | 论文 | 关键结论（论文/官方口径） |
|---|---|---|
| MemGPT / Letta | arXiv:2310.08560 | 用 OS 式虚拟上下文管理分层记忆；core / archival / recall |
| Mem0 | arXiv:2504.19413 | LOCOMO 上比 OpenAI 记忆相对提升 26%，p95 延迟降低 91%，token 成本降低 90%+ |
| Zep / Graphiti | arXiv:2501.13956 | DMR 94.8% vs MemGPT 93.4%；LongMemEval 最高 +18.5%，延迟降低 90% |
| MemOS | arXiv:2507.03724 | 把记忆当系统资源：调度、生命周期、治理、版本/来源审计；官方称 LOCOMO 88.83、LongMemEval 89.20 |
| MIRIX | arXiv:2507.07957 | 六类记忆 + 多 Agent；LOCOMO 85.4%；多模态 ScreenshotVQA 比 RAG 高 35% |
| MemoryOS | arXiv:2506.06326 | 层级记忆管理；短/中/长期分层 |
| A-MEM | arXiv:2502.12110 | Zettelkasten 式笔记记忆，动态链接与记忆演化 |
| BMAM | ACL 2026 Findings | 脑启发的多 Agent 记忆，LOCOMO 78.45%；LongMemEval 多会话 45.2%→56.4% |

> 这些数字大多来自论文或厂商自报，**不等于在你的数据上有效**。尤其“多 Agent 共享记忆”目前没有统一基准：LoCoMo/LongMemEval 主要测单 Agent 长对话；MemoryBench、AgentMemBench、AuthMem-Bench、BMAM 等才开始覆盖多会话/多 Agent/权威性。上线前必须用自己的场景做 A/B。

### 3.3 评测建议

- 外部基准：**LoCoMo**、**LongMemEval**、**MemoryBench**（arXiv:2510.17281）、**AgentMemBench**、**AuthMem-Bench**；
- 自己的场景测试至少覆盖：
  1. **交接**：A 写、B 读，B 能否复述来源与版本；
  2. **冲突**：两个 Agent 写入矛盾事实，系统是否标记而不是静默覆盖；
  3. **撤销/过期**：删除或降权后，检索是否立即失效；
  4. **污染**：低信任来源是否会被提升为事实；
  5. **并发**：两个 Agent 同时写同一实体，是否产生丢更新；
  6. **成本**：P95 延迟、每次检索 token、人工纠正次数。

---

## 4. EigenFlux 上已经有人踩过的坑

以下都是公开广播（只列主题与链接，不记录作者/私信）：

| 主题 | 广播 | 对本设计的启示 |
|---|---|---|
| 17 个开源记忆项目的五维取舍（存储、时间、写决策、检索、治理） | [链接](https://www.eigenflux.ai/dashboard/broadcasts/346122483306332160) | 先做选型矩阵，不要从零写；五维可直接当评估表 |
| Hindsight / Mem0 / Graphiti / Letta / Cognee 的 retention / retrieval / reasoning 对比 | [链接](https://www.eigenflux.ai/dashboard/broadcasts/367975976019165184) | 分层不是按“存储”分，而应按“保留/检索/推理”职责分 |
| memory provenance laundering：低信任外部观察被静默提升为事实 | [链接](https://www.eigenflux.ai/dashboard/broadcasts/356289574164496384) | 写路径必须有 trust/taint 与来源审计，不能只存 embedding |
| 用同步回执而不是本地时钟做记忆时间基线 | [链接](https://www.eigenflux.ai/dashboard/broadcasts/370022538165616640) | 多 Agent 共享记忆要先解决“谁先谁后”的因果顺序 |
| 多 Agent 的身份/配置漂移 + 共享状态并发写 | [链接](https://www.eigenflux.ai/dashboard/broadcasts/359999804404662272) | namespace、epoch、receipt、冲突检测是硬需求 |
| DSH 跨会话记忆插件 `dsh-mneme`（SQLite/Markdown、MIT） | [链接](https://www.eigenflux.ai/dashboard/broadcasts/346444836586389504) | DSH 生态已有轻量实现，先评估复用 |
| Hivemind：执行轨迹 → 可复用技能 | [链接](https://www.eigenflux.ai/dashboard/broadcasts/324585133497647104) | Procedural Memory 可从 trace 自动沉淀，不必手写 |
| PLACE：生命周期状态 + 查询时资格治理 | [链接](https://www.eigenflux.ai/dashboard/broadcasts/370786317249806336) | “记忆是否可用”是治理问题，不只是检索问题 |

**EigenFlux 的结论**：这个网络里已经有不少记忆系统实践者，讨论集中在**来源可信、并发一致性、生命周期治理、评测**，而不是“再做一个向量库”。设计稿如果只增加一层 Qdrant + 自建网关，会和这些实践脱节。

---

## 5. 设计稿的 7 个缺口

1. **四个存储 = 四个事实源**：Obsidian、mem0、Qdrant、DSH 原生记忆都可能回答同一问题；没有定义“唯一写路径”和“谁是 canonical”。
2. **没有来源/污染模型**：`confidence: high/medium/low` 不够；需要 trust level、taint、provenance chain、审计日志。
3. **没有并发/因果顺序**：多 Agent 同时写同一实体时，缺 epoch、receipt、冲突检测；EigenFlux 上已有人踩过。
4. **没有生命周期算法**：TTL 只是删除；缺巩固（consolidation）、遗忘（forgetting）、反思（reflection）、版本迁移。
5. **没有评测方案**：指标有目标值，但没有基准、场景测试和 A/B；无法证明“降低 30% token”或“污染 <2%”。
6. **运维复杂度被低估**：Qdrant + mem0 + Obsidian + 4 个 Agent 的解析器 + MCP 网关 + Git 自动提交；Windows/WSL 下服务编排和权限会先耗尽精力。
7. **许可证/隐私未决策**：mem0 云、basic-memory AGPL、TencentDB/Memori 的 Other License；以及“原始会话是否离开本机”。

---

## 6. 建议架构：复用 80%，只写 20%

### 6.1 推荐组合（按优先级）

**方案 A（首选，最少自建）**

```text
DSH / Hermes / ... 
      │ MCP
      ▼
薄 Memory Gateway（只做路由/权限/来源/冲突，不存数据）
      ├── Canonical: Obsidian Vault（人类可读、Git）
      ├── Episodic + Semantic + Skills: MemOS 本地插件（SQLite + FTS5 + 向量）
      └── 可选: Mem0 OSS（只放稳定偏好/事实）
```

- **MemOS 本地插件**已支持 DSH（Windows PowerShell 安装）、100% 本地、SQLite、混合检索、去重、L1/L2/L3、多 Agent 协作、Memory Viewer。先用它跑 MVP，不要先写 Qdrant 管线。
- **Obsidian** 保留为 canonical；Agent 只写 `00-inbox/<agent>/`，Curator 提升到 `10-projects/`、`20-decisions/`、`50-skills/`。
- **Mem0 OSS** 只在 MemOS 的语义抽取不满足时补充；不要同时让 Mem0 和 MemOS 都做“事实抽取”，否则又会多一个事实源。
- **薄 Gateway** 只暴露 `memory_search` / `memory_write` / `memory_promote` / `memory_deprecate` / `memory_forget`，内部转调 MemOS/Obsidian/Mem0；不实现存储、不实现 embedding。

**方案 B（如果 MemOS 不满足）**

```text
Obsidian / basic-memory（canonical）
+ Mem0 OSS（semantic）
+ deja-vu 或 Graphiti（episodic / temporal）
+ 薄 MCP Gateway
```

- 轻量：deja-vu（本地会话索引，MCP）。
- 需要实体/时间关系：Graphiti（Neo4j/FalkorDB）。
- 需要图谱抽取管线：Cognee。
- 不要同时上 Qdrant + Graphiti + Mem0：三个都在存“事实/关系”，会重复。

**方案 C（如果目标是多模态/屏幕记忆）**

- MIRIX：六类记忆 + 多 Agent + 本地 Postgres；适合屏幕/多模态，不是纯文本记忆的最轻选择。

**方案 D（如果目标是团队级共享 Hub）**

- TencentDB Agent Memory：Chat Memory / Skill / LLM-Wiki / Code-Graph 四类资产；但 License 为 Other，且 Team Memory 仍是 Beta，先做合规评估。

### 6.2 只写这四样

1. **Memory Contract**：统一 schema（id、type、source、agent、project、confidence、trust、status、version、hash、created_at、updated_at、provenance）。
2. **Policy / Router**：namespace、读写权限、跨 Agent 只读、canonical 仅 Curator、冲突策略、撤销传播。
3. **Curator Workflow**：inbox → 人工/Curator 审核 → canonical；Git 提交；过期/废弃。
4. **Evaluation Harness**：LoCoMo/LongMemEval + 自己的交接/冲突/撤销/并发场景。

### 6.3 明确不要写

- 不要写新的 embedding / 向量数据库 / 图数据库；
- 不要写新的抽取、去重、冲突合并算法；
- 不要写新的六类记忆分类（MIRIX 已有）；
- 不要写新的记忆 OS / 调度器（MemOS 已有）；
- 不要写新的 MCP 协议（MCP 已是事实标准）。

---

## 7. 两周 MVP（建议先验证，再决定是否自建）

| 阶段 | 做什么 | 验收 |
|---|---|---|
| Day 1–2 | 写 Memory Contract + 威胁模型；选 3 个场景（交接/冲突/撤销）；确定评测指标 | schema 评审通过；场景可复现 |
| Day 3–5 | 在 DSH **测试 profile** 安装 MemOS 本地插件；导入最近 2 周会话；保留 Obsidian Vault | 检索可用；P95、token、召回有基线 |
| Day 6–8 | Obsidian + basic-memory/MCP（或自带 Markdown MCP）；inbox/canonical；provenance 字段 | Agent 只能写 inbox；canonical 有来源/版本 |
| Day 9–10 | Mem0 OSS（仅当 MemOS 语义层不足）；namespace 与跨 Agent 只读 | 不产生第二个事实源 |
| Day 11–12 | 薄 Gateway（MCP）：search/write/promote/deprecate/forget；权限与冲突 | 四个证据点可追溯 |
| Day 13–14 | 跑 LoCoMo/LongMemEval 子集 + 自己的场景；A/B：MemOS vs 自建 | 有数据再决定是否继续自建 |

**先不要做**：全量导入几百 MB 历史会话、其余 Agent 全接入、Qdrant 自建集群、复杂图谱 UI。先把 DSH + Hermes 两个 Agent 跑通。

---

## 8. 关键决策（需要人类拍板）

1. **本地优先还是允许云**：MemOS 本地 / Mem0 OSS / Hindsight 本地 vs 云服务；原始会话是否允许离开本机？
2. **主记忆 OS 选谁**：MemOS（DSH 支持最好）vs MIRIX（六类/多模态）vs Letta（Agent 平台）？
3. **Episodic 存储**：MemOS SQLite vs deja-vu vs Graphiti？建议先用 MemOS/deja-vu，不要先上 Qdrant。
4. **Canonical 格式**：Obsidian Vault + Git 是否必须？如果是，basic-memory 只做 MCP 适配，不替代 Vault。
5. **许可证**：basic-memory（AGPL）、TencentDB/Memori（Other）是否能接受？不能就排除。
6. **范围**：先 DSH + Hermes，还是一次性接四个 Agent？建议前者。

---

## 9. 最终建议

> **不要把“四层 + 一路由”当成新发明。** 它和 MIRIX 的六类、MemOS 的 Memory OS、TencentDB 的四类资产、Letta 的分层记忆高度重叠。你真正要建的是：

1. **一个人类可读、可 Git 的 canonical 层**（Obsidian）；
2. **一个薄的路由/权限/来源治理层**（MCP Gateway，不存数据）；
3. **一套可验证的交接证据**（输入版本、交付物、执行回执、检查结果）；
4. **一套自己的多 Agent 评测场景**。

其余全部复用：MemOS 做本地记忆 OS，Mem0 做语义事实，Graphiti/Cognee 做图谱（按需），basic-memory 做 Markdown/MCP（注意 AGPL），Hindsight 做反馈/遗忘（按需）。

**下一步**：先在 DSH 测试 profile 里试装 MemOS 本地插件，用两周做 A/B；如果它已经覆盖 80%，就把精力放在 Obsidian canonical + 薄 Gateway + 评测上，而不是重写一套 Qdrant/mem0/网关。

---

## 10. 参考资料

### 论文 / 综述

- [Memory for Autonomous LLM Agents（arXiv:2603.07670）](https://arxiv.org/abs/2603.07670)
- [Memory in the Age of AI Agents（arXiv:2512.13564）](https://arxiv.org/abs/2512.13564)
- [MemGPT（arXiv:2310.08560）](https://arxiv.org/abs/2310.08560)
- [Mem0（arXiv:2504.19413）](https://arxiv.org/abs/2504.19413)
- [Zep（arXiv:2501.13956）](https://arxiv.org/abs/2501.13956)
- [MemOS（arXiv:2507.03724）](https://arxiv.org/abs/2507.03724)
- [MIRIX（arXiv:2507.07957）](https://arxiv.org/abs/2507.07957)
- [MemoryOS（arXiv:2506.06326）](https://arxiv.org/abs/2506.06326)
- [A-MEM（arXiv:2502.12110）](https://arxiv.org/abs/2502.12110)
- [BMAM（ACL 2026 Findings）](https://aclanthology.org/2026.findings-acl.1973/)
- [MemoryBench（arXiv:2510.17281）](https://arxiv.org/abs/2510.17281)
- [Hindsight 论文（arXiv:2512.12818）](https://arxiv.org/abs/2512.12818)

### 项目

- [Mem0](https://github.com/mem0ai/mem0) ｜ [Hindsight](https://github.com/vectorize-io/hindsight) ｜ [Letta](https://github.com/letta-ai/letta)
- [Graphiti](https://github.com/getzep/graphiti) ｜ [Cognee](https://github.com/topoteretes/cognee)
- [MemOS](https://github.com/MemTensor/MemOS) ｜ [MIRIX](https://github.com/Mirix-AI/MIRIX)
- [TencentDB Agent Memory](https://github.com/TencentCloud/TencentDB-Agent-Memory) ｜ [Memori](https://github.com/MemoriLabs/Memori)
- [basic-memory](https://github.com/basicmachines-co/basic-memory) ｜ [LangMem](https://github.com/langchain-ai/langmem) ｜ [LangGraph](https://github.com/langchain-ai/langgraph)

### EigenFlux 公开广播

- [17 个开源记忆项目的五维取舍](https://www.eigenflux.ai/dashboard/broadcasts/346122483306332160)
- [Hindsight / Mem0 / Graphiti / Letta / Cognee 对比](https://www.eigenflux.ai/dashboard/broadcasts/367975976019165184)
- [memory provenance laundering](https://www.eigenflux.ai/dashboard/broadcasts/356289574164496384)
- [同步回执作为时间基线](https://www.eigenflux.ai/dashboard/broadcasts/370022538165616640)
- [多 Agent 身份/配置漂移与并发共享状态](https://www.eigenflux.ai/dashboard/broadcasts/359999804404662272)
- [dsh-mneme：DSH 跨会话记忆插件](https://www.eigenflux.ai/dashboard/broadcasts/346444836586389504)

> **调研限制**：未做 hands-on 基准；Star/License 为 2026-10-21 的 GitHub API 数据；论文与厂商数字未独立复现；EigenFlux 只读取公开广播，未使用任何私信或本地权限。选型前请用你自己的数据和场景复测。
