Function Invoke-PSBackup {
    <#
    .EXTERNALHELP PSBackup-help.xml
    #>
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory=$True,Position=0,ParameterSetName='BackupJobFile')]
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [ValidateScript({(Get-ChildItem $_).Extension -eq '.psd1'})]
        [ValidateScript({Test-Path $_})]
        [string]$Path
    )

    If ($PSCmdlet.ParameterSetName -eq 'BackupJobFile') {
        Write-Verbose "[Invoke-PSBackup] From File: $(Resolve-Path -Path $Path)"
        $SequenceName = $((Get-ChildItem -Path $Path).BaseName)
        $Params = @{
            Path = $Path
            Verbose = $VerbosePreference
        }
        $BackupJobs = Import-PSBackupDataFromFile @Params
        Write-Verbose "Start: $(Get-Date)"
        Write-Verbose "[Invoke-PSBackup] Backup Sequence: $SequenceName"
        ForEach ($BackupJob in $BackupJobs) {
            Write-Verbose "[Invoke-PSBackup][$SequenceName] Starting Backup Job: $($BackupJob.Name)"
            $LogFileName = ('Backup_{0}_{1:yyyyMMdd}.log' -f $SequenceName, $(Get-Date))
            $LogFile = Join-Path -Path $($BackupJob.LogPath) -ChildPath $LogFileName
            Write-Verbose "[Invoke-PSBackup][$SequenceName][$($BackupJob.Name)] Source: $($BackupJob.Source)"
            Write-Verbose "[Invoke-PSBackup][$SequenceName][$($BackupJob.Name)] Destination: $($BackupJob.Destination)"
            Write-Verbose "[Invoke-PSBackup][$SequenceName][$($BackupJob.Name)] Parameters: $($BackupJob.Parameters)"
            Write-Verbose "[Invoke-PSBackup][$SequenceName][$($BackupJob.Name)] LogFile: $LogFile"
            [string]$ArgumentList = ('"{0}" "{1}" /LOG+:"{2}" {3}' -f $($BackupJob.Source), $($BackupJob.Destination), $LogFile, $($BackupJob.Parameters))
            If ($PSCmdlet.ShouldProcess("Copying '$($BackupJob.Source)' to '$($BackupJob.Destination)'")) {
                Try {
                    Start-Process -FilePath robocopy.exe -ArgumentList $ArgumentList -NoNewWindow -Wait | Out-Null
                } Catch {
                    $ErrorMessage = $_.Exception.Message
                    Write-Warning $ErrorMessage
                }
            }
        }
    }
}