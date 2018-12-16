Function Import-PSBackupDataFromFile {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [string]$Path
    )
    Write-Verbose "[Import-PSBackupDataFromFile] Path: $Path"

    If (-not (Test-PSBackupFile -Path $Path)) {
        Throw "[Import-PSBackupDataFromFile] BackupJob File Validation Failed"
    } Else {
        Write-Verbose '[Import-PSBackupDataFromFile] BackupJob File Validation Passed'
        $Params = @{
            Path=$Path
            Verbose=$VerbosePreference
        }
        $ImportedData = Import-PowerShellDataFile @Params
        $Output = @()
        ForEach ($Name in $ImportedData.keys) {
            Write-Verbose "[Import-PSBackupDataFromFile] Importing Job: $Name"
            $Obj = New-Object -TypeName PSBackupBackupJob -ArgumentList $Name,
                                                                $($ImportedData[$Name].Source),
                                                                $($ImportedData[$Name].Destination),
                                                                $($ImportedData[$Name].Parameters),
                                                                $($ImportedData[$Name].LogPath)
            $Output += $Obj
        }
        Write-Output $Output
    }
}