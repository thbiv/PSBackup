---
external help file: PSBackup-help.xml
Module Name: PSBackup
online version:
schema: 2.0.0
---

# Invoke-PSBackup

## SYNOPSIS
Processes BackupJob files to perform backups using Robocopy.

## SYNTAX

```
Invoke-PSBackup [-Path] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Processes BackupJob files to perform backups using Robocopy.

## EXAMPLES

### EXAMPLE 1
```
Invoke-PSBackup -Path Backup.config.psd1
```

This example will run the PSBackup.ps1 script using a configuration file named Backup.config.psd1.
The script will run using the data in the configuration file to run it's backup jobs.

## PARAMETERS

### -Path
Path and file name of the configuration file that will be used to drive the script.
The file is required to be a PSD1 with specific properties inside that the script
knows how to handle.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Does not accept any input from the pipeline
## OUTPUTS

### Does not output anything to the pipeline
## NOTES
PSD1 File Format

Copy the following and paste into a new file with an extension of '.psd1' then edit the properties to your liking.
BackupName is the BackupJob name that you give.
It can be any name you wish.
You can have multiple BackupJobs described but the BackupJob name all need to be unique.

@{
    BackupName = @{
        Source = 'C:\path\to\source'
        Destination = '\\\\server\path\to\destination'
        Parameters = '/MIR /V /FP /NP /NDL /BYTES /R:1 /W:1'
        LogPath = '\\\\path\to\log'
    }
}

## RELATED LINKS
