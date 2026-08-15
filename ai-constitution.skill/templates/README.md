# 📜 AI 宪法（共享知识库）— 项目共享协议

> **本文件是所有 Agent 与人类协作的"宪法"（Truth Source）。**
> 核心思想：**用文档作为约束和协调机制** —— 所有 Agent 按同一份"剧本"行动，无需互相通信。
>
> 这个方案 = 编程的"版本控制" + AI 的"思想统一"。

---

## 🚀 快速开始（Agent 必读）

**重要！所有参与者（人类与 AI Agent）首先阅读：**

| 顺序 | 文档 | 预计时间 | 作用 |
|---|---|---|---|
| 0 | [AGENTS.md](./AGENTS.md) | 30 秒 | 社区标准入口（工具自动发现） |
| 1 | 本 README | 2 分钟 | 共享协议、宪法总纲、治理结构 |
| 2 | [CONTEXT.md](./.github/CONTEXT.md) | 5 分钟 | 我们在做什么 |
| 3 | [ARCHITECTURE.md](./ARCHITECTURE.md) | 10 分钟 | 系统如何构建 |
| 4 | [AGENT_GUIDELINES.md](./AGENT_GUIDELINES.md) | 5 分钟 | 如何参与工作 |
| 5 | [API_CONTRACT.md](./API_CONTRACT.md) | 5 分钟 | 接口规范（不可擅改） |
| 6 | [CODING_STANDARDS.md](./CODING_STANDARDS.md) | 3 分钟 | 代码标准 |
| 7 | [DECISION_LOG.md](./DECISION_LOG.md) | 2 分钟 | 过往决策历史 |

> ⚠️ **不读完上述文档就开始工作 = 违反宪法。**

---

## 📚 核心文档索引

| 文档 | 内容 | 更新权限（详见下方治理结构） |
|---|---|---|
| [AGENTS.md](./AGENTS.md) | 社区标准入口：给 Agent 的 30 秒总览 | 仅人类 |
| [项目上下文](./.github/CONTEXT.md) | 项目目标、当前阶段、Agent 分工、技术栈、禁止事项 | 人类 + 主 Agent |
| [架构设计](./ARCHITECTURE.md) | 系统结构、模块划分、架构决策 | 人类批准（主 Agent 也需获批） |
| [Agent 准则](./AGENT_GUIDELINES.md) | 工作流程、命名约定、审查重点、禁止操作 | 人类 |
| [API 约定](./API_CONTRACT.md) | 接口规范、数据格式 | 仅人类（任何 Agent 不可擅改） |
| [代码标准](./CODING_STANDARDS.md) | 编码规范、提交规范、测试要求 | 人类 + 主 Agent |
| [决策日志](./DECISION_LOG.md) | 所有重要决策及其原因 | 追加：人类 + 主 Agent |

---

## 🤖 对 AI Agent 的说明

你好，Agent！

- 在开始工作前，**必须阅读上方全部文档**
- 遵循 AGENT_GUIDELINES.md 中的规则
- 任何不确定的地方，**保守对待**（不做比做错好）
- **优先提 PR**，由人类或主 Agent 审批，禁止直接合并

---

## 🏛️ 治理结构（Governance）

> 本小节定义**角色与权限矩阵**——这是全库唯一权威版本，其他文件引用本小节，不得重复定义。

### 角色定义

| 角色 | 定义 | 任命方式 |
|---|---|---|
| **人类（Owner）** | 项目所有者，拥有最终裁决权 | 天然成立 |
| **主 Agent（Lead Agent）** | 被人类指定的协调者：审批 PR、更新 CONTEXT/任务列表、登记决策日志 | 由人类在 [DECISION_LOG.md](./DECISION_LOG.md) 中记录任命；未任命时该角色空缺，其权限归人类行使 |
| **普通 Agent** | 执行任务的 AI 编码代理（Claude Code、Codex、zcode、Kimi Work 等） | 加入即成立，须先读完宪法 |

### 审批权矩阵（谁可以做什么）

| 操作 | 人类 | 主 Agent | 普通 Agent |
|---|---|---|---|
| 审批并合并 PR | ✅ | ✅ | ❌（只能提交 PR） |
| 修改 README.md（宪法总纲） | ✅ | ❌ | ❌ |
| 修改 CONTEXT.md / CODING_STANDARDS.md | ✅ | ✅ | ❌（提 PR 建议） |
| 修改 ARCHITECTURE.md | ✅ | 需人类批准 | ❌ |
| 修改 API_CONTRACT.md | ✅ | ❌ | ❌ |
| 追加 DECISION_LOG.md | ✅ | ✅ | ❌（提 PR 建议） |
| 认领任务 / 更新任务状态 | ✅ | ✅ | ✅（须通过 PR） |
| 在指定目录写代码、提 PR | ✅ | ✅ | ✅ |
| 直接推送 main 分支 | ✅ | ❌ | ❌ |

> ⚠️ 与任何其他文件冲突时，以本矩阵为准。

---

## ✅ 当前优先级任务

> ⚠️ 此列表由人类/主 Agent 维护。Agent 可以**认领任务、更新状态，但必须通过 PR**，由人类/主 Agent 合并后生效；普通 Agent 不得直接编辑本文件。

- [ ] Task 1 — （描述）— 负责人：待指派
- [ ] Task 2 — （描述）— 负责人：待指派
- [ ] Task 3 — （描述）— 负责人：待指派

---

## 🧭 宪法精神（Why）

- **成本**：只需一次性写文档 ✍️
- **高效**：所有 Agent 按同一个"剧本"行动 🎬
- **可控**：所有规则显式化 📋
- **可扩展**：新 Agent 加入只需读一遍文档 📖
- **人类友好**：人也能理解 AI 在做什么 👤

> 修改本文件仅限**人类本人**；如需他人代改，须人类逐次明确批准。

---

## 🔄 跨模型 / 跨工具可移植性（Portability）

> 你的电脑里可能同时存在 zcode、Codex、Claude Code、Kimi Work……背后是不同模型。
> **不用纠结迁移和沟通问题**——这份宪法就是答案：所有 Agent 和模型共用同一个自然语言协作中枢（GitHub 仓库里的文档），随意切换、进度不丢。

为此本宪法遵守以下约定：

1. **纯自然语言 + 标准 Markdown**：不使用任何工具私有指令语法（不写模型专属提示词格式）
2. **入口兼容社区标准**：根目录提供 [AGENTS.md](./AGENTS.md)（社区开放标准，Copilot/Codex 等多工具自动发现），指向本套宪法
3. **渐进式披露**：入口文件保持短小；语言/框架特定规则按需拆分到独立文件，避免单文件膨胀
4. **Truth Source 唯一**：状态与规则以仓库中的文档为准，不依赖任何单个工具的本地记忆
5. **只读优先**：Agent 对宪法的默认动作是"读"；所有修改走 PR + 审批

---

## 🎪 落地五步

```
Step 1: 建立"共享宪法"（README + 若干指导文档）
        ↓
Step 2: 所有 Agent 都要读这些文档
        ↓
Step 3: Agent 在约束下工作（只读，无需互相通信）
        ↓
Step 4: 提交 PR 时引用相关规范
        ↓
Step 5: 人类或主 Agent 审批 merge
        ↓
完成！低成本、高效、可控
```

---

## 📖 社区参考（Further Reading）

- [AGENTS.md 开放标准](https://agents.md/) — "A README for agents"，多工具支持的开放入口文件规范（[agentsmd/agents.md](https://github.com/agentsmd/agents.md)）
- [How to write a great agents.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/) — GitHub 官方博客：2500+ 仓库的经验（渐进式披露、语言规则拆分）
- [chrisbergeron/AI-Constitution](https://github.com/chrisbergeron/AI-Constitution) — 开源 AI 宪法模板：作为 Agent 系统的基础治理层
- [seanrugg/ai_constitution](https://github.com/seanrugg/ai_constitution) — 多 Agent 系统的民主宪法与协作协议

> 本宪法采纳了上述社区实践的共性：文档即宪法、入口标准化、治理显式化、渐进式披露。
