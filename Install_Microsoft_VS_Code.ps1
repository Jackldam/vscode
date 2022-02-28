<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
[CmdletBinding()]
param (
    # Parameter help description
    [Parameter(Position = 0, ParameterSetName = "SetupFile")]
    [switch][bool]
    $KeepSetupFile,
    # Parameter help description
    [Parameter(Position = 1, ParameterSetName = "SetupFile")]
    [string]
    $FilePath = ".\VSCodeUserSetup-x64-Latest.exe"
)

#Region Start Variables

#No visual output download bar.
$ProgressPreference = 'SilentlyContinue'
$SetupFile = $FilePath

#EndRegion

#Region prerequisites
try {
    Write-Host "Install PackageProvider Nuget"
    #Install latest version of PackageProvider
    Install-PackageProvider -Name "NuGet" `
        -MinimumVersion 2.8.5.201 `
        -Force `
        -ErrorAction Stop | Out-Null
}
catch {
    $_
    exit
}

try {
    Write-Host "Install module PackageManagement"
    #Install latest version of PackageManagement
    Install-Module -Name "PackageManagement" `
        -MinimumVersion 1.4.6 `
        -Scope CurrentUser `
        -AllowClobber `
        -Repository "PSGallery" `
        -Force `
        -ErrorAction Stop
}
catch {
    $_
    exit
}

#EndRegion

#Region download latest version of Visual Code

try {
    if (Test-Path -Path $SetupFile) {
        if ($Latest) {
            Write-Host "Downloading latest version VSCode"

            Invoke-WebRequest -Uri "https://aka.ms/win32-x64-user-stable" `
                -OutFile:$SetupFile `
                -ErrorAction Stop
        }
    }
    else {
        Write-Host "Downloading latest version VSCode"

        Invoke-WebRequest -Uri "https://aka.ms/win32-x64-user-stable" `
            -OutFile:$SetupFile `
            -ErrorAction Stop
    }
}
catch {
    $_
    exit
}

#EndRegion

#Region setup Visual Code with downloaded file.
$Arguments = @{
    FilePath     = $SetupFile
    ArgumentList = "/VERYSILENT /NORESTART /MERGETASKS=addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath,!runcode"
    Wait         = $true
    WindowStyle  = "Hidden"
}

Write-Verbose "Installing $SetupFile"
Start-Process @Arguments

#EndRegion

#Region install Visual Code extensions
@(
    #"monokai.theme-monokai-pro-vscode",
    "vscode-icons-team.vscode-icons",
    "Gruntfuggly.todo-tree",
    "kamikillerto.vscode-colorize",
    "eamodio.gitlens",
    "ecmel.vscode-html-css",
    "abusaidm.html-snippets",
    "ms-vscode.azurecli",
    "ms-vscode.powershell",
    "oderwat.indent-rainbow",
    "msazurermtools.azurerm-vscode-tools",
    "dotjoshjohnson.xml",
    "foxundermoon.shell-format",
    "esbenp.prettier-vscode",
    "pkief.material-icon-theme",
    "donjayamanne.githistory",
    "mhutchie.git-graph",
    "docsmsft.docs-yaml",
    "formulahendry.code-runner",
    "aaron-bond.better-comments"
) | ForEach-Object $_ {
    $Arguments = @{
        FilePath     = "C:\Users\$env:USERNAME\AppData\Local\Programs\Microsoft VS Code\bin\code"
        ArgumentList = "--install-extension `"$_`""
        Wait         = $true
    }
    Write-Verbose "Installing $_"
    Start-Process @Arguments
}

#EndRegion

#Region Copy settings.json

$Arguments = @{
    Path        = "$PSScriptRoot\settings.json"
    Destination = "C:\Users\$env:USERNAME\AppData\Roaming\Code\User\"
}

Copy-Item @Arguments

#EndRegion

#delete setupfile [Optional]
if (-not ($KeepSetupFile)) {
    #Remove Setup File.
    Remove-Item -Path:$SetupFile -Force
}

Write-Verbose "Installing GIT"
. ".\Install_GIT.ps1"

Write-Verbose "Installing GIT"
. ".\Install_Powershell_LatestVersion.ps1"
