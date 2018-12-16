Function Invoke-PSBackup {
    <#
    .SYNOPSIS
        Processes BackupJob files to perform backups using Robocopy.
    .DESCRIPTION
        Processes BackupJob files to perform backups using Robocopy.
    .PARAMETER Path
        Path and file name of the configuration file that will be used to drive the script.
        The file is required to be a PSD1 with specific properties inside that the script
        knows how to handle.
    .EXAMPLE
        PS C:\> .\PSBackup.ps1 -Path Backup.config.psd1

        This example will run the PSBackup.ps1 script using a configuration file named Backup.config.psd1.
        The script will run using the data in the configuration file to run it's backup jobs.
    .INPUTS
        Does not accept any input from the pipeline
    .OUTPUTS
        Does not output anything to the pipeline
    .NOTES
        PSD1 File Format

        Copy the following and paste into a new file with an extension of '.psd1' then edit the properties to your liking.
        BackupName is the BackupJob name that you give. It can be any name you wish.
        You can have multiple BackupJobs described but the BackupJob name all need to be unique.

        @{
            BackupName = @{
                Source = 'C:\path\to\source'
                Destination = '\\server\path\to\destination'
                Parameters = '/MIR /V /FP /NP /NDL /BYTES /R:1 /W:1'
                LogPath = '\\path\to\log'
            }
        }
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