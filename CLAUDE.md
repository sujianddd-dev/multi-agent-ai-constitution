# CLAUDE.md

> **本仓库的协作规则只有一份：[AGENTS.md](./AGENTS.md)。**
>
> Claude Code 与 DSH 会读取本文件（DSH 候选顺序为 `AGENTS.md` → `CLAUDE.md`），
> 其它工具读 `AGENTS.md`——两者指向同一份事实源，**此处不重复定义任何规则**。

开工前请依次读：

1. **[STATE.md](./STATE.md) —— 现在到哪了（接手必读，不看它会重做已完成的事）**
2. [AGENTS.md](./AGENTS.md) —— 入口、验收命令与硬红线（30 秒）
3. [README.md](./README.md) —— 仓库总览、使用方式与定制清单
4. [docs/DOCTRINE.md](./docs/DOCTRINE.md) —— 工程信条（协议优先 / 灰度闭环 / 迭代严谨 / 风险护栏）

> 提交任何改动前：走分支 + PR（描述按「交接五问」），并更新 `STATE.md`。
> 验收只看一条命令：`bash scripts/verify.sh`（跑不通不要声称完成）。
