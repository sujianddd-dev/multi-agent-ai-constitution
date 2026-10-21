# STATE — 接力棒（交接状态）

> **接手第一件事：读这一页。** 本页只回答"**现在到哪了**"（仓库是什么见 [README.md](./README.md)）。
>
> **铁律**：每轮收尾必须更新本文件（不更新 = 本轮未完成）｜只写**当前**，历史归 [CHANGELOG.md](./CHANGELOG.md) 与 PR｜≤ 50 行｜**坏消息优先写**

**更新时间**：2026-10-22 03:20 ｜ **更新者**：DSH（deepseek-flash）｜ **依据**：[AGENTS.md](./AGENTS.md)「验收」+ [docs/DOCTRINE.md](./docs/DOCTRINE.md)
**上一手**：DSH（2026-10-22，v0.2.1 修正 PR [#12](https://github.com/sujianddd-dev/multi-agent-ai-constitution/pull/12) + 广播记录 PR [#13](https://github.com/sujianddd-dev/multi-agent-ai-constitution/pull/13) 已合并；本 PR 做 v0.2.2 + 中午心跳）

## 🎯 当前任务（一次只写一个）

- **目标**：把首批两条私信回复的工程 bug 写进 v0.2.2；心跳加入 12:00 谷段；等人类确认是否回复两位 Agent
- **依据**：人类 2026-10-22 指令；`docs/MEMORY-DESIGN-V2.md` 1.2 节；`docs/NETWORK-FEEDBACK.md` 反馈表
- **边界**：**仅交流**。不向任何外部 Agent 开放本机文件、shell、凭据、MCP 或远程访问；自动发布/自动私信回复/高价值自动回复均关闭

## 📍 进度光标

- EigenFlux CLI **0.6.8** 已装（用户级）；身份/资料/邮箱已在 Console 完成；Agent 名 **DSH**
- 心跳触发器：`EigenFlux 网络收件箱`，时区 Asia/Shanghai，cron `0 0,2,4,6,8,12 * * *`（每天 00:00/02:00/04:00/06:00/08:00/12:00；12:00–14:00 为谷段）
- 广播已发布：v0.1 item `370848836651843584`（22/6/0）；v0.2.1 item `371341612887834624`（11 阅读 / 3 赞 / 0 广播回复；另有 2 条私信回复）
- 记录文档：`docs/NETWORK-FEEDBACK.md`（10 条相近 demand + 2 条匿名方向级 bug）；记忆调研：`docs/MEMORY-SYSTEMS-RESEARCH.md`；v0.2.2：`docs/MEMORY-DESIGN-V2.md`（1.2 首批回复修正）
- 本地约定：Home `~/.eigenflux-dsh/.eigenflux`；skills target 已注册到 `~/.agents/skills`（host `deepseek-harness`）

## ⏭️ 下一步（接手第一件事）

1. 等人类确认后，回复两条私信：布雷登（epoch scope）与 Hermes Lab Assistant（processed != landed）；不自动回复
2. 选路线：WSL/Linux 试 **MemHub**（DSH Profile MCP + Hermes/Pi）；或 Windows 原生试 **MemOS**；只动测试 profile
3. 按 v0.2.2 先上 Integrity/Authority 闸，再谈导入/固化；不要先写 Qdrant/mem0/网关

## 🚧 阻塞 / 待人类拍板

- 待人类拍板：**是否回复两条私信**；**Windows 原生（MemOS）还是 WSL/Linux（MemHub）**；MemHub 目前 **Windows 不支持 + preview**。

## 🕳️ 已知坑（踩过的，别再踩）

- ⚠️ **DeepSeek 峰谷已改**：周一至周五 9:00–12:00、14:00–18:00 为高峰；其余（含 12:00–14:00、周末/法定节假日）为空闲。旧「00:30–08:30 错峰」已失效，别按旧文章排班
- ⚠️ **不得开放本地权限**：EigenFlux 只是通信层；不提供文件、shell、MCP、远程桌面、凭据或任何入站访问
- ⚠️ **心跳 host**：provision 的 runtime host 是 `deepseek-harness`，需把 skills target 注册到 `~/.agents/skills`，否则 `heartbeat plan` 报 unknown host
- ⚠️ `.sh` 必须 LF；⚠️ **Star 数 ≠ 成熟度**；**Hy-Memory/MemHub Windows 不支持 + preview**，License 逐项核对（AGPL/Other 先排除）

## ✅ 验收

- **命令**：`bash scripts/verify.sh` → **5/5**；相对链接 0 broken；无个体项目名
- **文档/模板验收**：`docs/MEMORY-DESIGN-V2.md` 1.1 节含实际 issue 表与 Integrity/Authority；`docs/NETWORK-FEEDBACK.md` 含 10 条相近 demand；`templates/.github/PULL_REQUEST_TEMPLATE.md` 含四证据点与 `pending-review`
- **广播/调度验收**：`profile items` 能看到 v0.1 `370848836651843584` 与 v0.2.1 `371341612887834624`；`schedule_list` 只有 1 个 EigenFlux 触发器，cron `0 0,2,4,6,8,12 * * *`，Asia/Shanghai

## 📌 接手自检（逐条确认，缺项先补齐再动手）

- [ ] "更新时间 / 更新者"是上一手留下的；要改的文件与"进度光标"一致，`git log` / `git status` 与"分支 / PR"一致、无来历不明的未提交改动
- [ ] 验收命令我**亲自跑过**，结果与"最近一次"一致；STATE 与实际不一致时**以仓库为准**，先更新 STATE 再动手
