# STATE — 接力棒（交接状态）

> **接手第一件事：读这一页。** 本页只回答"**现在到哪了**"（仓库是什么见 [README.md](./README.md)）。
>
> **铁律**：每轮收尾必须更新本文件（不更新 = 本轮未完成）｜只写**当前**，历史归 [CHANGELOG.md](./CHANGELOG.md) 与 PR｜≤ 50 行｜**坏消息优先写**

**更新时间**：2026-10-17 23:50 ｜ **更新者**：DSH（deepseek-flash）｜ **依据**：[AGENTS.md](./AGENTS.md)「验收」+ [docs/DOCTRINE.md](./docs/DOCTRINE.md)
**上一手**：DSH（2026-10-17，独立 skill 包 + v0.3.1 免费发布，PR [#5](https://github.com/sujianddd-dev/multi-agent-ai-constitution/pull/5) 已合并）

## 🎯 当前任务（一次只写一个）

- **目标**：维护 v0.3.1（**已发布**）；完成 Agensi **免费** listing（需人类登录）；只修安装/文档问题
- **依据**：人类 2026-10-17「一口气做完，宗旨是免费公开」
- **不做**：不做付费版/Pro Pack；不改 `templates/` 语义；不动 `LICENSE`

## 📍 进度光标

- **v0.3.1 已发布**：https://github.com/sujianddd-dev/multi-agent-ai-constitution/releases/tag/v0.3.1
- Asset：`ai-constitution-skill-v0.3.1.zip`（35,296 B / 15 files / 12 templates）；SHA256 `5A106FC1…DCE25EC`
- **发布验收**：从 Release 下载后解压，`SKILL.md` 在根、12 个 templates 齐全；WSL 用 `$SKILL_DIR/templates/.` 复制出 12 个文件
- **已修**：`SKILL.md` 独立安装路径；**已加**：`scripts/package-skill.py`、`docs/AGENSI-LISTING.md`、`.gitignore`、README zip/免费说明
- **Agensi**：zip 与 $0 文案已就绪；提交需人类账号登录，未替人类注册

## ⏭️ 下一步（接手第一件事）

1. 人类登录 Agensi → Sell → 上传 zip、价格 **$0**、粘贴 `docs/AGENSI-LISTING.md` 文案；把 listing URL 回填 STATE
2. 若平台不支持 $0：不上架，保持 GitHub 免费公开即可
3. 有安装反馈：走分支 + PR，验收仍以 `bash scripts/verify.sh` 为唯一锚点

## 🚧 阻塞 / 待人类拍板

- Agensi 提交需要**人类账号登录/同意平台条款**；其余已就绪。

## 🕳️ 已知坑（踩过的，别再踩）

- ⚠️ **Agensi 包布局**：zip 根必须是 `SKILL.md` + `templates/`，不能把 `ai-constitution.skill/` 整个目录打进去
- ⚠️ **WSL 没有 `zip`**：打包用 `python scripts/package-skill.py`（Windows `python` / WSL `python3`）
- ⚠️ **Windows 控制台 GBK**：脚本已切 UTF-8；`Get-Content` 中文乱码不代表文件坏
- ⚠️ `.sh` 必须 LF（`.gitattributes` 已锁）；SKILL.md frontmatter 可能 CRLF，验收已容忍

## ✅ 验收

- **命令**：`bash scripts/verify.sh` → **5/5**；相对链接 77 条 0 broken；无个体项目名
- **发布验收**：Release v0.3.1 公开（非 draft/prerelease）；asset 下载 hash 与本地一致；解压后 15 files / 12 templates；WSL 复制通过

## 📌 接手自检（逐条确认，缺项先补齐再动手）

- [ ] "更新时间 / 更新者"是上一手留下的；要改的文件与"进度光标"一致（没有别人正在改同一处）
- [ ] `git log` / `git status` 与"分支 / PR"一致，**无来历不明的未提交改动**
- [ ] 验收命令我**亲自跑过**，结果与"最近一次"一致；STATE 与实际不一致时**以仓库为准**，先更新 STATE 再动手
