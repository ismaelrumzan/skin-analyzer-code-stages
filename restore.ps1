#Requires -Version 5.1
<#
.SYNOPSIS
  Restore a cooking-show stage into an Eve my-agent project (Windows).

.EXAMPLE
  .\restore.ps1 S03 end
  .\restore.ps1 S02 end -AgentRoot C:\Users\you\Code\my-agent
#>
param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$Stage,

  [Parameter(Position = 1)]
  [ValidateSet("start", "end", "START", "END")]
  [string]$Which = "start",

  [string]$AgentRoot = $env:MY_AGENT_ROOT
)

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot

function Resolve-AgentRoot {
  if ($AgentRoot -and (Test-Path (Join-Path $AgentRoot "agent"))) {
    return (Resolve-Path $AgentRoot).Path
  }
  $sibling = Join-Path $Root "..\my-agent"
  if (Test-Path (Join-Path $sibling "agent")) {
    return (Resolve-Path $sibling).Path
  }
  $mono = Join-Path $Root "..\..\my-agent"
  if (Test-Path (Join-Path $mono "agent")) {
    return (Resolve-Path $mono).Path
  }
  Write-Error @"
Could not find my-agent.
Pass -AgentRoot, set MY_AGENT_ROOT, or clone this repo next to my-agent:

  parent\my-agent
  parent\skin-analyzer-code-stages
"@
}

$stageDirs = Get-ChildItem -Path $Root -Directory -Filter "S0*"
$stageDir = $stageDirs | Where-Object {
  $_.Name -eq $Stage -or $_.Name.StartsWith($Stage)
} | Select-Object -First 1

if (-not $stageDir) {
  Write-Host "Unknown stage: $Stage"
  Write-Host "Stages:" ($stageDirs.Name -join ", ")
  exit 1
}

$whichNorm = $Which.ToLowerInvariant()
$src = Join-Path $stageDir.FullName ($(if ($whichNorm -eq "end") { "END" } else { "START" }))
if (-not (Test-Path $src)) {
  Write-Error "Missing $src"
}

$agent = Resolve-AgentRoot
Write-Host "Restoring $src -> $agent"

# Clear authored capability folders (same as restore.sh)
foreach ($rel in @("agent\tools", "agent\skills", "agent\connections", "agent\subagents")) {
  $p = Join-Path $agent $rel
  if (Test-Path $p) { Remove-Item -Recurse -Force $p }
}
New-Item -ItemType Directory -Force -Path (Join-Path $agent "agent\tools") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $agent "agent\skills") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $agent "agent\subagents") | Out-Null

function Copy-Tree($from, $to) {
  if (-not (Test-Path $from)) { return }
  New-Item -ItemType Directory -Force -Path $to | Out-Null
  Copy-Item -Path (Join-Path $from "*") -Destination $to -Recurse -Force
}

$srcAgent = Join-Path $src "agent"
if (Test-Path $srcAgent) {
  Copy-Tree $srcAgent (Join-Path $agent "agent")
}

$srcLib = Join-Path $src "lib"
$dstLib = Join-Path $agent "lib"
if (Test-Path $srcLib) {
  Copy-Tree $srcLib $dstLib
} else {
  $clinic = Join-Path $dstLib "skin-clinic"
  if (Test-Path $clinic) { Remove-Item -Recurse -Force $clinic }
}

$srcEvals = Join-Path $src "evals"
if (Test-Path $srcEvals) {
  $dstEvals = Join-Path $agent "evals"
  if (Test-Path $dstEvals) { Remove-Item -Recurse -Force $dstEvals }
  Copy-Tree $srcEvals $dstEvals
}

Write-Host "Done. cd `"$agent`" ; npm run typecheck ; npm run dev"
