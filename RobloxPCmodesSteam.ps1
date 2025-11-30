# === CONFIG ===
$pcReg      = "C:\RobloxModeSwitcher\roblox_pc_mode.reg"
$consoleReg = "C:\RobloxModeSwitcher\roblox_console_mode.reg"

$regExe = Join-Path $env:WINDIR "System32\reg.exe"

$global:CurrentRobloxVersion = "<unknown>"

function Get-RobloxExe {
    $versionsRoot = Join-Path $env:LOCALAPPDATA "Roblox\Versions"

    if (-not (Test-Path $versionsRoot)) {
        throw "Roblox versions folder not found at $versionsRoot"
    }

    $latestVersion = Get-ChildItem -Path $versionsRoot -Directory |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not $latestVersion) {
        throw "No version-* directories found under $versionsRoot"
    }

    # Save folder name
    $global:CurrentRobloxVersion = $latestVersion.Name

    $robloxExe = Join-Path $latestVersion.FullName "RobloxPlayerBeta.exe"

    if (-not (Test-Path $robloxExe)) {
        throw "RobloxPlayerBeta.exe not found in $($latestVersion.FullName)"
    }

    return $robloxExe
}

# --- Main flow ---

$robloxPath = Get-RobloxExe

Write-Host "[ModeSwitcher] Detected Roblox version folder: $CurrentRobloxVersion"
Write-Host "[ModeSwitcher] Using Roblox path: $robloxPath"

Write-Host "[ModeSwitcher] Applying PC mode..."
Start-Process -FilePath $regExe -ArgumentList "import `"$pcReg`"" -Verb RunAs -Wait

Write-Host "[ModeSwitcher] Launching Roblox with version $CurrentRobloxVersion..."
$robloxProc = Start-Process -FilePath $robloxPath -PassThru

try {
    Wait-Process -Id $robloxProc.Id
} catch {
    
}

Write-Host "[ModeSwitcher] Restoring console mode..."
Start-Process -FilePath $regExe -ArgumentList "import `"$consoleReg`"" -Verb RunAs -Wait

Write-Host "[ModeSwitcher] Done. Returned to console mode."