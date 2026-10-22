# 记忆系统验收快照（2026-10-22）

> 结论：**DSH 单机记忆层已验收；完整的多 Agent 共享 Runtime 还没有。**
> 相关：[现状审计](./MEMORY-AUDIT.md) ｜ [设计 v0.2.5](./MEMORY-DESIGN-V2.md) ｜ [候选账本](./MEMORY-LEDGER.md)

## 验收矩阵

| 项目 | 结果 | 证据 / 边界 |
|---|---|---|
| 共享记忆 Runtime | ⚠️ **单机共享层通过，跨框架未做** | desktop 用 `@jacklika/dsh-memory@0.1.7-rc.40` + Obsidian vault；第二个 DSH profile 可读写同一 vault；Hermes/Pi/Codex 未接 |
| 多 Agent 共享 | ⚠️ **两个 DSH Agent 通过** | `memory-test2` 读到 activation/session/dream 三条；写入 handshake note，desktop 能读；已归档 |
| Integrity | ✅ **冲突检测通过** | `wiki_write` 用过期 `baseVersion` 被拒绝（`changed since it was read`）；正确 baseVersion 随后成功 |
| Authority | ⚠️ **部分** | per-agent namespace、串行队列、git、baseVersion 有；没有运行时 `proposed→active` 闸，也没有 authority 与 confidence 的强制分离 |
| 跨会话召回 | ✅ **通过** | 第二个 DSH Agent 用 `memory_search` 找到 activation + session digest；语义检索 `unavailable`，仅词法 |
| 冲突 | ✅ **通过** | 过期写拒绝；归档/恢复不回滚 raw 历史 |
| 降级 | ⚠️ **观察通过，未做故障注入** | `wiki_search` 返回 `semantic=unavailable`、`fused=false`，自动回退词法；没有模拟索引损坏/超时 |
| 恢复 | ✅ **通过** | `wiki_restore` 恢复到 v1；`memory_forget` 归档到 `archive/`；git 历史保留 |
| EigenFlux 持续探索 | ⏳ **运行中** | 心跳每 2 小时；20:00 cycle 完成 5 条 attention、主动回复夹具征集、发布 Dream 广播；下一次 22:00 |

## 还没做完（不是配置开关）

1. **跨框架共享 Runtime**：Hermes/Pi/Claude/Codex 没有接同一个 memory MCP/写队列；当前只有 DSH profile 级共享。
2. **Authority 运行时**：没有强制的 `proposed→active`、`read_version/base_version` 回执、`dream_receipt`；目前靠 frontmatter + 人工 Curator。
3. **自动 Dream**：只有手动 Dream pass；没有 idle 触发器、自动 `dream_receipt`、一键回滚 UI。
4. **正式降级/恢复评测**：没有故障注入（索引损坏、向量超时、配额、半写）与负控样本。
5. **EigenFlux 持续探索**：只能保持心跳与主动交流，不能“今天做完”；下一次 22:00。

## 今天可以收口的部分

- DSH 单机记忆：**已收口**（写入/召回/冲突/恢复/第二个 DSH Agent）。
- 跨框架多 Agent 共享：**不建议今天硬上**；需要先选 MCP 共享层与 authority 方案，否则会得到一个绕过队列/回执的假共享。
- Dream：设计已进 v0.2.5，手动 pass 已做；自动调度留到运行时实现后。

> 本快照只记录已实际执行并验证的结果；“未做”不写成“已完成”。
