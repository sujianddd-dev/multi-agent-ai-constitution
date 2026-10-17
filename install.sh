#!/usr/bin/env bash
# ai-constitution skill — one-line installer
#
#   curl -fsSL https://raw.githubusercontent.com/sujianddd-dev/multi-agent-ai-constitution/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- --project /path/to/project
#   curl -fsSL .../install.sh | bash -s -- --dir ~/.claude/skills/ai-constitution
#
# 本地测试：AI_CONSTITUTION_SOURCE=/path/to/repo bash install.sh --dir /tmp/ac-test
set -euo pipefail

REPO="sujianddd-dev/multi-agent-ai-constitution"
REF="${AI_CONSTITUTION_REF:-main}"
SOURCE="${AI_CONSTITUTION_SOURCE:-}"
MODE="skill"
TARGET_DIR=""
PROJECT_DIR=""
FORCE=0

say() { printf '%s\n' "$*"; }
die() { printf '❌ %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
ai-constitution skill installer

Usage:
  install.sh                     Install the skill into detected agent skill dirs
  install.sh --dir <path>        Install into one specific skill dir
  install.sh --project [dir]     Copy the constitution templates into a project (default: .)
  install.sh --ref <git-ref>     Use another branch/tag (default: main)
  install.sh --source <path>     Use a local checkout instead of downloading
  install.sh --force             With --project: overwrite files that already exist

Env:
  AI_CONSTITUTION_REF / AI_CONSTITUTION_SOURCE / AI_CONSTITUTION_DIR / AI_CONSTITUTION_PROJECT
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dir)
      [ "$#" -ge 2 ] || die "--dir needs a path"
      TARGET_DIR="$2"
      shift 2
      ;;
    --project)
      MODE="project"
      shift
      if [ "$#" -gt 0 ] && [ "${1#-}" = "$1" ]; then
        PROJECT_DIR="$1"
        shift
      fi
      ;;
    --ref)
      [ "$#" -ge 2 ] || die "--ref needs a value"
      REF="$2"
      shift 2
      ;;
    --source)
      [ "$#" -ge 2 ] || die "--source needs a path"
      SOURCE="$2"
      shift 2
      ;;
    --force | -f)
      FORCE=1
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      die "unknown argument: $1 (try --help)"
      ;;
  esac
done

[ -n "$TARGET_DIR" ] || TARGET_DIR="${AI_CONSTITUTION_DIR:-}"
[ -n "$PROJECT_DIR" ] || PROJECT_DIR="${AI_CONSTITUTION_PROJECT:-}"

# Expand a leading ~ (quoted paths normally skip shell expansion).
case "$TARGET_DIR" in "~/"*) TARGET_DIR="$HOME/${TARGET_DIR#\~/}" ;; esac
case "$PROJECT_DIR" in "~/"*) PROJECT_DIR="$HOME/${PROJECT_DIR#\~/}" ;; esac

# --- resolve source -------------------------------------------------------
tmp=""
if [ -z "$SOURCE" ]; then
  command -v curl >/dev/null 2>&1 || die "curl is required (or pass --source <local-checkout>)"
  command -v tar >/dev/null 2>&1 || die "tar is required"
  tmp="$(mktemp -d)"
  trap '[ -n "${tmp:-}" ] && rm -rf "$tmp"' EXIT
  url="${AI_CONSTITUTION_TARBALL_URL:-https://codeload.github.com/$REPO/tar.gz/refs/heads/$REF}"
  say "↓ 下载 $url"
  if ! curl -fsSL "$url" | tar -xz -C "$tmp"; then
    die "下载失败。国内网络可设置 https_proxy，或改用 --source <本地仓库> / AI_CONSTITUTION_TARBALL_URL"
  fi
  SOURCE="$(find "$tmp" -mindepth 1 -maxdepth 1 -type d -print -quit)"
  [ -n "$SOURCE" ] || die "解压后未找到源码目录"
fi

SKILL_SRC="$SOURCE/ai-constitution.skill"
[ -f "$SKILL_SRC/SKILL.md" ] || die "未找到 $SKILL_SRC/SKILL.md（--source 应指向仓库根目录）"

# --- project mode: copy templates, never overwrite by default -------------
if [ "$MODE" = "project" ]; then
  proj="${PROJECT_DIR:-.}"
  [ -d "$proj" ] || mkdir -p "$proj"
  tpl="$SKILL_SRC/templates"
  [ -d "$tpl" ] || die "未找到模板目录 $tpl"

  copied=0
  skipped=0
  while IFS= read -r -d '' f; do
    rel="${f#"$tpl"/}"
    dest="$proj/$rel"
    if [ -e "$dest" ] && [ "$FORCE" -ne 1 ]; then
      skipped=$((skipped + 1))
    else
      mkdir -p "$(dirname "$dest")"
      cp "$f" "$dest"
      copied=$((copied + 1))
    fi
  done < <(find "$tpl" -type f -print0)

  say "✅ 已把宪法模板铺到：$proj"
  if [ "$FORCE" -eq 1 ]; then
    say "   写入/覆盖 $copied 个文件（--force）"
  else
    say "   新增 $copied 个文件；跳过 $skipped 个已存在文件（未覆盖）"
  fi
  say ""
  say "下一步：按 README 的「生产环境定制清单」填写占位符，然后初始化 STATE.md。"
  exit 0
fi

# --- skill mode: detect agent skill dirs ----------------------------------
targets=()
if [ -n "$TARGET_DIR" ]; then
  targets+=("$TARGET_DIR")
else
  for base in ".dsh" ".claude" ".codex" ".cursor"; do
    if [ -d "$HOME/$base" ]; then
      targets+=("$HOME/$base/skills/ai-constitution")
    fi
  done
  if [ "${#targets[@]}" -eq 0 ]; then
    targets+=("$HOME/.dsh/skills/ai-constitution")
    say "ℹ️  未检测到已知 Agent 目录，默认安装到 ~/.dsh/skills/ai-constitution"
  fi
fi

say "→ 安装 ai-constitution skill（$REF）"
for dest in "${targets[@]}"; do
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    bak="$dest.bak-$(date +%Y%m%d-%H%M%S)"
    mv "$dest" "$bak"
    say "   已存在，旧版本备份到 $bak"
  fi
  cp -R "$SKILL_SRC" "$dest"
  say "   ✅ $dest"
done

say ""
say "完成。打开你的 Agent，说："
say "  「用 ai-constitution 给这个项目建一套宪法」"
say ""
say "只想要模板、不装 skill？在项目根目录执行："
say "  curl -fsSL https://raw.githubusercontent.com/$REPO/$REF/install.sh | bash -s -- --project ."
