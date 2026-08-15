# AGENTS.md — 给 Agent 的入口（README for Agents）

> 本文件遵循 [AGENTS.md 开放标准](https://agents.md/)：一个专门的、可预测的位置，为 AI 编码代理提供项目上下文与指令。
> Copilot、Codex 等工具会自动发现本文件；**任何 Agent 开始工作前，先读本文件，再按指引阅读宪法全文。**

---

## ⚡ 30 秒速览

- 这是一个**多 Agent 协作项目**：人类 + 多个 AI 编码代理共同工作
- 所有规则以仓库内的**宪法文档集**为唯一事实源（Truth Source）
- 默认动作：**先读文档 → 再动手 → 提交 PR → 等待审批**
- 审批权：**人类或主 Agent**（主 Agent 的任命记录在 DECISION_LOG.md）

---

## 📚 必读顺序

1. [README.md](./README.md) — 宪法总纲（2 分钟）
2. [CONTEXT.md](./.github/CONTEXT.md) — 项目上下文：我们在做什么、当前阶段、分工（5 分钟）
3. [ARCHITECTURE.md](./ARCHITECTURE.md) — 架构规范：模块边界、架构红线（10 分钟）
4. [AGENT_GUIDELINES.md](./AGENT_GUIDELINES.md) — 工作流程、命名、禁止操作（5 分钟）
5. [API_CONTRACT.md](./API_CONTRACT.md) — 接口契约：**不可擅改**（5 分钟）
6. [CODING_STANDARDS.md](./CODING_STANDARDS.md) — 代码与提交规范（3 分钟）
7. [DECISION_LOG.md](./DECISION_LOG.md) — 已生效的决策（2 分钟）

---

## 🔧 常用指令（Dev Tips）

> 以下为占位示例，请按项目实际命令替换。

- 运行全部测试：`pytest`（或项目规定的测试命令）
- 运行代码检查：按 CODING_STANDARDS.md 中"语言与格式"章节执行
- 提交前自检：对照 CODING_STANDARDS.md 的"提交前自检清单"逐项打勾

---

## 📤 PR 要求

- 标题格式：`<type>(<scope>): <subject>`（type/scope 定义见 CODING_STANDARDS.md）
- PR 描述必须引用本次任务依据的规范文档与相关章节
- 不确定的事项：在 PR 中显式标注，**保守对待，先问再做**
- 禁止直接推送到 main 分支
