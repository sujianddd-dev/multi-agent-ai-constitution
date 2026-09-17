# STATE — 接力棒（交接状态）

> **任何 Agent 接手时的第一件事：读这一页。**
> 本页回答"**现在到哪了**"，不回答"仓库是什么"（那是 [README.md](./README.md)）。
>
> **铁律**：每轮收尾必须更新本文件（不更新 = 本轮未完成）｜只写**当前**，历史归 [CHANGELOG.md](./CHANGELOG.md) 与 PR｜全文件 ≤ 50 行｜**坏消息优先写**

**更新时间**：2026-09-17 11:30 ｜ **更新者**：DSH（deepseek-flash）｜ **依据**：[AGENTS.md](./AGENTS.md)「验收」+ [docs/DOCTRINE.md](./docs/DOCTRINE.md)
**上一手**：DSH（2026-09-10，交接层作为**模板**落库，PR #1）

## 🎯 当前任务（一次只写一个）

- **目标**：把**工程信条**落进本库（协议优先 + 聚合展现 / 灰度数据闭环 / 迭代严谨 / 风险护栏），并让本仓库**自己先用上**交接层
- **依据**：README「设计思想」+ [docs/WHY.md](./docs/WHY.md)「边界与代价」；人类口述理念（2026-09-17）
- **不做**：不改 `templates/` 既有章节的语义（只**增量补充**条款）；不动 `LICENSE`；不发新版（版本节奏待人类拍板）

## 📍 进度光标

- 已完成（2026-09-10）：交接层作为**模板**落库（PR #1）——`templates/STATE.md`、`templates/.github/PULL_REQUEST_TEMPLATE.md`、`docs/ENTRY-POINTS.md`、`docs/WHY.md`
- 本分支（`feat/doctrine-and-self-adoption`，**未提交**）：① 仓库自用交接层（`AGENTS.md` / `CLAUDE.md` / `STATE.md` / `.github/PULL_REQUEST_TEMPLATE.md` / `scripts/verify.sh` / `scripts/check-links.mjs`）② 工程信条落库（`docs/DOCTRINE.md` + 模板条款补充 + 新模板 `RISK_PLAYBOOK.md`）
- 关联 PR：待开（本轮收尾前回填编号）

## ⏭️ 下一步（接手第一件事）

1. 复核本 PR：重点看 `docs/DOCTRINE.md` 的五条信条是否与你（人类）的口述一致，以及 `templates/` 的增量条款是否**向后兼容**
2. 拍板两件事：**是否发 v0.2.0**（交接层 + 工程信条两批变更）；`RISK_PLAYBOOK.md` **是纳入默认套件还是"按需添加"**
3. 若通过：把 `docs/DOCTRINE.md` 的要点回灌进 `ai-constitution.skill/SKILL.md`（生成流程里体现信条，见 DOCTRINE「落地映射」表）

## 🚧 阻塞 / 待人类拍板

- 版本节奏：v0.2.0 是否随本 PR 一起发（`CHANGELOG.md` 已备好条目）
- 模板套件边界：新增 `RISK_PLAYBOOK.md` 之后，默认套件是 11 件还是"10 件 + 按需 1 件"

## 🕳️ 已知坑（踩过的，别再踩）

- ⚠️ **本仓库此前"医者不自医"**：把 STATE / PR 交接单做成模板发给别项目，自己却没有 → 接手者只能靠聊天记录推断（违反"Truth Source 唯一"）。本 PR 起自用，**别回退**
- ⚠️ **`AGENTS.md` 同名陷阱**：根 `AGENTS.md` = 本仓库入口；`ai-constitution.skill/templates/AGENTS.md` = 发给项目的模板。改错对象=污染下游
- ⚠️ **`cp -r templates/*` 不带点目录**：`.github/PULL_REQUEST_TEMPLATE.md` 必须单独复制（README 快速开始已注明）
- ⚠️ **文档仓库也会"坏链"**：新增文档后必须跑 `scripts/verify.sh`，否则相对链接静默 404
- ⚠️ **"模板布局 ≠ 分发布局"曾是 6 条坏链的根因**：`CONTEXT.md` 已归位到 `templates/.github/`；安装改为单条 `cp -r templates/.`（旧写法 `cp -r templates/*` + 手工 `mv` 已废弃，别再教别人用）

## ✅ 验收

- **命令**：`bash scripts/verify.sh`（模板齐全 / SKILL frontmatter / 必读顺序一致 / 相对链接 0 broken / **无个体项目名**）
- **最近一次**：**通过 ✅**（2026-09-17，执行者：DSH／deepseek-flash）——`bash scripts/verify.sh` → **5/5**；相对链接 77 条 **0 broken**；无个体项目名

## 📌 接手自检（逐条确认，缺项先补齐再动手）

- [ ] "更新时间 / 更新者"是**上一手**留下的，不是我自己刚写的
- [ ] 我准备改的文件与"进度光标"一致（没有别人正在改同一处）
- [ ] `git log` / `git status` 与"分支 / PR"一致，**无来历不明的未提交改动**
- [ ] 验收命令我**亲自跑过**，结果与"最近一次"一致
- [ ] STATE 与仓库实际不一致时：**以仓库为准**，先更新 STATE 再动手
