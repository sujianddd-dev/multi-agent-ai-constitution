# 更新日志（Changelog）

本项目所有显著变更将记录于此。
格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/)，版本号遵循 [SemVer](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### 新增

- `docs/NETWORK-FEEDBACK.md` —— EigenFlux 广播与社区反馈记录；明确「仅交流、不开放本地权限」的边界，心跳按 DeepSeek 官方空闲时段运行。
- 2026-10-22 网络观察（匿名）：交接验证、fail-closed 边界、四证据点；见 `docs/NETWORK-FEEDBACK.md`。
- `docs/MEMORY-SYSTEMS-RESEARCH.md` —— 多智能体记忆系统调研：GitHub 主流方案、论文/基准、EigenFlux 实践信号与复用建议。
- `docs/MEMORY-DESIGN-V2.md` —— 基于 Hy-Memory/MemHub 的 v0.2 重构建议：共享 Runtime + Obsidian canonical + 四证据点；Windows 原生回退 MemOS。
- v0.2.1：根据 10+ 条 EigenFlux `demand` 与 Hy-Memory open issues 补 Integrity/Authority：`processed/read_receipt`、authority vs confidence、`proposed→active`、单写者、固化 fenced write、淘汰级联清 derived。
- v0.2.2：首批回复修正——摘要 `generator/rule/model_version`、`execution_path`（primary/degraded/skipped）、`landed_receipt`（消费侧读回签名）、per-agent/scope `authority_epoch`、pre-ping + 幂等重跑。
- v0.2.3：读时版本戳——`read_version` / `read_intent` / `base_version`；写回不匹配即 `STALE_READ` 拒写；与 why-recall 共用 intent fingerprint。
- v0.2.4：B 段验收字段——`retrieval_backend` / `fallback_reason` 显式进 receipt；`NOT_COMPARABLE` 只能由 comparator 产出（`cmp_source` + `cmp_receipt`）。
- 记忆系统现状审计：`docs/MEMORY-AUDIT.md` + 候选账本 `docs/MEMORY-LEDGER.md` / `docs/memory-ledger.jsonl`；确认 desktop 无已接入 Runtime（mem0 休眠、dsh-memory-evolve 未安装；Obsidian 后续已装）。
- 隔离 profile 试装：`@jacklika/dsh-memory@0.1.7-rc.40` 通过 `wiki_write/search/read` smoke；MemOS 本地插件 2.0.20 与 DSH 0.2.1 peer 不兼容；desktop 由 Electron 独占，未硬改。
- **desktop 已激活**：通过 DSH 插件页安装 `@jacklika/dsh-memory@0.1.7-rc.40`；vaultRoot 指向 Obsidian vault；`wiki_write/search/read` PASS，git true；`inbox` 从记忆索引排除，源文件保留。
- 记忆清理：README/审计移入 `_meta` 并排除；记忆索引 1 条；0 重复/0 空/0 测试；源导入保留并提交 local git；`tool-memory-vector` 保持禁用。
- Obsidian 1.14.4 已安装，`~/.dsh/memory-vault` 已创建并打开（README/agents/shared）；已作为 memory bundle 的实际写入目标。
- Desktop `.md` 自动导入：11 个现有文件复制到 `inbox/desktop-import/`，带 `INDEX.md` 与 sidecar hash；`ObsidianDesktopImport` 登录时 + 每 10 分钟运行，copy-only。
- 心跳恢复（官方兜底，00/02/04/06/08/12 谷段）；`EigenFluxDSHWatcher` 用 **VBS 隐藏启动**（无控制台窗口），常驻 `eigenflux stream` 即时 headless 处理（已回复则跳过），心跳兜底，避免重复。
- 调研补充：Hy-Memory/MemHub（腾讯混元）专项评估；Windows 不支持、preview、DSH Profile MCP 接入与默认授权收敛。
- `templates/.github/PULL_REQUEST_TEMPLATE.md` —— 新增「交接证据（四证据点）」：输入来源/版本、交付物路径、执行回执、检查结果；缺任一项标 `pending-review`。

## [0.3.1] - 2026-10-17

### 修复（Fixed）

- `SKILL.md` 的模板复制路径改为**独立安装布局**（`$SKILL_DIR/templates/.`），不再依赖仓库里的 `ai-constitution.skill/`；补"独立目录分发"说明，避免用户装完 skill 后照文档复制失败。

### 新增（Added）

- `scripts/package-skill.py` —— 生成独立 skill zip（`SKILL.md` 在根 + `templates/` + LICENSE/README），供 Agensi 或手动分发；内置 frontmatter/路径/50 MB 检查。
- `docs/AGENSI-LISTING.md` —— 免费上架文案（$0、MIT、无付费版）。
- `.gitignore` —— `dist/` 等构建产物不入库。

[0.3.1]: https://github.com/sujianddd-dev/multi-agent-ai-constitution/compare/v0.3.0...v0.3.1

## [0.3.0] - 2026-10-17

### 新增（Added）

- **一行安装** `install.sh` / `install.ps1` —— 自动检测 DSH / Claude Code / Codex / Cursor 的 skills 目录并安装；`--project` 可直接把模板铺进现有项目（默认不覆盖已有文件）；重复安装会先把旧版本备份为 `*.bak-<时间>`。
- **`.gitattributes`** —— 强制 `*.sh` 使用 LF，修掉 Windows 检出后在 WSL/Linux 下 `bash scripts/verify.sh` 因 CRLF 报 `set: pipefail` 的问题；验收脚本同时容忍 SKILL.md 的 CRLF frontmatter。
- **工程信条** `docs/DOCTRINE.md` —— 把散落的工程判断固化为**可执行总则**（不是口号，每条都有落地落点与反模式）：
  - 总纲：软件 = **协议优先的微服务 + 灵活聚合的表现层**（解耦 = 控制上下文；聚合 = 用好 token 的灵活性）
  - §1 不回到**重型前置规划**（计划只做到下一个可验证增量）
  - §2 MVP + **灰度数据闭环**：指标 / 分层采样 / 归因 / **关门阈值** 四要素
  - §3 迭代内部严谨四硬面：契约-**IO 事务** · 测试-**TDD** · 可观测-**ADR** · 回滚-**git**
  - §4 **协议优先** + **聚合展现**
  - §5 风险管理：承认 **vibecoding 隐蔽负债**（六种形态）+ **分级响应 playbook**（P0/P1/P2）
  - 附「落地映射表」（信条 → 模板文件）与「反模式速查」
- **风险响应模板** `templates/RISK_PLAYBOOK.md` —— 可填写的护栏：分级触发条件 / 处置动作 / 复盘防复发 / 故障速查表 / 护栏巡检 / 复盘记录
- **本仓库自用交接层**（此前只把交接层做成模板发给别人，自己没用——"医者不自医"）：
  - `AGENTS.md` —— 本仓库入口：30 秒速览 / 必读顺序 / **验收命令** / 硬红线
  - `CLAUDE.md` —— 入口指针（指向 `AGENTS.md`，不重复定义规则）
  - `STATE.md` —— 本仓库的**接力棒**
  - `.github/PULL_REQUEST_TEMPLATE.md` —— 本仓库的**交接单**
  - `scripts/verify.sh` + `scripts/check-links.mjs` —— 本仓库的**验收锚点**（模板齐全 / SKILL frontmatter / 必读顺序一致 / 相对链接 0 broken / 无个体项目名）

### 变更（Changed）

- `templates/ARCHITECTURE.md`：新增「🧩 协议优先（架构第一原则）」「🪄 聚合展现（表现层纪律）」；架构红线补 2 条（业务规则不入表现层、不得绕过协议直连他人存储）
- `templates/AGENT_GUIDELINES.md`：工作流程补「先读 STATE」「增量优先」「收尾更新 STATE」；新增「🚦 灰度前置」「↩️ 回滚」「🆘 风险分级响应」三节；禁止操作补 2 条
- `templates/API_CONTRACT.md`：新增「🔁 IO 事务与幂等」（事务边界 / 幂等 / 半失败 / 错误语义）
- `templates/CODING_STANDARDS.md`：新增「TDD 节奏」；提交规范补「提交粒度与回滚」
- `templates/DECISION_LOG.md`：明示本文件即 **ADR 载体**；记录格式补「被否决的方案」字段
- `templates/STATE.md`：「🎯 当前任务」补「灰度」一行（指标 / 关门阈值 / 当前放量级）
- `templates/.github/PULL_REQUEST_TEMPLATE.md`：第 3 节补「灰度四要素」与「回滚方式」
- `templates/README.md`：文档索引补 `RISK_PLAYBOOK.md`；新增「🧭 工程信条（How We Build）」
- `README.md`：新增「🧭 工程信条」章节与 `docs/DOCTRINE.md` 指引；模板清单与定制清单同步补项

### 说明（Notes）

- **向后兼容**：0.2.0 的既有章节语义**未被改写**，本次全部为**增量补充**——已采用旧模板的项目无需改动即可继续使用
- `docs/DOCTRINE.md` 是**总则**（不随项目变）；`templates/` 内是其**可填写条款**——两者分工明确，避免把方法论与项目规则混在一起
- 本仓库自此**自用**自己的交接层与验收锚点：`bash scripts/verify.sh` 是唯一验收命令

[0.3.0]: https://github.com/sujianddd-dev/multi-agent-ai-constitution/compare/v0.2.0...v0.3.0

## [0.2.0] - 2026-09-11

### 新增（Added）

- **交接层**（解决"切 Agent / 切模型丢进度"）：
  - `templates/STATE.md` —— **接力棒**：当前任务 / 进度光标 / 下一步 / 阻塞 / 已知坑 / 验收结果，≤50 行，铁律"每轮收尾必更新，不更新=本轮未完成"，附接手自检清单
  - `templates/.github/PULL_REQUEST_TEMPLATE.md` —— **交接单**：PR"交接五问"（依据 / 改了什么 / 怎么验证 / 遗留什么 / 下一步给谁）+ 提交前自检
- `templates/CLAUDE.md` —— Claude Code / DSH 的入口指针（3 行指向 `AGENTS.md`，避免规则重复定义）
- `docs/WHY.md` —— 设计依据与起源记录（2026-08-14）：两种解法对比表、异构模型为何适用、**边界与代价**（文档滞后 / 不读就动手 / 进度靠自觉 / 本地记忆冒充事实源）
- `docs/ENTRY-POINTS.md` —— 各 Agent 工具的入口约定（Codex / DSH / Claude Code / Copilot / 其他）、L0 全局协议层建议内容、配置后的验证清单

### 变更（Changed）

- `templates/README.md`：必读顺序新增 `STATE.md`（接手第一读）；文档索引与维护权限同步；新增「🔁 交接与验收」章节（接力棒、交接单、验收锚点）
- `templates/AGENTS.md`：必读顺序补 `STATE.md`；Dev Tips 明确"验收命令"；PR 要求改为按 PR 模板的交接五问填写
- `SKILL.md`：快速开始补 `STATE.md` 初始化与 `.github/` 安装位置；核心原则新增"接力棒优先""验收锚点"；模板清单由 8 项扩为 11 项（含安装位置）
- `README.md`：模板清单分「协议与规则层 / 交接层」；定制清单由 8 项扩为 11 项（新增验收命令、接力棒、入口与全局协议）

### 说明（Notes）

- 本版本不破坏 0.1.0 的既有文件：新增文件为可选层，最小用法仍是 AGENTS / README / CONTEXT / DECISION_LOG 四件套
- `docs/` 面向"使用本仓库的人"，`templates/` 面向"被复制进项目的文件"——模板保持自包含，不引用本仓库路径

[0.2.0]: https://github.com/sujianddd-dev/multi-agent-ai-constitution/compare/v0.1.0...v0.2.0

## [0.1.0] - 2026-08-15

### 新增（Added）

- 首次发布：多 Agent AI 宪法 skill（`ai-constitution.skill`）
- `SKILL.md` 标准入口（含 name/description frontmatter，可被各 Agent 工具加载）
- 8 个通用模板：
  - `AGENTS.md` —— 社区开放标准入口（Copilot/Codex 等自动发现）
  - `README.md` —— 宪法总纲 + 治理结构 + 审批权矩阵
  - `CONTEXT.md` —— 项目上下文与红线（安装至 `.github/`）
  - `ARCHITECTURE.md` —— 架构规范与变更审批流程
  - `AGENT_GUIDELINES.md` —— Agent 工作流程与行为准则
  - `API_CONTRACT.md` —— 接口契约（含"模板状态声明"）
  - `CODING_STANDARDS.md` —— 代码与提交规范
  - `DECISION_LOG.md` —— 决策日志（只追加不删除）
- 治理结构：角色定义（人类 / 主 Agent / 普通 Agent）+ 审批权矩阵
- 跨模型 / 工具可移植性约定：纯自然语言 Markdown、渐进式披露、Truth Source 唯一
- 生产环境定制清单（8 项必改项 + 适配技巧）
- MIT 许可证

[0.1.0]: https://github.com/sujianddd-dev/multi-agent-ai-constitution/releases/tag/v0.1.0
