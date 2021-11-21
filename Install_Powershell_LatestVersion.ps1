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

#Website root is Github
$RootUri = "https://github.com"

Write-Host "Getting latest version of Powershell"
$Temp = Invoke-WebRequest -Uri "$RootUri/PowerShell/PowerShell/releases" -UseBasicParsing

#Regex used to find latest version of Powershell
[regex]$Regex = ".*[0-9].[0-9].[0-9]-win-x64.msi"

#Select latest version of powershell
$PSDownloadLink = (($Temp.Links -match $Regex).href | Sort-Object )[-1]

$FileName = $PSDownloadLink.split("/")[-1]

Write-Host "Version $FileName Found"

Write-Host "Downloading latest version Powershell"
Invoke-WebRequest -Uri $($RootUri + $PSDownloadLink) `
    -UseBasicParsing `
    -OutFile:"$env:USERPROFILE\Downloads\$FileName" `
    -ErrorAction Stop

Write-Host "Installing latest version Powershell"
Start-Process -FilePath "msiexec.exe" `
    -ArgumentList "/i `"$env:USERPROFILE\Downloads\$FileName`" /qn /NORESTART" `
    -Wait `
    -ErrorAction Stop