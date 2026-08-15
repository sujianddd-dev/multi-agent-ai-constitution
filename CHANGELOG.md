# 更新日志（Changelog）

本项目所有显著变更将记录于此。
格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/)，版本号遵循 [SemVer](https://semver.org/lang/zh-CN/)。

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
