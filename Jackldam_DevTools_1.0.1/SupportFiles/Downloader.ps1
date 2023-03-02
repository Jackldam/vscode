<#
.SYNOPSIS
    A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
[CmdletBinding()]
param ()

$ProgressPreference = "SilentlyContinue"

#*Download Git
Show-InstallationProgress -StatusMessage "Downloading Git"
#region
function Get-LatestGitVersion {
    $i = Invoke-WebRequest -Uri:"https://git-scm.com/download/win" -UseBasicParsing
    $i = ($i.Links -match "64-bit Git for Windows Setup").href
    $i
}

Get-OnlineFile -Uri $(Get-LatestGitVersion) `
    -Destination "$AppTempFolder\Git.exe"
#endregion

#* Download Powershell 7
Show-InstallationProgress -StatusMessage "Downloading Powershell 7"
#region

function Get-LatestPwshVersion {
    $i = Invoke-WebRequest -Uri:"https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2" -UseBasicParsing
    $i = ($i.Links -match "PowerShell-*.*.*-win-x64.msi").href
    $i
}

Get-OnlineFile -Uri $(Get-LatestPwshVersion) `
    -Destination "$AppTempFolder\PowerShell-7.msi"
#endregion

#* Download VSCode
Show-InstallationProgress -StatusMessage "Downloading VSCode"
#region

Get-OnlineFile -Uri "https://aka.ms/win32-x64-user-stable" `
    -Destination "$AppTempFolder\VSCodeUserSetup-x64.exe"

#endregion