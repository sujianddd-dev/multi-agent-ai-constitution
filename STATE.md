# STATE — 接力棒（交接状态）

> **接手第一件事：读这一页。** 本页只回答"**现在到哪了**"（仓库是什么见 [README.md](./README.md)）。
>
> **铁律**：每轮收尾必须更新本文件（不更新 = 本轮未完成）｜只写**当前**，历史归 [CHANGELOG.md](./CHANGELOG.md) 与 PR｜≤ 50 行｜**坏消息优先写**

**更新时间**：2026-10-22 14:00 ｜ **更新者**：DSH（deepseek-flash）｜ **依据**：[AGENTS.md](./AGENTS.md)「验收」+ [docs/DOCTRINE.md](./docs/DOCTRINE.md)
**上一手**：DSH（2026-10-22，v0.2.1 修正 PR [#12](https://github.com/sujianddd-dev/multi-agent-ai-constitution/pull/12) + 广播记录 PR [#13](https://github.com/sujianddd-dev/multi-agent-ai-constitution/pull/13) 已合并；本 PR 做 v0.2.2 + 中午心跳）

## 🎯 当前任务（一次只写一个）

- **目标**：desktop 记忆已接入并验证写入/召回；清理无用/来源类记忆；保留 Obsidian canonical
- **依据**：人类 2026-10-22 授权；`docs/MEMORY-AUDIT.md` 5.1–5.3；清理审计子代理运行中
- **边界**：**仅交流**。不向任何外部 Agent 开放本机文件、shell、凭据、MCP 或远程访问；自动发布/高价值自动回复保持关闭；**私信由 DSH 按规则自行判断/回复，不把原文/草稿贴给人类**

## 📍 进度光标

- EigenFlux CLI **0.6.8** 已装（用户级）；身份/资料/邮箱已在 Console 完成；Agent 名 **DSH**
- 心跳：`EigenFlux 网络收件箱`，Asia/Shanghai，cron `0 0-22/2 * * *`（每 2 小时，官方默认节奏；含少量高峰时段）；`feed_poll_interval=1800`（账号级 30 分钟）；常驻任务：`EigenFluxDSHWatcher`（登录自启，Running，**PowerShell 7 `pwsh.exe` / VBS 隐藏启动、无控制台窗口**）常驻 `eigenflux stream`，PM 只 toast + 落受控临时文件，再立即 headless 处理（prompt-file + Start-Process，失败重试 1 次；已回复则跳过）；心跳兜底
- 记忆：desktop 已激活 `@jacklika/dsh-memory@0.1.7-rc.40`，vaultRoot=`~/.dsh/memory-vault`；两个 DSH profile 共享 vault，跨会话 recall/写入/冲突拒绝/restore/forget 已验收；`inbox`/`_meta` 排除；session digest + Dream proposal 已保存；账本 19 条 + `docs/MEMORY-ACCEPTANCE.md`
- 广播已发布：v0.1 `370848836651843584`；v0.2.1 `371341612887834624`；Dream/v0.2.5 `371643464200224768`（PilotDeck/Claude Dreams 借鉴）
- 本地约定：Home `~/.eigenflux-dsh/.eigenflux`；skills target 已注册到 `~/.agents/skills`（host `deepseek-harness`）

## ⏭️ 下一步（接手第一件事）

1. 做一次跨会话 `memory_recall` 验收；观察 auto-capture 是否产生噪声
2. 继续 EigenFlux 公开交流；只记录有复用价值的候选，不刷评论；账本先补 JSONL 校验
3. 在任何进一步自动化前先落 `proposed→active` 与 `read_version/base_version`；不要先写 Qdrant/mem0/网关

## 🚧 阻塞 / 待人类拍板

- 待人类拍板：**Windows 原生（MemOS）还是 WSL/Linux（MemHub）**；MemHub 目前 **Windows 不支持 + preview**。

## 🕳️ 已知坑（踩过的，别再踩）

- ⚠️ **DeepSeek 峰谷已改**：周一至周五 9:00–12:00、14:00–18:00 为高峰；其余（含 12:00–14:00、周末/法定节假日）为空闲。旧「00:30–08:30 错峰」已失效，别按旧文章排班；**stream 单连接**，watcher 重启会替换旧连接
- ⚠️ **不得开放本地权限**：EigenFlux 只是通信层；不提供文件、shell、MCP、远程桌面、凭据或任何入站访问
- ⚠️ **stream 单连接**；watcher 只提醒，回复以心跳为准；headless 不再自动回复，避免双通道重复
- ⚠️ `.sh` 必须 LF；⚠️ **Star 数 ≠ 成熟度**；**Hy-Memory/MemHub Windows 不支持 + preview**；**私信自主回复，不贴原文/草稿**，只有安全/权限/资金/公开发布才上报

## ✅ 验收

- **命令**：`bash scripts/verify.sh` → **5/5**；相对链接 0 broken；无个体项目名
- **文档/模板验收**：`docs/MEMORY-AUDIT.md` 5.1–5.5；`docs/MEMORY-ACCEPTANCE.md` 验收矩阵；`docs/MEMORY-LEDGER.md` + JSONL 19 条；`docs/MEMORY-DESIGN-V2.md` v0.2.5；`docs/NETWORK-FEEDBACK.md` 含反馈记录；`templates/.github/PULL_REQUEST_TEMPLATE.md` 含四证据点与 `pending-review`
- **广播/调度验收**：`profile items` 能看到 v0.1 `370848836651843584` 与 v0.2.1 `371341612887834624`；`schedule_list` 有 1 个触发器，cron `0 0-22/2 * * *`；`Get-ScheduledTask EigenFluxDSHWatcher` = Running

## 📌 接手自检（逐条确认，缺项先补齐再动手）

- [ ] "更新时间 / 更新者"是上一手留下的；要改的文件与"进度光标"一致，`git log` / `git status` 与"分支 / PR"一致、无来历不明的未提交改动
- [ ] 验收命令我**亲自跑过**，结果与"最近一次"一致；STATE 与实际不一致时**以仓库为准**，先更新 STATE 再动手
