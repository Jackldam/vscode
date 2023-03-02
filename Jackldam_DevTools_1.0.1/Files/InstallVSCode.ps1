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
    [Parameter(Mandatory)]
    [string]
    $FilePath
)

#Region prerequisites
Write-Host "Install PackageProvider Nuget"
#Install latest version of PackageProvider
Install-PackageProvider -Name "NuGet" `
    -MinimumVersion 2.8.5.201 `
    -Scope CurrentUser `
    -ErrorAction Stop `
    -Force | Out-Null


Write-Host "Install module PackageManagement"
#Install latest version of PackageManagement
Install-Module -Name "PackageManagement" `
    -MinimumVersion 1.4.6 `
    -Scope CurrentUser `
    -AllowClobber `
    -Repository "PSGallery" `
    -ErrorAction Stop `
    -Force
#endregion

#Region setup Visual Code with downloaded file.
$Arguments = @{
    FilePath     = $FilePath
    ArgumentList = "/VERYSILENT /NORESTART /MERGETASKS=addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath,!runcode"
    Wait         = $true
    WindowStyle  = "Hidden"
}

Write-Verbose "Installing $FilePath"
Start-Process @Arguments

#EndRegion

#Region install Visual Code extensions
@(
    #,"monokai.theme-monokai-pro-vscode"
    , "ms-azuretools.vscode-bicep"
    , "vscode-icons-team.vscode-icons"
    , "Gruntfuggly.todo-tree"
    , "kamikillerto.vscode-colorize"
    , "eamodio.gitlens"
    , "ecmel.vscode-html-css"
    , "abusaidm.html-snippets"
    , "ms-vscode.azurecli"
    , "ms-vscode.powershell"
    , "oderwat.indent-rainbow"
    , "msazurermtools.azurerm-vscode-tools"
    , "dotjoshjohnson.xml"
    , "foxundermoon.shell-format"
    , "esbenp.prettier-vscode"
    , "pkief.material-icon-theme"
    , "donjayamanne.githistory"
    , "mhutchie.git-graph"
    , "docsmsft.docs-yaml"
    , "formulahendry.code-runner"
    , "aaron-bond.better-comments"
) | ForEach-Object $_ {
    $Arguments = @{
        FilePath     = "C:\Users\$env:USERNAME\AppData\Local\Programs\Microsoft VS Code\bin\code"
        ArgumentList = "--install-extension `"$_`""
        Wait         = $true
    }
    Write-Verbose "Installing $_"
    Start-Process @Arguments -WindowStyle Hidden
}

#EndRegion

#Region Copy settings.json

$Arguments = @{
    Path        = "$PSScriptRoot\settings.json"
    Destination = "C:\Users\$env:USERNAME\AppData\Roaming\Code\User\"
}

Copy-Item @Arguments

#EndRegion
