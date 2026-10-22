# STATE — 接力棒（交接状态）

> **接手第一件事：读这一页。** 本页只回答"**现在到哪了**"（仓库是什么见 [README.md](./README.md)）。
>
> **铁律**：每轮收尾必须更新本文件（不更新 = 本轮未完成）｜只写**当前**，历史归 [CHANGELOG.md](./CHANGELOG.md) 与 PR｜≤ 50 行｜**坏消息优先写**

**更新时间**：2026-10-22 14:00 ｜ **更新者**：DSH（deepseek-flash）｜ **依据**：[AGENTS.md](./AGENTS.md)「验收」+ [docs/DOCTRINE.md](./docs/DOCTRINE.md)
**上一手**：DSH（2026-10-22，v0.2.1 修正 PR [#12](https://github.com/sujianddd-dev/multi-agent-ai-constitution/pull/12) + 广播记录 PR [#13](https://github.com/sujianddd-dev/multi-agent-ai-constitution/pull/13) 已合并；本 PR 做 v0.2.2 + 中午心跳）

## 🎯 当前任务（一次只写一个）

- **目标**：在隔离 profile 验证可用记忆 runtime；desktop 不硬改；候选账本继续可追溯
- **依据**：人类 2026-10-22 任务书与授权；`docs/MEMORY-AUDIT.md` 5.1 试装结果
- **边界**：**仅交流**。不向任何外部 Agent 开放本机文件、shell、凭据、MCP 或远程访问；自动发布/高价值自动回复保持关闭；**私信由 DSH 按规则自行判断/回复，不把原文/草稿贴给人类**

## 📍 进度光标

- EigenFlux CLI **0.6.8** 已装（用户级）；身份/资料/邮箱已在 Console 完成；Agent 名 **DSH**
- 心跳：`EigenFlux 网络收件箱`，Asia/Shanghai，cron `0 0,2,4,6,8,12 * * *`（00/02/04/06/08/12，谷段）；常驻任务：`EigenFluxDSHWatcher`（登录自启，Running，**VBS 隐藏启动、无控制台窗口**）常驻 `eigenflux stream`，PM 只 toast + 落受控临时文件，再立即 headless 处理（已回复则跳过）；心跳兜底
- 记忆：Obsidian 1.14.4 + `~/.dsh/memory-vault` 已开；Desktop `.md` 11 个已导入 `inbox/desktop-import/`（任务 `ObsidianDesktopImport` 登录 + 每 10 分钟）；desktop 仍无 memory 插件；隔离 `memory-test2` 装 `@jacklika/dsh-memory` 并通过 smoke；MemOS 2.0.20 peer 不兼容；`@jipika` 0.6.0 失败；账本 9 条 + `docs/MEMORY-AUDIT.md`
- 广播已发布：v0.1 item `370848836651843584`（22/6/0）；v0.2.1 item `371341612887834624`（11 阅读 / 3 赞 / 0 广播回复；已回 7 条私信/公开回复）
- 本地约定：Home `~/.eigenflux-dsh/.eigenflux`；skills target 已注册到 `~/.agents/skills`（host `deepseek-harness`）

## ⏭️ 下一步（接手第一件事）

1. 生产接入：在 DSH 应用插件管理里装 `@jacklika/dsh-memory`，配置稳定 vaultRoot，再重启；不手改 Electron 管理的 desktop
2. 继续 EigenFlux 公开交流；只记录有复用价值的候选，不刷评论；账本先补 JSONL 校验
3. 在任何 Runtime 接入前先落 `proposed→active` 与 `read_version/base_version`；不要先写 Qdrant/mem0/网关

## 🚧 阻塞 / 待人类拍板

- 待人类拍板：**Windows 原生（MemOS）还是 WSL/Linux（MemHub）**；MemHub 目前 **Windows 不支持 + preview**。

## 🕳️ 已知坑（踩过的，别再踩）

- ⚠️ **DeepSeek 峰谷已改**：周一至周五 9:00–12:00、14:00–18:00 为高峰；其余（含 12:00–14:00、周末/法定节假日）为空闲。旧「00:30–08:30 错峰」已失效，别按旧文章排班；**stream 单连接**，watcher 重启会替换旧连接
- ⚠️ **不得开放本地权限**：EigenFlux 只是通信层；不提供文件、shell、MCP、远程桌面、凭据或任何入站访问
- ⚠️ **stream 单连接**；watcher 只提醒，回复以心跳为准；headless 不再自动回复，避免双通道重复
- ⚠️ `.sh` 必须 LF；⚠️ **Star 数 ≠ 成熟度**；**Hy-Memory/MemHub Windows 不支持 + preview**；**私信自主回复，不贴原文/草稿**，只有安全/权限/资金/公开发布才上报

## ✅ 验收

- **命令**：`bash scripts/verify.sh` → **5/5**；相对链接 0 broken；无个体项目名
- **文档/模板验收**：`docs/MEMORY-DESIGN-V2.md` 1.4 节含 B 段验收字段；`docs/MEMORY-AUDIT.md` 5.1/5.2 含 runtime 试装与 Obsidian 导入；`docs/MEMORY-LEDGER.md` + JSONL 9 条；`docs/NETWORK-FEEDBACK.md` 含反馈记录；`templates/.github/PULL_REQUEST_TEMPLATE.md` 含四证据点与 `pending-review`
- **广播/调度验收**：`profile items` 能看到 v0.1 `370848836651843584` 与 v0.2.1 `371341612887834624`；`schedule_list` 有 1 个触发器，cron `0 0,2,4,6,8,12 * * *`；`Get-ScheduledTask EigenFluxDSHWatcher` = Running

## 📌 接手自检（逐条确认，缺项先补齐再动手）

- [ ] "更新时间 / 更新者"是上一手留下的；要改的文件与"进度光标"一致，`git log` / `git status` 与"分支 / PR"一致、无来历不明的未提交改动
- [ ] 验收命令我**亲自跑过**，结果与"最近一次"一致；STATE 与实际不一致时**以仓库为准**，先更新 STATE 再动手
