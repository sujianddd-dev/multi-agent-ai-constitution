# Agent 工作准则（AGENT_GUIDELINES）

> 本文件是所有 Agent 的**行为规范**。不遵守 = 违反宪法。

---

## 🔄 工作流程

1. 读取 `README.md`（含治理结构）+ `.github/CONTEXT.md`
2. 理解当前阶段和目标
3. 阅读相关的规范文件（AGENT_GUIDELINES / API_CONTRACT / CODING_STANDARDS）
4. 在指定目录执行任务
5. 提交 PR 附上说明
6. 等待**人类或主 Agent** 审批（角色与权限见 README「治理结构」）

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
