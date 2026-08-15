---
name: ai-constitution
description: 为任意项目生成"多 Agent AI 宪法"共享知识库（README 总纲+治理结构、CONTEXT、ARCHITECTURE、AGENT_GUIDELINES、API_CONTRACT、CODING_STANDARDS、DECISION_LOG、AGENTS 入口）。当项目需要多个 AI 编码代理（Claude Code、Codex、zcode、Kimi Work 等）与人类在同一套规则下协作时使用。
---

# 多 Agent AI 宪法（ai-constitution）

> 核心思想：**用文档作为约束和协调机制** —— 所有 Agent 按同一份"剧本"行动，无需互相通信。
> 这个方案 = 编程的"版本控制" + AI 的"思想统一"。

## 何时使用

- 项目将有 / 已有**多个 AI 编码代理**参与（Claude Code、Codex、zcode、Kimi Work……背后是任意模型）
- 需要统一的规则、审批流程与唯一事实源（Truth Source）
- 想在**不同模型 / 工具之间自由切换**，而进度保持稳定

## 快速开始

1. 将 `templates/` 下的文件复制到目标项目根目录：
   - `CONTEXT.md` → 目标项目 **`.github/CONTEXT.md`**（其余文件放项目根目录）
2. 填写占位符：
   - `XXX` 系统 / `YYY` 特性 / `ZZZ` 不处理的场景（CONTEXT.md）
   - Agent 分工表、技术栈、当前阶段（CONTEXT.md）
   - 任务列表负责人（README.md）
3. 在 DECISION_LOG.md 追加两条决策：
   - `项目信息正式入册`
   - `任命 <某 Agent> 为主 Agent`（主 Agent 权限见 README「治理结构」审批权矩阵）
4. `git init` + 首次提交（默认分支 `main`）
5. 把仓库推送到 GitHub —— 宪法随项目走，任何 Agent 克隆后即自动进入协作流程

## 核心原则

- **文档即宪法**：所有 Agent 读同一份"剧本"，不需要 Agent 之间互相通信
- **Truth Source 唯一**：状态与规则只存在文档里，不依赖任何单个工具的本地记忆
- **只读优先**：Agent 对宪法的默认动作是"读"；所有修改走 PR + 审批
- **渐进式披露**：入口文件（AGENTS.md/README.md）短小，细节分层到各规范文件
- **模型 / 工具无关**：纯自然语言 Markdown，无工具私有指令语法；AGENTS.md 兼容社区开放标准
- **红线显式化**：禁止事项、审批权矩阵写死在文档里，杜绝"我以为可以"

## 治理要点（生成后）

- 审批权矩阵（README「治理结构」）是唯一权威，其他文件不得重复定义、不得冲突
- API_CONTRACT.md 含"模板状态声明"：首次实施前必须由人类与实现对齐，对齐后才正式生效
- 决策日志**只追加不删除**，废弃旧决策须新增记录说明
- 隐私红线（如项目涉及用户数据）建议写入 CONTEXT.md「不处理」与 API_CONTRACT.md

## ⚠️ 必须按目标项目环境定制（不要逐字复制）

> 本 skill 提供的是**通用骨架**。每个人的生产环境不同：Agent 阵容与模型、技术栈、目录结构、命令、团队规模、合规要求都不同。

生成宪法前，**先探测目标项目的真实环境**（语言/框架/目录结构/已有工具链），再按下列清单把模板内容映射到实际：

1. **Agent 分工** → 用项目实际使用的工具与模型替换占位（CONTEXT.md）
2. **技术栈** → 替换为项目真实技术栈
3. **常用命令** → 替换 Dev Tips 中的 `pytest` 等占位命令
4. **目录结构** → 按项目形态调整 ARCHITECTURE.md 的 `modules/`（插件 / 桌面 / 微服务……），调整须写入决策日志
5. **API 契约** → 只给草案并保留"模板状态声明"，提醒人类在首次实施前与真实实现对齐
6. **治理结构** → 提醒人类任命主 Agent；按团队规模增删审批权矩阵
7. **阶段与任务** → 按项目实际进度填写
8. **隐私红线** → 按项目的数据合规要求增删

**适配提示：**

- 若目标 Agent 上下文窗口较小：只要求读 `AGENTS.md` + `CONTEXT.md` 即可开工（渐进式披露）
- 语言/框架特定规则建议拆分为独立文件，避免单文件膨胀
- 小团队可精简为四件套：AGENTS / README / CONTEXT / DECISION_LOG
- 生成后明确告诉用户：**模板未定制前不得视为已生效的宪法**

## 模板清单

| 文件 | 安装位置 | 作用 |
|---|---|---|
| `AGENTS.md` | 项目根 | 社区标准入口（工具自动发现） |
| `README.md` | 项目根 | 宪法总纲 + 治理结构 + 任务列表 |
| `CONTEXT.md` | `.github/CONTEXT.md` | 项目上下文 + 红线 |
| `ARCHITECTURE.md` | 项目根 | 架构规范 + 变更审批 |
| `AGENT_GUIDELINES.md` | 项目根 | Agent 行为准则 + 工作流 |
| `API_CONTRACT.md` | 项目根 | 接口契约（不可擅改） |
| `CODING_STANDARDS.md` | 项目根 | 代码与提交规范 |
| `DECISION_LOG.md` | 项目根 | 决策历史（只追加） |
