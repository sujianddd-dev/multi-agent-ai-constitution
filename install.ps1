# ai-constitution skill — one-line installer for Windows PowerShell
#
#   irm https://raw.githubusercontent.com/sujianddd-dev/multi-agent-ai-constitution/main/install.ps1 | iex
#
# Optional:
#   $env:AI_CONSTITUTION_PROJECT='C:\path\to\project'; irm ... | iex
#   $env:AI_CONSTITUTION_DIR='C:\Users\me\.claude\skills\ai-constitution'; irm ... | iex
#
# Local test:
#   pwsh -File install.ps1 -Source H:\path\to\repo -Dir H:\tmp\ac-test

param(
  [string]$Ref = '',
  [string]$Source = '',
  [string]$Dir = '',
  [string]$Project = '',
  [switch]$Force
)

$ErrorActionPreference = 'Stop'
$Repo = 'sujianddd-dev/multi-agent-ai-constitution'

if (-not $Ref) { $Ref = if ($env:AI_CONSTITUTION_REF) { $env:AI_CONSTITUTION_REF } else { 'main' } }
if (-not $Source) { $Source = $env:AI_CONSTITUTION_SOURCE }
if (-not $Dir) { $Dir = $env:AI_CONSTITUTION_DIR }
if (-not $Project) { $Project = $env:AI_CONSTITUTION_PROJECT }

function Say($message) { Write-Host $message }
function Die($message) { throw "❌ $message" }

$tmp = $null
try {
  if (-not $Source) {
    $tmp = Join-Path $env:TEMP ("ai-constitution-" + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $tmp -Force | Out-Null
    $url = "https://codeload.github.com/$Repo/tar.gz/refs/heads/$Ref"
    $tar = Join-Path $tmp 'src.tar.gz'
    Say "↓ 下载 $url"
    try {
      Invoke-WebRequest -Uri $url -OutFile $tar -UseBasicParsing
    } catch {
      Die "下载失败：$($_.Exception.Message)。可设置代理，或使用 -Source <本地仓库>"
    }
    & tar -xzf $tar -C $tmp
    if ($LASTEXITCODE -ne 0) { Die '解压失败（Windows 10+ 自带 tar 通常可用）' }
    $Source = (Get-ChildItem $tmp -Directory | Select-Object -First 1).FullName
  }

  $skill = Join-Path $Source 'ai-constitution.skill'
  if (-not (Test-Path (Join-Path $skill 'SKILL.md'))) {
    Die "未找到 $skill\SKILL.md（-Source 应指向仓库根目录）"
  }

  if ($Project) {
    $proj = $Project
    if (-not (Test-Path $proj)) { New-Item -ItemType Directory -Path $proj -Force | Out-Null }
    $tpl = Join-Path $skill 'templates'
    $copied = 0
    $skipped = 0
    foreach ($file in (Get-ChildItem $tpl -Recurse -File)) {
      $rel = $file.FullName.Substring($tpl.Length).TrimStart('\')
      $dest = Join-Path $proj $rel
      if ((Test-Path $dest) -and -not $Force) {
        $skipped++
      } else {
        $parent = Split-Path $dest -Parent
        if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        Copy-Item $file.FullName $dest -Force
        $copied++
      }
    }
    Say "✅ 已把宪法模板铺到：$proj"
    if ($Force) {
      Say "   写入/覆盖 $copied 个文件（-Force）"
    } else {
      Say "   新增 $copied 个文件；跳过 $skipped 个已存在文件（未覆盖）"
    }
    Say ''
    Say '下一步：按 README 的「生产环境定制清单」填写占位符，然后初始化 STATE.md。'
    return
  }

  $targets = @()
  if ($Dir) {
    $targets += $Dir
  } else {
    foreach ($base in @('.dsh', '.claude', '.codex', '.cursor')) {
      $basePath = Join-Path $HOME $base
      if (Test-Path $basePath) { $targets += (Join-Path $basePath 'skills\ai-constitution') }
    }
    if ($targets.Count -eq 0) {
      $targets += (Join-Path $HOME '.dsh\skills\ai-constitution')
      Say "ℹ️  未检测到已知 Agent 目录，默认安装到 $($targets[0])"
    }
  }

  Say "→ 安装 ai-constitution skill（$Ref）"
  foreach ($dest in $targets) {
    $parent = Split-Path $dest -Parent
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    if (Test-Path $dest) {
      $bak = "$dest.bak-" + (Get-Date -Format 'yyyyMMdd-HHmmss')
      Move-Item $dest $bak
      Say "   已存在，旧版本备份到 $bak"
    }
    Copy-Item $skill $dest -Recurse -Force
    Say "   ✅ $dest"
  }

  Say ''
  Say '完成。打开你的 Agent，说：'
  Say '  「用 ai-constitution 给这个项目建一套宪法」'
  Say ''
  Say '只想要模板、不装 skill？在项目根目录执行：'
  Say "  `$env:AI_CONSTITUTION_PROJECT='.'; irm https://raw.githubusercontent.com/$Repo/$Ref/install.ps1 | iex"
} finally {
  if ($tmp -and (Test-Path $tmp)) { Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue }
}
