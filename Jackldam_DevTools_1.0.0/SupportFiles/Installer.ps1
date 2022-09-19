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

#*Install Git
Show-InstallationProgress -StatusMessage "Installing Git"
#region

$Params = @{
    Path        = "$AppTempFolder\Git.exe"
    Parameters  = "/VERYSILENT /NORESTART /MERGETASKS=ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh,autoupdate"
    WindowStyle = " Hidden"
}
Execute-Process @Params

#endregion

#* Install Powershell 7
Show-InstallationProgress -StatusMessage "Installing Powershell 7"
#region

$Params = @{
    Action     = "Install"
    Path       = "$AppTempFolder\PowerShell-7.msi"
    Parameters = "/qn /NORESTART"
}

Execute-MSI @Params

#endregion

#* Install VSCode
Show-InstallationProgress -StatusMessage "Installing VSCode"
#region

$Params = @{
    UserName   = "$($LoggedOnUserSessions.NTAccount)"
    Path       = "powershell.exe"
    Parameters = "-ExecutionPolicy Bypass -WindowStyle Hidden -file $AppTempFolder\InstallVSCode.ps1 -FilePath `"$AppTempFolder\VSCodeUserSetup-x64.exe`""
    RunLevel   = "LeastPrivilege"
    Wait       = $true
}

Execute-ProcessAsUser @Params



#endregion