# Agent 工作准则（AGENT_GUIDELINES）

> 本文件是所有 Agent 的**行为规范**。不遵守 = 违反宪法。

---

## 🔄 工作流程

1. **读 `STATE.md`（接力棒）**——接手第一读："现在到哪了"；再读 `README.md`（含治理结构）+ `.github/CONTEXT.md`
2. 理解当前阶段和目标
3. 阅读相关的规范文件（AGENT_GUIDELINES / API_CONTRACT / CODING_STANDARDS）
4. 在指定目录执行任务——**增量优先**：计划只做到"下一个可验证增量"，不做重型前置规划
5. 提交 PR 附上说明（描述按 PR 模板「交接五问」）
6. 等待**人类或主 Agent** 审批（角色与权限见 README「治理结构」）
7. **收尾：更新 `STATE.md`**（进度光标 / 下一步 / 阻塞 / 验收结果）——**不更新 = 本轮未完成**

---

## 🚦 灰度前置（涉及用户可见变更时）

> 依据：工程信条《DOCTRINE》§2。**方向由数据决定，不由直觉决定。**

动手前必须写下四要素（缺一不可）：

| 要素 | 必须回答 |
|---|---|
| **指标** | 改哪个数？成功线 / 失败线各是多少（1 个北极星 + ≤2 个护栏指标） |
| **分层采样** | 放量维度与阶梯（内部 → 1% → 10% → 50% → 100%），每级观察多久 |
| **归因** | 怎么判断变化来自本次改动（对照 / 前后对比 / 混淆因素；改动前的自然波动是多少） |
| **关门阈值** | 触发"**停止放量并回滚**"的硬条件，**提前**写死 |

> 四要素写进 PR 描述或 `STATE.md` 的「🎚️ 灰度状态」行；**事后补写的不算**。
> 关门阈值一旦触发：**回滚优先于分析**（先止血，再归因）。

---

## ↩️ 回滚（每个变更都要能退）

> 依据：工程信条《DOCTRINE》§3「回滚：git」。

- **小 PR、单一主题**：一个 PR 只做一件事（可 `revert`、可归因）
- **数据 / schema 变更**：要么可逆，要么**前置备份 + 回滚脚本**，并在 PR 中说明"半失败怎么办"
- **PR 中必须回答**：这个改动坏了怎么退回？（命令 / 步骤）
- 禁止：无法回滚的变更直接进 `main`

---

## 🆘 风险分级响应（出了事怎么办）

> 完整可填写模板见 [RISK_PLAYBOOK.md](./RISK_PLAYBOOK.md)；依据《DOCTRINE》§5。

- **P0 红线**（数据丢失 / 资金 / 安全 / 隐私）：**立即**停止写入与放量 → 回滚 → 隔离现场 → 通知人类 → 24h 内复盘
- **P1 严重**（核心不可用 / 越过关门阈值）：暂停放量 → 先回滚止血 → 定位 → 热修（**必须同时给复现测试**）→ 48h 内记 ADR
- **P2 一般**：登记 issue（含复现步骤）→ 排期 → 不阻塞发布；同类重复 ≥2 次升级为 P1
- **复盘铁律**：必须产出**防复发动作**（测试 / 护栏 / 流程 / 文档），只写"下次注意"不算复盘

---

## ✍️ 命名约定

| 类型 | 规范 | 示例 |
|---|---|---|
| 变量 | `snake_case` | `user_count` |
| 类 | `PascalCase` | `UserService` |
| 常量 | `UPPER_SNAKE_CASE` | `MAX_RETRY_COUNT` |
| 函数 | `snake_case` | `get_user_by_id` |
| 文件/目录 | `snake_case` | `user_repository.py` |

---

## 🔍 代码审查重点

提交 PR 前自检，检查：

- [ ] 是否违反 API 合同（API_CONTRACT.md）
- [ ] 是否遵循命名规范（上表）
- [ ] 是否添加了必要的注释
- [ ] 是否新增了单元测试
- [ ] 是否更新了相关文档

---

## 🚫 禁止操作

> **红线总表以 [CONTEXT.md](./.github/CONTEXT.md)「禁止事项」为唯一权威来源**（单一事实源，避免两处漂移）。
> 本文件仅补充 Agent 行为层的要求；**与 CONTEXT.md 冲突时，以 CONTEXT.md 为准。**

- ❌ 直接修改 main 分支（见 CONTEXT 红线）
- ❌ 修改已批准的架构（见 CONTEXT 红线）
- ❌ 删除其他 Agent 的代码（需先讨论）
- ❌ 未经批准引入新依赖（见 CONTEXT 红线）
- ❌ 未经批准修改 public API 签名（见 CONTEXT 红线）
- ❌ 未定义指标与关门阈值就放量（见本文件「🚦 灰度前置」）
- ❌ 提交无法回滚的变更、或把多主题混进一个 PR（见本文件「↩️ 回滚」）

---

## ⚙️ 实际工作流（伪代码）

```python
def agent_workflow():
    # 1. 读取共享上下文
    context = read_file(".github/CONTEXT.md")
    guidelines = read_file("AGENT_GUIDELINES.md")
    api_contract = read_file("API_CONTRACT.md")

    # 2. 理解任务
    current_task = parse_context(context)

    # 3. 执行（受约束）
    code = generate_code(
        task=current_task,
        constraints=[guidelines, api_contract]
    )

    # 4. 自我检查
    validate_against(code, guidelines)

    # 5. 提交
    create_pr_with_explanation(code)
```

---

## ⚖️ 不确定时怎么办

1. **保守对待**——不做比做错好
2. 在 PR 中明确标注"不确定项"并提问
3. 等待**人类或主 Agent** 审批后再继续
4. 绝不猜测规则——规则没写就不算数，先问
