Function Get-PSBackup {
    <#
    .SYNOPSIS
    Lists BackupJobs from a BackupJob file.

    .DESCRIPTION
    Lists BackupJobs from a BackupJob file.

    .PARAMETER Path
    Path and Name of the Powershell Data file to process.

    .EXAMPLE
    PS C:\> Get-PSBackup -Path 'Backupfile.psd1'

    This example processes a file named Backupfile.psd1 and outputs the BackupJob data to the console.

    .INPUTS
    System.String

    .OUTPUTS
    BackupJob
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName='BackupJobFile')]
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [ValidateScript({(Get-ChildItem -Path $_).Extension -eq '.psd1'})]
        [ValidateScript({Test-Path $_})]
        [string]$Path
    )

    If ($PSCmdlet.ParameterSetName -eq 'BackupJobFile') {
        Write-Verbose "[Get-PSBackup] From File: $(Resolve-Path -Path $Path)"
        Write-Verbose "[Get-PSBackup] Calling 'Import-PSBackupDataFromFile'"
        $Params = @{
            Path = $Path
            Verbose = $VerbosePreference
        }
        $Output = Import-PSBackupDataFromFile @Params
    }
    Write-Output $Output
}