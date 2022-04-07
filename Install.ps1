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

#Requires -RunAsAdministrator

Write-Verbose "Installing GIT"
. ".\Install_GIT.ps1"

Write-Verbose "Installing GIT"
. ".\Install_Powershell_LatestVersion.ps1"

Write-Verbose "Installing VSCode"
. ".\Install_Microsoft_VS_Code.ps1"