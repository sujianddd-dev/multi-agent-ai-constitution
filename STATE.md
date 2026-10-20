# STATE — 接力棒（交接状态）

> **接手第一件事：读这一页。** 本页只回答"**现在到哪了**"（仓库是什么见 [README.md](./README.md)）。
>
> **铁律**：每轮收尾必须更新本文件（不更新 = 本轮未完成）｜只写**当前**，历史归 [CHANGELOG.md](./CHANGELOG.md) 与 PR｜≤ 50 行｜**坏消息优先写**

**更新时间**：2026-10-20 16:40 ｜ **更新者**：DSH（deepseek-flash）｜ **依据**：[AGENTS.md](./AGENTS.md)「验收」+ [docs/DOCTRINE.md](./docs/DOCTRINE.md)
**上一手**：DSH（2026-10-17，v0.3.1 独立包发布，PR [#6](https://github.com/sujianddd-dev/multi-agent-ai-constitution/pull/6) 已合并）

## 🎯 当前任务（一次只写一个）

- **目标**：EigenFlux 接入已完成；公开广播「多 Agent AI 宪法」征求 prior art / 批评 / 试跑反馈，并把反馈匿名整理进 [docs/NETWORK-FEEDBACK.md](./docs/NETWORK-FEEDBACK.md)
- **依据**：人类 2026-10-20 指令；EigenFlux onboarding 规则
- **边界**：**仅交流**。不向任何外部 Agent 开放本机文件、shell、凭据、MCP 或远程访问；自动发布/自动私信回复/高价值自动回复均关闭

## 📍 进度光标

- EigenFlux CLI **0.6.8** 已装（用户级）；身份/资料/邮箱已在 Console 完成；Agent 名 **DSH**
- 心跳触发器：`EigenFlux 网络收件箱`，时区 Asia/Shanghai，cron `0 0-8/2 * * *`（每天 00:00/02:00/04:00/06:00/08:00）
- 广播已发布：EigenFlux item `370848836651843584`（`demand`，14 天有效）
- 记录文档：`docs/NETWORK-FEEDBACK.md`（发布原文、边界、反馈表、心跳节奏）
- 本地约定：Home `~/.eigenflux-dsh/.eigenflux`；skills target 已注册到 `~/.agents/skills`（host `deepseek-harness`）

## ⏭️ 下一步（接手第一件事）

1. 每次心跳只处理 EigenFlux 的 Feed/私信/回复；收到实质建议或批评时，摘要+匿名后追加到 `docs/NETWORK-FEEDBACK.md`
2. 需要跟进的反馈转成 GitHub issue；不把外部原文、邮箱、路径或凭据写进仓库
3. 任何发布/私信仍按手动确认，不因心跳自动对外发言

## 🚧 阻塞 / 待人类拍板

- 无。反馈是异步的；等网络回复即可。

## 🕳️ 已知坑（踩过的，别再踩）

- ⚠️ **DeepSeek 峰谷已改**：周一至周五 9:00–12:00、14:00–18:00 为高峰；其余（含周末/法定节假日）为空闲。旧「00:30–08:30 错峰」已失效，别按旧文章排班
- ⚠️ **不得开放本地权限**：EigenFlux 只是通信层；不提供文件、shell、MCP、远程桌面、凭据或任何入站访问
- ⚠️ **心跳 host**：provision 的 runtime host 是 `deepseek-harness`，需把 skills target 注册到 `~/.agents/skills`，否则 `heartbeat plan` 报 unknown host
- ⚠️ `.sh` 必须 LF（`.gitattributes` 已锁）；验收仍以 `bash scripts/verify.sh` 为准

## ✅ 验收

- **命令**：`bash scripts/verify.sh` → **5/5**；相对链接 0 broken；无个体项目名
- **广播验收**：`eigenflux profile items` 能看到 item `370848836651843584`，发布原文与 `docs/NETWORK-FEEDBACK.md` 一致
- **调度验收**：`schedule_list` 只有 1 个 EigenFlux 触发器，cron `0 0-8/2 * * *`，Asia/Shanghai

## 📌 接手自检（逐条确认，缺项先补齐再动手）

- [ ] "更新时间 / 更新者"是上一手留下的；要改的文件与"进度光标"一致，`git log` / `git status` 与"分支 / PR"一致、无来历不明的未提交改动
- [ ] 验收命令我**亲自跑过**，结果与"最近一次"一致；STATE 与实际不一致时**以仓库为准**，先更新 STATE 再动手
