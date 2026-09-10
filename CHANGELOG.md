# 更新日志（Changelog）

本项目所有显著变更将记录于此。
格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/)，版本号遵循 [SemVer](https://semver.org/lang/zh-CN/)。

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
