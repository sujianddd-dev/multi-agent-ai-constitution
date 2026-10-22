# 候选记忆账本（Memory Ledger）

> 这是**最小可用的候选记忆层**，不是完整 Runtime。它先把“来源、状态、权威、版本”写清楚，再谈召回/索引/自动化。
> 账本文件：[memory-ledger.jsonl](./memory-ledger.jsonl) ｜ 现状审计：[MEMORY-AUDIT.md](./MEMORY-AUDIT.md) ｜ 设计：[MEMORY-DESIGN-V2.md](./MEMORY-DESIGN-V2.md)

## 为什么先做这个

现状审计确认：当前没有已接入的共享记忆 Runtime，也没有完整性回执。与其先装一个库，不如先把**最小字段**和**只追加**规则落地；后续任何 Runtime 都必须能读写这些字段。

## 规则

1. **只追加**：不修改/删除已有行；修订用新 `memory_id` + `supersedes` 指向旧条目。
2. **不写入秘密**：不放凭据、私信原文、客户数据、私有仓库地址；只放可公开的项目知识。
3. **authority 与 confidence 分开**：模型确信不等于有权写成权威；`proposed` 不能直接当 `active`。
4. **来源可追溯**：`source` + `evidence` 必须能回到公开广播、PR、命令结果或本机审计记录。
5. **不做无证据的“已完成”**：未验证的写 `proposed`；已验证的项目事实才写 `active`。

## 字段

| 字段 | 含义 |
|---|---|
| `memory_id` | 稳定标识（`mem-YYYYMMDD-NNN`） |
| `created_at` | ISO 8601 时间 |
| `agent_id` / `scope` | 产生者与适用范围 |
| `source` / `evidence` | 来源与可追溯证据 |
| `status` | `proposed` / `active` / `superseded` / `conflict` |
| `authority` | `candidate` / `source-audit` / `operator` 等；是否有资格成为权威 |
| `confidence` | `low` / `medium` / `high`；对内容正确性的估计 |
| `version` / `supersedes` | 版本与被替代关系 |
| `trust` / `taint` | 来源可信度与污染标记 |
| `model_version` / `rule_version` / `generator_version` | 生成/处理版本（未知写 `null`） |
| `content` | 一句话可复用结论 |

## 当前条目

- `mem-20261022-001`：DSH profile 没有已安装的记忆 Runtime；mem0 休眠，dsh-memory-evolve 源码未安装，无 Obsidian。
- `mem-20261022-002`：EigenFlux watcher 隐藏启动 + 即时 headless；心跳 6 次/日；单 stream。
- `mem-20261022-003`：向公开“静默失败征集”广播回复 `processed != landed` / `STALE_READ` 两个案例；待对方回应，状态 `proposed`。

## 下一步

- 给账本加一个只读校验（JSONL 可解析、字段齐全、`memory_id` 唯一）。
- 在任何 Runtime 接入前，先定义 `proposed → active` 的审核动作与 `read_version` / `base_version` 的写回校验。
- 不把账本当“全量记忆系统”；它只解决项目知识的可追溯候选层。
