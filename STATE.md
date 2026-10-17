# STATE — 接力棒（交接状态）

> **接手第一件事：读这一页。** 本页只回答"**现在到哪了**"（仓库是什么见 [README.md](./README.md)）。
>
> **铁律**：每轮收尾必须更新本文件（不更新 = 本轮未完成）｜只写**当前**，历史归 [CHANGELOG.md](./CHANGELOG.md) 与 PR｜≤ 50 行｜**坏消息优先写**

**更新时间**：2026-10-17 23:40 ｜ **更新者**：DSH（deepseek-flash）｜ **依据**：[AGENTS.md](./AGENTS.md)「验收」+ [docs/DOCTRINE.md](./docs/DOCTRINE.md)
**上一手**：DSH（2026-10-17，一行安装 + v0.3.0 发布，PR [#4](https://github.com/sujianddd-dev/multi-agent-ai-constitution/pull/4) 已合并）

## 🎯 当前任务（一次只写一个）

- **目标**：把 skill 做成**独立分发包**（zip 根目录 = `SKILL.md` + `templates/`），随 **v0.3.1 免费发布**；备好 Agensi 免费上架文案
- **依据**：人类 2026-10-17「一口气做完，宗旨是免费公开」；Agensi 回复的打包要求
- **不做**：不做付费版/Pro Pack；不改 `templates/` 语义；不动 `LICENSE`；不替人类注册 Agensi 账号

## 📍 进度光标

- **已修**：`SKILL.md` 模板复制路径改为独立布局（`$SKILL_DIR/templates/.`），不再依赖仓库里的 `ai-constitution.skill/`
- **已加**：`scripts/package-skill.py`（zip 根 `SKILL.md` + 12 个 templates + LICENSE/README；内置 frontmatter/路径/50 MB 检查）；`.gitignore` 忽略 `dist/`
- **已加**：`docs/AGENSI-LISTING.md`（免费 $0 文案、tags、提交清单）；README 增加 zip 下载入口与"永久免费/MIT"说明
- **实测**：`python scripts/package-skill.py --version 0.3.1` → 15 files / 34.5 KiB；`Expand-Archive` 解压后 `SKILL.md`、`templates/AGENTS.md`、`.github/CONTEXT.md` 齐全；WSL 用 `$SKILL_DIR/templates/.` 复制出 12 个文件

## ⏭️ 下一步（接手第一件事）

1. 合并本 PR（squash）→ `main` 上重建 zip → `git tag v0.3.1` + push
2. `gh release create v0.3.1`（免费、MIT）→ `gh release upload v0.3.1 dist/ai-constitution-skill-v0.3.1.zip`
3. 复测 release asset：下载后解压，确认 `SKILL.md` 在根 + 12 个 templates
4. 人类登录 Agensi → Sell → 上传 zip、价格 $0、粘贴 `docs/AGENSI-LISTING.md` 文案；把 listing URL 回填 STATE

## 🚧 阻塞 / 待人类拍板

- Agensi 提交需要**人类账号登录**（不替人类注册/同意条款）；其余已就绪。

## 🕳️ 已知坑（踩过的，别再踩）

- ⚠️ **Agensi 包布局**：zip 根必须是 `SKILL.md`（frontmatter 含 name+description）+ `templates/`，不能把 `ai-constitution.skill/` 整个目录打进去
- ⚠️ **WSL 没有 `zip`**：打包用 `python scripts/package-skill.py`（Windows 的 `python` / WSL 的 `python3` 均可），别临时装 zip
- ⚠️ **Windows 控制台 GBK**：脚本已把 stdout 切 UTF-8；`Get-Content` 中文乱码不代表文件坏
- ⚠️ `.sh` 必须 LF（`.gitattributes` 已锁）；SKILL.md frontmatter 可能 CRLF，验收已容忍

## ✅ 验收

- **命令**：`bash scripts/verify.sh` → **5/5**；相对链接 77 条 0 broken；无个体项目名
- **打包验收**：`python scripts/package-skill.py --version 0.3.1`；zip 15 files / 34.5 KiB；根有 `SKILL.md`、12 个 `templates/`；解压后独立复制可用

## 📌 接手自检（逐条确认，缺项先补齐再动手）

- [ ] "更新时间 / 更新者"是上一手留下的；要改的文件与"进度光标"一致（没有别人正在改同一处）
- [ ] `git log` / `git status` 与"分支 / PR"一致，**无来历不明的未提交改动**
- [ ] 验收命令我**亲自跑过**，结果与"最近一次"一致；STATE 与实际不一致时**以仓库为准**，先更新 STATE 再动手
