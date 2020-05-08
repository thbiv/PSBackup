---
external help file: PSBackup-help.xml
Module Name: PSBackup
online version:
schema: 2.0.0
---

# Get-PSBackup

## SYNOPSIS
Lists BackupJobs from a BackupJob file.

## SYNTAX

```
Get-PSBackup -Path <String> [<CommonParameters>]
```

## DESCRIPTION
Lists BackupJobs from a BackupJob file.

## EXAMPLES

### EXAMPLE 1
```
Get-PSBackup -Path 'Backupfile.psd1'
```

This example processes a file named Backupfile.psd1 and outputs the BackupJob data to the console.

## PARAMETERS

### -Path
Path and Name of the Powershell Data file to process.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### BackupJob
## NOTES

## RELATED LINKS
