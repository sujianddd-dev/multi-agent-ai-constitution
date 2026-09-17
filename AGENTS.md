# AGENTS.md — 本仓库的 Agent 入口（ai-constitution 模板与 skill 库）

> 本文件遵循 [AGENTS.md 开放标准](https://agents.md/)：任何 Agent 在本仓库动手前先读这里。
> ⚠️ **别与 `ai-constitution.skill/templates/AGENTS.md` 混淆**：本文件是「**本仓库自己的入口**」，那份是「**分发给其他项目的模板**」。

---

## ⚡ 30 秒速览

- **仓库性质**：通用「多 Agent AI 宪法」的**模板 + skill**（MIT 公开、对外分发）；**本仓库没有产品代码**
- **产物**：一套可复制到任意项目的文档集（`ai-constitution.skill/templates/`）+ 生成流程（`SKILL.md`）
- **唯一事实源**：仓库内文档（本地记忆只能当加速器，**不得当交接依据**）
- **默认动作**：先读 → 动手 → 提 PR（交接五问）→ 等人类 review
- 🔥 **接手第一件事：读 [STATE.md](./STATE.md)**（"现在到哪了"，不看它会重做已完成的事）

---

## 📚 必读顺序

| 顺序 | 文档 | 时间 | 作用 |
|---|---|---|---|
| 🔥 0 | [STATE.md](./STATE.md) | 1 分钟 | **接力棒**：当前任务 / 进度光标 / 下一步 / 阻塞（接手第一读） |
| 1 | [README.md](./README.md) | 3 分钟 | 仓库总览、使用方式、生产环境定制清单、设计思想 |
| 2 | [docs/WHY.md](./docs/WHY.md) | 5 分钟 | 设计依据、两种解法对比、边界与代价（诚实说明） |
| 3 | [docs/DOCTRINE.md](./docs/DOCTRINE.md) | 5 分钟 | **工程信条**：协议优先 / 灰度闭环 / 迭代严谨 / 风险护栏 |
| 4 | [docs/ENTRY-POINTS.md](./docs/ENTRY-POINTS.md) | 3 分钟 | 各 Agent 工具的入口约定与全局协议层配置 |
| 5 | [ai-constitution.skill/SKILL.md](./ai-constitution.skill/SKILL.md) | 3 分钟 | skill 定义与"生成一套宪法"的流程 |

> ⚠️ 不读完就开始改 = 违反本仓库规则。

---

## 🔧 验收（唯一锚点，与模型 / 工具无关）

```bash
bash scripts/verify.sh
```

**通过标准**（脚本逐项检查，任一失败即不通过）：

1. `templates/` 模板齐全且非空（含点目录 `.github/PULL_REQUEST_TEMPLATE.md`）
2. `SKILL.md` frontmatter 含 `name` 与 `description`
3. 必读顺序在各入口一致（均把 `STATE.md` 置于首位）
4. 仓库内 Markdown 的**相对链接 0 broken**
5. **不出现个体项目名**——本仓库是通用宪法，不得指代任何具体项目

> 换模型 / 换 Agent 后，**只认这条命令的结果**；跑不通就不要声称完成。

---

## 📤 PR 要求

- **走分支 + PR，禁止直推 `main`**
- 描述按 [`.github/PULL_REQUEST_TEMPLATE.md`](./.github/PULL_REQUEST_TEMPLATE.md) 的「**交接五问**」逐节填写（依据 / 改了什么 / 怎么验证 / 遗留什么 / 下一步给谁）；不适用的写"无"，**不要删节**
- **必须更新 [STATE.md](./STATE.md)**——未更新的 PR 视为本轮未完成
- 本仓库是**公开库**：PR 描述 / 评论 / 截图 / 日志中**不得出现经营数据、客户信息、私有仓库地址**

---

## 🚫 硬红线

- ❌ 不在模板里写死任何**个体项目**的信息（业务数据、客户、店铺、私有仓库地址）——通用性是本仓库的第一价值
- ❌ 不改动 `LICENSE`（MIT）；`CHANGELOG.md` 已发布的既有条目**只追加不修改**
- ❌ 不删除已合并的决策记录（决策日志只追加）
- ❌ 不破坏模板的**向后兼容**：`templates/` 的既有章节语义只能增量补充，不能静默改写（会污染已采用它的项目）
