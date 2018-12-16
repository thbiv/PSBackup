Function Test-PSBackupFile {
    <#
    .SYNOPSIS
    Tests a PSD1 file against a BackupJob File 'Schema'

    .DESCRIPTION
    This is my attempt at checking the syntax of the PSD1 file and making sure it is a valid BackupJob file.
    This function will output True or False.
    This is a work in progress.

    .PARAMETER Path
    The path for the PSD1 file to validate.

    .EXAMPLE
    PS C:\> Test-PSBackupFile -Path BackupJobs.psd1

    This example will check the BsackupJobs.psd1 for validation against the BackupJob File Schema.
    #>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param(
        [Parameter(Mandatory=$True)]
        [string]$Path
    )

    Function script:ValidatePsd1 {
        [CmdletBinding()]
        [OutputType([System.Collections.Hashtable])]
        Param (
            [Parameter(Mandatory = $true)]
            [Microsoft.PowerShell.DesiredStateConfiguration.ArgumentToConfigurationDataTransformation()]
            [hashtable] $Data
        )
        return $Data
    }

    $TestErrors = 0
    $Params = @{
        Data = $Path
    }
    $PSD1 = ValidatePsd1 @Params

    If (-not $PSD1) {
        $TestErrors++
        Write-Waring "[Test-PSBackupFile][ValidatePsd1] The BackupJob file has failed the PSD1 syntax check."
    } Else {
        Write-Verbose "[Test-PSBackupFile][ValidatePsd1] The BackupJob file syntax is valid."
    }

    $ValidBackupJobNames = @('_ANY')
    ForEach ($Name in $PSD1.keys) {
        ForEach ($BJName in $ValidBackupJobNames) {
            If ($BJName -eq '_ANY') {
                Write-Verbose "[Test-PSBackupFile][BackupJob Names] '$Name' is a valid BackupJob name"
            } ElseIf ($BJName -eq $Name) {
                Write-Verbose "[Test-PSBackupFile][BackupJob Names] '$Name' is a valid BackupJob name"
            } Else {
                $TestErrors++
                Write-Warning "[Test-PSBackupFile][BackupJob Names] '$Name' is not a valid BackupJob name."
            }
        }
    }

    $ValidBackupJobAttributes = @('Source','Destination','Parameters','LogPath')
    ForEach ($ValidAttribute in $ValidBackupJobAttributes) {
        ForEach ($Name in $PSD1.keys) {
            If ($PSD1[$Name].keys -contains $ValidAttribute) {
                Write-Verbose "[Test-PSBackupFile][BackupJobAttributes] '$ValidAttribute' is present in BackupJob '$Name'"
            } Else {
                $TestErrors++
                Write-Warning "[Test-PSBackupFile][BackupJobAttributes] '$ValidAttribute' is not present in BackupJob '$Name'"
            }
        }
    }


    $RequiredBackupJobAttributeCount = 4
    ForEach ($Name in $PSD1.keys) {
        If ($PSD1[$Name].keys.count -lt $RequiredBackupJobAttributeCount) {
            $TestErrors++
            Write-Warning "[Test-PSBackupFile][BackupJobAttributeCount] BackupJob: '$Name' does not have enough attributes. '$RequiredBackupJobAttributeCount' is required."
        } ElseIf ($PSD1[$Name].keys.count -gt $RequiredBackupJobAttributeCount) {
            $TestErrors++
            Write-Warning "[Test-PSBackupFile][BackupJobAttributeCount] BackupJob: '$Name' has too many attributes. '$RequiredBackupJobAttributeCount' is required."
        } ElseIf ($PSD1[$Name].keys.count -eq $RequiredBackupJobAttributeCount) {
            Write-Verbose "[Test-PSBackupFile][BackupJobAttributeCount] BackupJob: '$Name' has a valid number of attributes with '$RequiredBackupJobAttributeCount'."
        }
    }

    ForEach ($Name in $PSD1.keys) {
        ForEach ($Attribute in $PSD1[$Name].keys) {
            If ($PSD1[$Name][$Attribute].keys) {
                $TestErrors++
                Write-Warning "[Test-PSBackupFile][NestingLimit] Cannot exceed Nesting Limits: BackupJob: '$Name' Attribute: '$Attribute' cannot be a hashtable."
            } Else {
                Write-Verbose "[Test-PSBackupFile][NestingLimit] BackupJob: '$Name' Attribute: '$Attribute' is correct."
            }
        }
    }



    If ($TestErrors -ne 0) {
        Write-Warning "[Test-PSBackupFile] BackJob Syntax Errors Found: '$TestErrors'"
        Return $False
    } Else {Return $True}
}