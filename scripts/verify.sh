#!/usr/bin/env bash
# ai-constitution 模板库验收（唯一锚点，与模型 / 工具无关）
#
# 用法：bash scripts/verify.sh
# 退出码：0 = 通过；1 = 存在失败项（逐项打印）
#
# 五项检查：
#   1/5 模板齐全（templates/，含点目录 .github/）
#   2/5 SKILL.md frontmatter 合法（name / description）
#   3/5 必读顺序一致（各入口均把 STATE 置于首位）
#   4/5 仓库内 Markdown 相对链接 0 broken（需 node；缺失则显式跳过）
#   5/5 无个体项目名（本库是通用宪法，不得指代具体项目）
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

fail=0
ok()  { printf '  ✅ %s\n' "$1"; }
bad() { printf '  ❌ %s\n' "$1"; fail=1; }

echo "== 1/5 模板齐全（templates/）=="
TPL="ai-constitution.skill/templates"
for f in AGENTS.md CLAUDE.md README.md STATE.md ARCHITECTURE.md \
         AGENT_GUIDELINES.md API_CONTRACT.md CODING_STANDARDS.md DECISION_LOG.md \
         RISK_PLAYBOOK.md; do
  if [ -s "$TPL/$f" ]; then ok "templates/$f"; else bad "templates/$f 缺失或为空"; fi
done
if [ -s "$TPL/.github/CONTEXT.md" ]; then
  ok "templates/.github/CONTEXT.md"
else
  bad "templates/.github/CONTEXT.md 缺失（模板目录应等于分发后的布局）"
fi
if [ -s "$TPL/.github/PULL_REQUEST_TEMPLATE.md" ]; then
  ok "templates/.github/PULL_REQUEST_TEMPLATE.md"
else
  bad "templates/.github/PULL_REQUEST_TEMPLATE.md 缺失（点目录需单独复制）"
fi

echo "== 2/5 SKILL.md frontmatter =="
SKILL="ai-constitution.skill/SKILL.md"
if [ -s "$SKILL" ] && head -1 "$SKILL" | grep -q '^---$' && grep -qE '^name: ' "$SKILL"; then
  ok "frontmatter 起始 + name"
else
  bad "SKILL.md 缺 frontmatter 或 name"
fi
if grep -qE '^description: ' "$SKILL" 2>/dev/null; then ok "description"; else bad "SKILL.md 缺 description"; fi

echo "== 3/5 必读顺序一致（STATE 置首）=="
for f in README.md AGENTS.md CLAUDE.md STATE.md "$TPL/AGENTS.md" "$TPL/CLAUDE.md" "$TPL/README.md"; do
  if [ -f "$f" ] && grep -q 'STATE' "$f"; then
    ok "$f 提到 STATE"
  else
    bad "$f 未提 STATE（入口必须指向接力棒）"
  fi
done

echo "== 4/5 相对链接 0 broken =="
if command -v node >/dev/null 2>&1; then
  node scripts/check-links.mjs . || fail=1
else
  echo "  ⚠️ 未找到 node，跳过链接检查（请在本地/CI 补跑）"
fi

echo "== 5/5 无个体项目名（通用性）=="
leak="$(grep -rIn -E '虾皮|一键发|Shopee|shopee' --include='*.md' . 2>/dev/null || true)"
if [ -n "$leak" ]; then
  bad "发现个体项目名（本库必须通用）："
  printf '%s\n' "$leak" | sed 's/^/     /'
else
  ok "无个体项目名"
fi

echo
if [ "$fail" -eq 0 ]; then echo "✅ 验收通过（5/5）"; else echo "❌ 验收失败（见上）"; fi
exit "$fail"
