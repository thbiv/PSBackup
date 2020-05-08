---
external help file: PSBackup-help.xml
Module Name: PSBackup
online version:
schema: 2.0.0
---

# Test-PSBackupFile

## SYNOPSIS
Tests a PSD1 file against a BackupJob File 'Schema'

## SYNTAX

```
Test-PSBackupFile [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
This is my attempt at checking the syntax of the PSD1 file and making sure it is a valid BackupJob file.
This function will output True or False.
This is a work in progress.

## EXAMPLES

### EXAMPLE 1
```
Test-PSBackupFile -Path BackupJobs.psd1
```

This example will check the BsackupJobs.psd1 for validation against the BackupJob File Schema.

## PARAMETERS

### -Path
The path for the PSD1 file to validate.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean
## NOTES

## RELATED LINKS
