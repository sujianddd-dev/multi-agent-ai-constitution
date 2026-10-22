# 记忆系统现状审计（2026-10-22）

> **方法**：本机 profile / 配置 / 目录 / 进程 / 端口 / WSL 检查 + EigenFlux CLI 状态；未迁移、未删除任何数据。
> **结论**：当前项目**只有设计与文档，没有已接入的记忆 Runtime**；EigenFlux 通信链路是真实可用的，记忆完整性仍是待实现层。

## 1. 已核实的现状

| 组件 | 状态 | 证据 / 说明 |
|---|---|---|
| DSH | 0.2.1-rc.2，Windows | 当前会话运行正常 |
| DSH profile | **已接入 memory bundle** | desktop `package.json` / bundles 已含 `@jacklika/dsh-memory@0.1.7-rc.40`；`memory_runtime_info` 显示 component 已加载 |
| mem0 | **休眠** | 本机有 `config.json`，但 profile 没有 mem0 bridge / 依赖，未形成写路径 |
| dsh-memory-evolve | **未安装** | 有独立源码 checkout（v0.1.0），未加入 profile、未启用、未产生运行数据 |
| Obsidian / Markdown canonical | **已安装并接入** | Obsidian 1.14.4；vault `~/.dsh/memory-vault`；memory bundle 的 `vaultRoot` 指向它，`gitRepository=true`，`wiki_write/search/read` 已通过 |
| 共享记忆 Runtime | **desktop 已启用** | `@jacklika/dsh-memory` 在 desktop 运行；WSL 的 MemHub/MemOS 仍未安装，不作为生产依赖 |
| EigenFlux CLI | 0.6.8，可用 | 身份已验证；广播、私信、搜索可用 |
| EigenFlux 心跳 | 6 次/日（谷段） | `0 0,2,4,6,8,12 * * *` Asia/Shanghai |
| EigenFlux 实时 watcher | 运行中 | Windows 计划任务 `EigenFluxDSHWatcher`，VBS 隐藏启动；`stream` 单连接 |
| 项目记忆 | 文档 + 私信 | `STATE.md`、`NETWORK-FEEDBACK.md`、`MEMORY-DESIGN-V2.md`、EigenFlux 会话；人工维护 |

## 2. 设计 vs 实际

`docs/MEMORY-DESIGN-V2.md` 已到 v0.2.4，定义了共享 Runtime、Integrity/Authority、Obsidian canonical、四证据点。但：

- desktop 已接入 `@jacklika/dsh-memory`，vaultRoot 指向 Obsidian vault；`memory_runtime_info` 为 `safeToWrite=true`、`gitRepository=true`；
- 没有 `processed_receipt` / `landed_receipt` / `read_version` / `base_version` 的运行时；
- 没有 `proposed → active` 的实际状态机；
- 没有单写者/租约/读回校验；
- Obsidian 已接入写入，且 `inbox/`（Desktop 导入源）已从记忆搜索索引排除；
- 候选账本仍保留；已有 `wiki_write/search/read` 实测。

## 3. 关键风险

1. **多源不一致**：DSH 会话、mem0 配置、项目文档、EigenFlux 会话各自存在；没有唯一权威写路径。
2. **声称与事实脱节**：设计文档讨论过 Profile 级接入，但实际 profile 没有 memory 插件；不审计就迁移会重复建设。
3. **无完整性回执**：无法证明写入落库、读取生效、写回基于哪一版；存在静默覆盖风险。
4. **无权限/来源模型**：没有 `trust/taint`、`authority vs confidence` 的运行时；外部广播不能被自动提升为事实。
5. **MemHub 兼容性**：官方 v1.0.4 只发 Linux/macOS，Windows 无原生制品；WSL 当前 Stopped，不能当生产依赖。
6. **备份/评测缺失**：没有自动备份、没有基线指标；任何大规模导入都不可回滚。
7. **凭证边界**：本机 mem0 配置含凭据；未确认 egress 策略前不应扩大使用。

## 4. 已执行的最小动作

- 建立私有备份：`~/.eigenflux-dsh/backups/20261022-memory-audit/`（mem0 配置、DSH profile package/cordis、dsh-memory-evolve package/cordis；不复制到公开仓库）。
- 新增本审计与候选账本：`docs/MEMORY-AUDIT.md`、`docs/MEMORY-LEDGER.md`、`docs/memory-ledger.jsonl`。
- 在隔离测试 profile 中试装 `@jacklika/dsh-memory`（见 5.1）；**未改 desktop profile**，未迁移/删除现有数据。
- 安装 Obsidian 1.14.4，创建并打开 `~/.dsh/memory-vault`（README/agents/shared）；它目前只是 canonical 查看/编辑层，未接入自动写入。
- Desktop `.md` 导入：11 个现有文件复制到 `inbox/desktop-import/`，带 `INDEX.md` 与 sidecar hash；`ObsidianDesktopImport` 登录 + 每 10 分钟运行，copy-only。
- 已向 EigenFlux 上一条“静默失败征集”广播发出实质回复（processed != landed、STALE_READ 两个案例），并记录为候选记忆。

## 5. 运行时选择（当前时点）

| 方案 | 当前兼容性 | 结论 |
|---|---|---|
| MemHub / Hy-Memory | Linux/macOS；Windows 无原生；WSL 未启动 | 只能作为隔离 WSL 试点，不能直接生产 |
| MemOS 本地插件 | `@memtensor/memos-local-plugin@2.0.20` 的 peer 要求 DSH `<0.2.0`；当前 DSH 0.2.1-rc.2 | **不可直接装**；除非上游放宽 peer |
| `@jipika/dsh-memory` | 0.6.0 测试 profile 可加载，但无 `memory_search`，写入被 headless 沙箱拒绝 | 不作为主选；需更新版本/权限后再评估 |
| `@jacklika/dsh-memory` | 0.1.7-rc.40；peer 覆盖 DSH 0.2.x；测试 profile 通过 | **当前试点候选**；Obsidian 兼容 vault + 串行写 + git 历史 |
| mem0 | 本机有配置但无 bridge | 先不接；需确认 egress/凭据/权限 |
| dsh-memory-evolve | 独立源码、未安装 | 先审计其数据模型与兼容性，不直接上生产 |

### 5.1 试装结果（2026-10-22）

| 动作 | 结果 |
|---|---|
| 创建隔离 profile `memory-test2`，装 `@jacklika/dsh-memory@0.1.7-rc.40` | 成功；14 个包；`--dump-config` 显示 memory-scope / queue / git / filesystem / curator / graph / vector(disabled) |
| 在 `memory-test2` 跑写入+召回 smoke test | **PASS**：`wiki_write` → `wiki_search` → `wiki_read`；返回路径 `agents/<session>/notes/memory-smoke-test.md`；vault 内 git 自动提交 |
| 尝试 `dsh plugin --profile desktop add ...` | CLI **被拒绝**：`profile "desktop" is managed exclusively by the Electron application` |
| 改用 DSH 插件页「+ 添加插件」安装 `@jacklika/dsh-memory@0.1.7-rc.40` | **成功**；`memory_runtime_info` 显示 component 已加载；工具面出现 `wiki_*` / `memory_*` |
| 写入 + 召回验收 | **PASS**：`wiki_write` → `wiki_search` → `wiki_read`；`shared/notes/dsh-memory-activation.md`；vault git 已初始化并提交 |
| 清理 | 删除失败的 `memory-test` 与临时 vault；保留 `memory-test2` 试点 |

**边界**：desktop 已接入并完成一次写入/召回；`inbox/desktop-import` 保留为 Obsidian 源材料但从记忆搜索索引排除。完整性回执/单写者/`proposed→active` 仍未实现，不能把“有记忆”当成“记忆已可靠”。

**选择依据**：先满足 Windows 兼容、最小权限、可恢复、可测试；不以项目热度为依据。

### 5.2 Obsidian / Desktop 导入（2026-10-22）

- Obsidian **1.14.4** 已安装；vault `~/.dsh/memory-vault` 已打开，含 `agents/`、`shared/`、`inbox/`。
- Desktop 的 11 个 `.md` 已**复制**到 `inbox/desktop-import/`；原文件未移动、未修改；`INDEX.md` 记录来源、vault 路径、SHA256 前 12 位、字节数。
- 自动导入任务 `ObsidianDesktopImport`：登录时 + 每 10 分钟；VBS 隐藏启动；互斥锁防并发；按 sidecar hash 幂等；源文件变更时写带时间戳的新版本。
- 边界：Obsidian 现在是 **canonical 查看/编辑层 + 实际写入目标**；`inbox/desktop-import` 是源材料，已通过 `excludeDirs: [archive, inbox]` 从记忆搜索/图谱排除，但仍在 Obsidian 可读。

### 5.3 启用与清理（2026-10-22）

- `memory_runtime_info`：`vaultRoot=C:/Users/14040/.dsh/memory-vault`、`safeToWrite=true`、`gitRepository=true`。
- 实测：`wiki_write` → `wiki_search` → `wiki_read` **PASS**；新增 `shared/notes/dsh-memory-activation.md`，vault git 已提交。
- 清理边界：`inbox/desktop-import` 的 11 个源文档**不删除**，只从记忆索引/图谱排除；当前索引只有 README + activation 两条。
- `wiki_graph_audit`：`complete=true`、`excludedDirsApplied=[archive,inbox]`、`archiveNodesInIndex=0`。
- 已把“无用/来源类记忆”的审计交给子代理；审计只读、不删除源文件，报告仍在生成。

## 6. 开始交流的条件

- **已满足**：EigenFlux 身份、广播/私信/搜索、实时 stream、心跳、审计/备份、desktop 记忆写入/召回、Obsidian vault。
- **未满足**：`processed/landed/read_version` 回执、单写者/租约、`proposed→active` 状态机、跨会话评测。
- **当前策略**：记忆写入已可用，但只记录有复用价值的事实；不把导入源材料当 canonical；不宣称达到“可靠共享记忆”。

## 7. 下一步

1. 清理：审阅 `CLEANUP-AUDIT.md`，只归档明确的测试/重复记忆；源材料保留在 `inbox/`，不删除。
2. 若走 MemHub：仅在 WSL 隔离环境；不迁移生产数据。
3. 在任何 Runtime 接入前，先实现 `proposed → active` 与 `read_version/base_version` 规则。
4. 建立最小验收：跨会话召回、写入读回、并发冲突、权限、降级、删除残留、交接恢复。
5. 继续 EigenFlux 真实交流；每次只记录有复用价值的候选，不堆积。

> 本审计只陈述已核实事实；未测量的指标明确标注为“尚未测量”。
