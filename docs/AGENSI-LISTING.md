# Agensi 上架文案（免费 / Free）

> 状态：**待人类登录 Agensi 提交**。包已生成，文案已就绪；上传与勾选条款需要账号。
> 原则：**免费、MIT、无付费版**。价格填 `$0` / Free，不设 Pro Pack。
>
> 包：`dist/ai-constitution-skill-v0.3.1.zip`（构建命令：`python scripts/package-skill.py --version 0.3.1`）
> Agensi 要求：zip 根目录放 `SKILL.md`（frontmatter 含 name + description）+ `templates/`，无 manifest，≤ 50 MB。本包满足。

## Listing 字段

| 字段 | 建议值 |
|---|---|
| Title | `AI Constitution — Multi-Agent Shared Rulebook` |
| Tagline | `One repo-level rulebook so Claude Code, Codex, Cursor and humans work under the same rules.` |
| Category | Developer Tools / Coding Agents |
| Price | **Free ($0)** |
| License | MIT |
| Tags | `ai-agents`, `multi-agent`, `claude-code`, `codex`, `cursor`, `copilot`, `agents-md`, `governance`, `handoff`, `state` |
| GitHub | https://github.com/sujianddd-dev/multi-agent-ai-constitution |
| Package | `dist/ai-constitution-skill-v0.3.1.zip` |

## Short description（≈ 300 字符）

A free, MIT-licensed skill that scaffolds a shared "constitution" for projects worked on by multiple coding agents and humans: AGENTS.md / CLAUDE.md entry points, STATE.md handoff, governance matrix, PR handoff template, coding standards, ADRs and a risk playbook. The constitution is the always-on rulebook; this skill generates and installs it.

## Long description

**The problem.** When Claude Code, Codex, Cursor, Copilot and humans take turns on one repository, each new session starts from chat history or guesswork. Rules drift, handoffs lose context, and nobody knows which model changed what.

**The approach.** Put the rules and the current state in the repository, not in any single tool's memory:

- `AGENTS.md` / `CLAUDE.md` — predictable entry points every agent reads first
- `README.md` — constitution, roles and approval matrix
- `STATE.md` — the handoff baton: current task, next step, blockers, acceptance
- `.github/CONTEXT.md` — project context and hard red lines
- `ARCHITECTURE.md` / `AGENT_GUIDELINES.md` / `API_CONTRACT.md` / `CODING_STANDARDS.md` / `DECISION_LOG.md` / `RISK_PLAYBOOK.md`
- `.github/PULL_REQUEST_TEMPLATE.md` — the handoff form (basis / changes / verification / leftovers / next owner)

**What the skill does.** It copies the templates into your project and walks the agent through the customization checklist: real agent roster, real stack, one model-independent acceptance command, a named lead agent, and the privacy red lines. It works with any model and any agent tool because everything is plain Markdown.

**What it is not.** Not a framework, not a runtime, not a prompt pack. It is a documentation contract: cheap to adopt, easy to audit, and portable across tools.

**License.** MIT. Free forever; no paid tier, no telemetry, no lock-in.

## 提交检查清单

- [ ] 登录 Agensi → Sell → 上传 `dist/ai-constitution-skill-v0.3.1.zip`
- [ ] 价格填 **Free / $0**，License 选 MIT
- [ ] 粘贴上面的 Title / Tagline / Description / Tags
- [ ] 在描述里放 GitHub 链接（若平台允许）
- [ ] 提交后把 listing URL 记到 `STATE.md`
