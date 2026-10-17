# STATE — 接力棒（交接状态）

> **任何 Agent 接手时的第一件事：读这一页。**
> 本页回答"**现在到哪了**"，不回答"仓库是什么"（那是 [README.md](./README.md)）。
>
> **铁律**：每轮收尾必须更新本文件（不更新 = 本轮未完成）｜只写**当前**，历史归 [CHANGELOG.md](./CHANGELOG.md) 与 PR｜全文件 ≤ 50 行｜**坏消息优先写**

**更新时间**：2026-10-17 19:15 ｜ **更新者**：DSH（deepseek-flash）｜ **依据**：[AGENTS.md](./AGENTS.md)「验收」+ [docs/DOCTRINE.md](./docs/DOCTRINE.md)
**上一手**：DSH（2026-09-17，工程信条 + 仓库自用交接层，PR [#2](https://github.com/sujianddd-dev/multi-agent-ai-constitution/pull/2) 已合并）

## 🎯 当前任务（一次只写一个）

- **目标**：把安装做成**一行命令**并随 **v0.3.0 免费发布**（GitHub Release）；同步修掉 Windows 检出下 `verify.sh` 的 CRLF 失败
- **依据**：人类 2026-10-17 口述（"把安装做成一行命令、免费发布"）；README「快速开始」
- **不做**：不改 `templates/` 既有章节语义；不动 `LICENSE`；不引入个体项目信息；不上付费市场

## 📍 进度光标

- 已完成：`install.sh`（curl 一行）+ `install.ps1`（irm 一行）；自动检测 `~/.dsh` / `~/.claude` / `~/.codex` / `~/.cursor`，`--project` 铺模板（默认不覆盖，重复安装先备份）
- 已完成：`.gitattributes`（`*.sh` 强制 LF）+ `verify.sh` 容忍 CRLF frontmatter；README「快速开始」改为一行安装（手动/离线折叠保留）
- 已完成：`CHANGELOG.md` 0.3.0 增补一行安装条目（发布日改为 2026-10-17）
- 本分支：`feat/one-line-install`（PR [#3](https://github.com/sujianddd-dev/multi-agent-ai-constitution/pull/3)，待合并）
- 本地实测：WSL `bash install.sh --source . --dir/--project` 通过；Windows `pwsh -File install.ps1` 通过；`bash scripts/verify.sh` → **5/5**

## ⏭️ 下一步（接手第一件事）

1. 合并本 PR（squash）→ `git switch main && git pull --ff-only`
2. `git tag -a v0.3.0 -m "v0.3.0 · 一行安装 + 工程信条"` + `git push origin v0.3.0`
3. `gh release create v0.3.0`（标题/说明按 CHANGELOG 0.3.0；免费、MIT）
4. 用发布后的 `main` raw URL 复测两种一行命令（至少 `--dir` 与 `--project` 各一次）

## 🚧 阻塞 / 待人类拍板

- 无。版本节奏已由人类 2026-10-17「免费发布」拍板：发 v0.3.0。

## 🕳️ 已知坑（踩过的，别再踩）

- ⚠️ **Windows 检出 + WSL 跑 bash**：`core.autocrlf=true` 会让 `.sh` 变 CRLF，`set -o pipefail` 直接报错；已用 `.gitattributes` 固定 `*.sh` 为 LF，别删
- ⚠️ **SKILL.md 的 frontmatter 可能是 CRLF**：`head -1 | grep '^---$'` 会误判；验收已加 `tr -d '\r'`
- ⚠️ **GitHub raw 国内可能慢**：脚本支持 `https_proxy` / `AI_CONSTITUTION_TARBALL_URL` / `--source`，别把失败当脚本逻辑问题
- ⚠️ `AGENTS.md` 同名陷阱、`templates/` 点目录、文档坏链——见上一手记录，仍适用

## ✅ 验收

- **命令**：`bash scripts/verify.sh`
- **最近一次**：**通过 ✅**（2026-10-17，DSH／deepseek-flash）——5/5；相对链接 78 条 **0 broken**；无个体项目名
- **补充**：安装脚本在 WSL 与 Windows PowerShell 上分别实测（skill 安装 / 重装备份 / project 不覆盖 / `--force` 覆盖）

## 📌 接手自检（逐条确认，缺项先补齐再动手）

- [ ] "更新时间 / 更新者"是**上一手**留下的，不是我自己刚写的
- [ ] 我准备改的文件与"进度光标"一致（没有别人正在改同一处）
- [ ] `git log` / `git status` 与"分支 / PR"一致，**无来历不明的未提交改动**
- [ ] 验收命令我**亲自跑过**，结果与"最近一次"一致
- [ ] STATE 与仓库实际不一致时：**以仓库为准**，先更新 STATE 再动手
