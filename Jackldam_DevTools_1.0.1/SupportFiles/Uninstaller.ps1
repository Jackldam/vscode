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
Show-InstallationProgress -StatusMessage "Uninstalling Git"
#region

. "$env:ProgramFiles\Git\unins000.exe" /VERYSILENT /NORESTART

#endregion

#* Install Powershell 7
Show-InstallationProgress -StatusMessage "Uninstalling Powershell 7"
#region

$Params = @{
    Action     = "Uninstall"
    Path       = "$AppTempFolder\PowerShell-7.msi"
    Parameters = "/qn /NORESTART"
}

Execute-MSI @Params

#endregion

#* Install VSCode
Show-InstallationProgress -StatusMessage "Uninstalling VSCode"
#region

Get-ChildItem -Path "C:\Users" | ForEach-Object {

    

    $Params = @{
        UserName   = "$($LoggedOnUserSessions.NTAccount)"
        Path       = "C:\Users\$($LoggedOnUserSessions.UserName)\AppData\Local\Programs\Microsoft VS Code\unins000.exe"
        Parameters = "/VERYSILENT"
        RunLevel   = "LeastPrivilege"
        Wait       = $true
    }
    
    Execute-ProcessAsUser @Params

    if (Test-Path "$($_.FullName)\.vscode") {
        Remove-Item "$($_.FullName)\.vscode" -Recurse -Force
    }

    if (Test-Path "$($_.FullName)\AppData\Roaming\Code") {
        Remove-Item "$($_.FullName)\AppData\Roaming\Code" -Recurse -Force
    }
}
#endregion