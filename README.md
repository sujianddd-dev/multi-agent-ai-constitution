# 多 Agent AI 宪法（ai-constitution.skill）

> 让多个 AI 编码代理与人类在**同一套规则**下协作的共享知识库模板。
> 一个 README 当"宪法"，所有 Agent 读同一份"剧本"，无需互相通信 —— 随意在 Claude Code、Codex、zcode、Kimi Work 与不同模型之间切换，进度依然稳定。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

---

## 这是什么

一个**可复用的 skill 模板**：复制进任意项目后，项目立即拥有一套完整的"AI 宪法"——

- `AGENTS.md` —— 社区开放标准入口（Copilot、Codex 等工具自动发现）
- `README.md` —— 宪法总纲 + **治理结构**（角色定义 + 审批权矩阵）+ 任务列表
- `.github/CONTEXT.md` —— 项目上下文：目标 / 阶段 / Agent 分工 / 技术栈 / **红线**
- `ARCHITECTURE.md` —— 架构规范与变更审批流程
- `AGENT_GUIDELINES.md` —— Agent 工作流程 / 命名约定 / 禁止操作
- `API_CONTRACT.md` —— 接口契约（**任何 Agent 不可擅改**）
- `CODING_STANDARDS.md` —— 代码与提交规范
- `DECISION_LOG.md` —— 决策历史（只追加不删除）

## 快速开始

```bash
# 1. 复制模板到你的项目
cp -r ai-constitution.skill/templates/* <你的项目>/
mv <你的项目>/CONTEXT.md <你的项目>/.github/CONTEXT.md

# 2. 填写占位符（XXX 系统、YYY 特性、Agent 分工、技术栈……）
# 3. 在 DECISION_LOG.md 追加"项目入册"与"主 Agent 任命"两条决策
# 4. 提交并推送 GitHub
git init && git add -A && git commit -m "docs: 建立 AI 宪法（共享知识库）"
```

之后任何 Agent 克隆仓库、读到 `AGENTS.md`，即自动进入"先读宪法 → 动手 → 提 PR → 等待审批"的协作循环。

## 设计思想

- **文档作为协调中枢**：所有 Agent 单向读取，无需互相通信 → 低协调成本、高一致性
- **Truth Source 唯一**：状态与规则只在文档里
- **渐进式披露**：入口短小（AGENTS.md 30 秒），细节分层
- **模型 / 工具无关**：纯自然语言 Markdown，无任何工具私有语法
- **红线显式化**：审批权矩阵、禁止事项写死在文档里

## 参考

- [AGENTS.md 开放标准](https://agents.md/)（[agentsmd/agents.md](https://github.com/agentsmd/agents.md)）
- [How to write a great agents.md（GitHub 官方博客，2500+ 仓库经验）](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)
- [chrisbergeron/AI-Constitution](https://github.com/chrisbergeron/AI-Constitution)
- [seanrugg/ai_constitution](https://github.com/seanrugg/ai_constitution)
- 思想源头：Sider ChatShare《共享知识库：Agent 与人类协作的核心基础》(2026-08-14)

## 许可证

[MIT](./LICENSE) © 2026 sujianddd-dev —— 自由使用、修改、分发，保留版权声明即可。
