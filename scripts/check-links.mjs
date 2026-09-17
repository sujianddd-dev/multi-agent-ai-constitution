#!/usr/bin/env node
/**
 * 相对链接检查：把仓库内所有 Markdown 里的 `./xxx` / `../xxx` 相对链接
 * 按其所在文件的目录解析，报告不可达目标。
 *
 * 用法：node scripts/check-links.mjs [根目录]
 * 退出码：0 = 全部可达；1 = 存在 broken（同时打印清单）
 */
import { readFileSync, readdirSync, existsSync, statSync } from 'node:fs'
import { join, dirname, resolve, relative } from 'node:path'

const ROOT = resolve(process.argv[2] ?? '.')
const SKIP_DIRS = new Set(['.git', 'node_modules', '.dsh-vision-toolkit'])

/** 递归收集 Markdown 文件。 */
function collectMarkdown(dir) {
  const out = []
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (entry.isDirectory()) {
      if (SKIP_DIRS.has(entry.name)) continue
      out.push(...collectMarkdown(join(dir, entry.name)))
    } else if (entry.name.endsWith('.md')) {
      out.push(join(dir, entry.name))
    }
  }
  return out
}

// 匹配 ](./x) ](../x) ](.github/x) 形式的相对链接；忽略 http(s)、mailto、纯锚点
const LINK_RE = /\]\(((?:\.\.?\/)[^)\s]*)\)/g

const files = collectMarkdown(ROOT)
let checked = 0
const broken = []

for (const file of files) {
  const text = readFileSync(file, 'utf8')
  for (const match of text.matchAll(LINK_RE)) {
    const raw = match[1]
    const target = raw.split('#')[0] // 去掉锚点
    if (target === '' || target === './' || target === '../') continue
    checked++
    const abs = resolve(dirname(file), decodeURIComponent(target))
    if (!existsSync(abs)) {
      broken.push({ from: relative(ROOT, file), link: raw })
    }
  }
}

for (const b of broken) console.log(`  ❌ ${b.from} → ${b.link}`)
console.log(`  ${broken.length === 0 ? '✅' : '⚠️'} 已检查 ${checked} 条相对链接（文件 ${files.length} 个），broken = ${broken.length}`)
process.exit(broken.length === 0 ? 0 : 1)
