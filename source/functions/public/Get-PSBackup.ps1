Function Get-PSBackup {
    <#
    .EXTERNALHELP PSBackup-help.xml
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