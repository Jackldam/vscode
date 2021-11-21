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

)


#No visual output download bar.
$ProgressPreference = 'SilentlyContinue'

#Function to get latest version of Git
function Get-LatestGitVersion {
    $i = Invoke-WebRequest -Uri:"https://git-scm.com/download/win" -UseBasicParsing
    $i = ($i.Links -match "64-bit Git for Windows Setup").href
    $i
}

#Define Setupfile path location in Variable.
$SetupFile = "$env:TEMP\Setup.exe"
 
#Download latest version of Visual Code
Write-Verbose "Downloading"
Invoke-WebRequest -Uri:"$(Get-LatestGitVersion)" -OutFile:$SetupFile
 
#Setup Visual code with downloaded file.
$Arguments = @{
    FilePath     = $SetupFile
    ArgumentList = "/VERYSILENT /NORESTART /MERGETASKS=ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh,autoupdate"
    Wait         = $true
    WindowStyle  = "Hidden"
}
Write-Verbose "Installing $($Arguments.FilePath)"
Start-Process @Arguments
 
#Remove Setup File.
Remove-Item -Path:$SetupFile -Force