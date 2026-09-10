# 多 Agent AI 宪法（ai-constitution.skill）

> 让多个 AI 编码代理与人类在**同一套规则**下协作的共享知识库模板。
> 一个 README 当"宪法"，所有 Agent 读同一份"剧本"，无需互相通信 —— 随意在 Claude Code、Codex、zcode、Kimi Work 与不同模型之间切换，进度依然稳定。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

---

## 这是什么

一个**可复用的 skill 模板**：复制进任意项目后，项目立即拥有一套完整的"AI 宪法"——

**协议与规则层**

- `AGENTS.md` —— 社区开放标准入口（Copilot、Codex 等工具自动发现）
- `CLAUDE.md` —— Claude Code / DSH 的入口指针（3 行指向 `AGENTS.md`，不重复定义规则）
- `README.md` —— 宪法总纲 + **治理结构**（角色定义 + 审批权矩阵）+ 任务列表
- `.github/CONTEXT.md` —— 项目上下文：目标 / 阶段 / Agent 分工 / 技术栈 / **红线**
- `ARCHITECTURE.md` —— 架构规范与变更审批流程
- `AGENT_GUIDELINES.md` —— Agent 工作流程 / 命名约定 / 禁止操作
- `API_CONTRACT.md` —— 接口契约（**任何 Agent 不可擅改**）
- `CODING_STANDARDS.md` —— 代码与提交规范
- `DECISION_LOG.md` —— 决策历史（只追加不删除）

**交接层（切 Agent / 切模型不丢进度）**

- `STATE.md` —— **接力棒**：当前任务 / 进度光标 / 下一步 / 阻塞 / 已知坑 / 验收结果（≤50 行，每轮收尾必更）
- `.github/PULL_REQUEST_TEMPLATE.md` —— **交接单**：PR 的"交接五问" + 提交前自检

> 为什么需要交接层：静态宪法回答"这是什么"，回答不了"**现在到哪了**"——而后者才是换 Agent 时真正会丢的东西。

## 快速开始

```bash
# 1. 复制模板到你的项目（注意：* 不含点目录，.github/ 要单独复制）
mkdir -p <你的项目>/.github
cp -r ai-constitution.skill/templates/* <你的项目>/
cp -r ai-constitution.skill/templates/.github/. <你的项目>/.github/   # PR 交接单
mv <你的项目>/CONTEXT.md <你的项目>/.github/CONTEXT.md                # CONTEXT 归位到 .github/

# 2. 填写占位符（XXX 系统、YYY 特性、Agent 分工、技术栈、验收命令……）
# 3. 初始化 STATE.md（接力棒：当前任务 / 下一步 / 验收结果，填真实值）
# 4. 在 DECISION_LOG.md 追加"项目入册"与"主 Agent 任命"两条决策
# 5. 提交并推送 GitHub
git init && git add -A && git commit -m "docs: 建立 AI 宪法（共享知识库）"
```

之后任何 Agent 克隆仓库、读到 `AGENTS.md`，即自动进入"先读宪法 → **读 STATE 接手进度** → 动手 → 提 PR（交接五问）→ 等待审批"的协作循环。

> **想让规则在所有项目里自动生效？** 把协作铁律（3～5 行）放进各工具的**全局**指令文件（`~/.dsh/AGENTS.md`、`~/.codex/AGENTS.md`、`~/.claude/CLAUDE.md`）——做法与验证清单见 [docs/ENTRY-POINTS.md](./docs/ENTRY-POINTS.md)。

## ⚠️ 使用前必读：按你的生产环境定制

> **这是一份通用模板，不是开箱即用的成品。** 每个人的生产环境都不同——Agent 阵容、模型、技术栈、目录结构、命令、团队规模各不相同，**直接照搬会"水土不服"**。请先完成下面的定制清单，再投入使用。

| # | 定制项 | 模板默认 | 你需要改成 |
|---|---|---|---|
| 1 | Agent 分工表（CONTEXT.md） | Agent A/B/C 占位 | 你的实际工具链与模型（如 zcode / Codex / Claude Code / Kimi Work）及各自职责 |
| 2 | 技术栈（CONTEXT.md） | Python 3.11 + FastAPI + PostgreSQL + Docker | 你的真实语言、框架、数据库 |
| 3 | 常用命令（AGENTS.md Dev Tips） | `pytest` 占位 | 你的实际测试/检查/构建命令 |
| 4 | **验收命令**（STATE.md「✅ 验收」） | `pytest` 占位 | **一条命令跑完、与模型/工具无关**的那条（换模型后的唯一锚点） |
| 5 | **接力棒**（STATE.md） | 模板占位 | 当前任务 / 下一步 / 最近一次验收结果——填真实值，别留占位符 |
| 6 | **入口与全局协议**（CLAUDE.md、各工具全局文件） | 指向 AGENTS.md | 你的实际工具链；全局铁律放进 `~/.dsh/AGENTS.md` 等（见 docs/ENTRY-POINTS.md） |
| 7 | 目录结构（ARCHITECTURE.md） | `modules/{backend,frontend,tests}` | 你的项目形态（浏览器插件？桌面 exe？微服务？） |
| 8 | API 契约（API_CONTRACT.md） | 用户模块示例 | **首次实施前必须与真实实现对齐**（文件内"模板状态声明"） |
| 9 | 治理结构（README 模板） | 审批权矩阵通用版 | 任命你的主 Agent；按团队规模增删权限 |
| 10 | 阶段与任务 | Phase 1 占位 | 你的实际进度、任务与负责人 |
| 11 | 隐私与合规红线 | 通用表述 | 按你的数据合规要求增删（哪些数据不碰、哪些必须加密） |

**适配技巧（渐进式披露）：**

- 上下文窗口较小的 Agent，只需读 `AGENTS.md`（30 秒）+ `CONTEXT.md`（5 分钟）即可开工，不必一次读完 7 份
- 语言/框架特定规则建议**拆分到独立文件**（如 `RULES_PYTHON.md`），保持各文件短小
- 文档数量可按需精简：小团队保留 AGENTS / README / CONTEXT / DECISION_LOG 四件套也完全够用

## 设计思想

- **文档作为协调中枢**：所有 Agent 单向读取，无需互相通信 → 低协调成本、高一致性
- **Truth Source 唯一**：状态与规则只在文档里（本地记忆只能当加速器，不得当交接依据）
- **接力棒优先**：接手先读 `STATE.md`，每轮收尾必更新——**不更新=本轮未完成**
- **验收锚点**：一条与模型/工具无关的验收命令，换模型后质量不漂
- **渐进式披露**：入口短小（AGENTS.md 30 秒），细节分层
- **模型 / 工具无关**：纯自然语言 Markdown，无任何工具私有语法
- **红线显式化**：审批权矩阵、禁止事项写死在文档里

> 📖 完整的设计依据、两种解法对比（单向读取 vs 互相通信）、边界与代价：**[docs/WHY.md](./docs/WHY.md)**
> 🚪 各 Agent 工具的入口约定与全局协议层配置：**[docs/ENTRY-POINTS.md](./docs/ENTRY-POINTS.md)**

## 参考

- [AGENTS.md 开放标准](https://agents.md/)（[agentsmd/agents.md](https://github.com/agentsmd/agents.md)）
- [How to write a great agents.md（GitHub 官方博客，2500+ 仓库经验）](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)
- [chrisbergeron/AI-Constitution](https://github.com/chrisbergeron/AI-Constitution)
- [seanrugg/ai_constitution](https://github.com/seanrugg/ai_constitution)
- 思想源头：Sider ChatShare《共享知识库：Agent 与人类协作的核心基础》(2026-08-14)

## 许可证

[MIT](./LICENSE) © 2026 sujianddd-dev —— 自由使用、修改、分发，保留版权声明即可。
