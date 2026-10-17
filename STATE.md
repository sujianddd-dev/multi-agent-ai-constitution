# STATE — 接力棒（交接状态）

> **接手第一件事：读这一页。** 本页只回答"**现在到哪了**"（仓库是什么见 [README.md](./README.md)）。
>
> **铁律**：每轮收尾必须更新本文件（不更新 = 本轮未完成）｜只写**当前**，历史归 [CHANGELOG.md](./CHANGELOG.md) 与 PR｜≤ 50 行｜**坏消息优先写**

**更新时间**：2026-10-17 19:25 ｜ **更新者**：DSH（deepseek-flash）｜ **依据**：[AGENTS.md](./AGENTS.md)「验收」+ [docs/DOCTRINE.md](./docs/DOCTRINE.md)
**上一手**：DSH（2026-10-17，一行安装 + v0.3.0 发布，PR [#3](https://github.com/sujianddd-dev/multi-agent-ai-constitution/pull/3) 已合并）

## 🎯 当前任务（一次只写一个）

- **目标**：维护 v0.3.0（**已发布**）；收集一行安装的实际反馈，只修安装/文档问题，不发新功能
- **依据**：人类 2026-10-17 口述（"把安装做成一行命令、免费发布"）
- **不做**：不上付费市场；不改 `templates/` 既有章节语义；不动 `LICENSE`；不引入个体项目信息

## 📍 进度光标

- **v0.3.0 已发布**：tag `3551ed1`，Release：https://github.com/sujianddd-dev/multi-agent-ai-constitution/releases/tag/v0.3.0
- 一行安装已上线：`install.sh`（curl）+ `install.ps1`（irm）；自动检测 `~/.dsh` / `~/.claude` / `~/.codex` / `~/.cursor`；`--project` 铺模板（默认不覆盖，重复安装先备份）
- 发布后实测：PowerShell skill 安装 / project 模式 ✅；WSL bash 用 `main` raw 脚本安装 ✅（均落在 `main`）
- 配套：`.gitattributes`（`*.sh` LF）+ `verify.sh` 容忍 CRLF frontmatter；README「快速开始」已改为一行安装

## ⏭️ 下一步（接手第一件事）

1. 看是否有安装失败反馈（Windows 老版本无 `tar`、GitHub raw 慢/不通是已知边界）
2. 若需改：走分支 + PR，验收仍以 `bash scripts/verify.sh` 为唯一锚点
3. 可选（免费）：把 skill 提交到社区 skills 目录/awesome list；**不做**付费上架

## 🚧 阻塞 / 待人类拍板

- 无。

## 🕳️ 已知坑（踩过的，别再踩）

- ⚠️ **Windows 检出 + WSL 跑 bash**：`core.autocrlf=true` 会让 `.sh` 变 CRLF，`set -o pipefail` 直接报错；`.gitattributes` 已固定 `*.sh` 为 LF，别删
- ⚠️ **SKILL.md 的 frontmatter 可能是 CRLF**：`head -1 | grep '^---$'` 会误判；验收已加 `tr -d '\r'`
- ⚠️ **GitHub raw 国内可能慢**：脚本支持 `https_proxy` / `AI_CONSTITUTION_TARBALL_URL` / `--source`；另注意 `AGENTS.md` 同名陷阱、`templates/` 点目录、文档坏链（见 AGENTS.md）

## ✅ 验收

- **命令**：`bash scripts/verify.sh`
- **最近一次**：**通过 ✅**（2026-10-17，DSH／deepseek-flash）——5/5；相对链接 77 条 **0 broken**；无个体项目名
- **发布验收**：Release v0.3.0 公开（非 draft / 非 prerelease）；`main` raw 的两种一行命令均实测成功

## 📌 接手自检（逐条确认，缺项先补齐再动手）

- [ ] "更新时间 / 更新者"是上一手留下的；要改的文件与"进度光标"一致（没有别人正在改同一处）
- [ ] `git log` / `git status` 与"分支 / PR"一致，**无来历不明的未提交改动**
- [ ] 验收命令我**亲自跑过**，结果与"最近一次"一致
- [ ] STATE 与仓库实际不一致时：**以仓库为准**，先更新 STATE 再动手
