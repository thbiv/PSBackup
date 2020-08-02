# PSBackup

![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/PSBackup)
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/PSBackup)
![PowerShell Gallery](https://img.shields.io/powershellgallery/p/PSBackup)

![GitHub](https://img.shields.io/github/license/thbiv/PSBackup)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/thbiv/PSBackup)

---

#### Table of Contents

-   [Synopsis](#Synopsis)
-   [Commands](#Commands)
-   [Installing PSBackup](#Installing-PSBackup)
-   [PSBackupFile](#PSBackupFile)
-   [Usage](#Usage)
-   [Licensing](#Licensing)
-   [Release Notes](#Release-Notes)

---

## Synopsis

PSBackup uses PSD1 files to describe BackupJobs to be performed. Robocopy is the unility that performs the file copy. Multiple BackupJobs can be included in a single PSD1 file. PSBackup will execute all jobs in the file.

---

## Commands

[Get-PSBackup](docs\Get-PSBackup.md)

Given a properly formated PSD1 file, this command will process and output job details that it finds.

[Invoke-PSBackup](docs\Invoke-PSBackup.md)

This command takes a PSD1 file and executes its BackupJobs.

[Test-PSBackupFIle](docs\Test-PSBackupFile.md)

This command takes a PSD1 file and performs checks and tests to determine if the file is properly formated to be executed. Returns True or False.

---

## Installing PSBackup

```Powershell
Install-Module -Name PSBackup
```

---

## PSBackupFile

PSBackup uses Powershell Data Files (PSD1) to keep BackupJobs. PSD1 files are essentially nested hash tables.

A BackupJob consists of 5 parts: Job Name, Source path, Destination path, job parameters, Log path.

-   Job Name - The job name sinply gives the job a name. Please make it something descriptive. The job name must be unique within the file.
-   Source - The source path to the data you wish to be backed up/copied.
-   Destination - The destination path you wish to copy the data to.
-   Parameters - This can be any parameters for robocopy you wish to use except for /LOG
-   LogPath - Path to the folder where you would like the log for the BackupJob to be saved.

```Powershell
@{
    <JobName> = @{
        Source = 'C:\path\to\source'
        Destination = '\\path\to\destination'
        Parameters = '<robocopy parameters>'
        LogPath = '\\path\to\log\folder'
    }
}
```

Here is an example of a backup file

```Powershell
@{
    Documents = @{
        Source = 'C:\Users\thbiv\Documents'
        Destination = 'F:\Backups\Backup_User\Documents'
        Parameters = '/MIR /V /FP /NP /NDL /BYTES /R:1 /W:1'
        LogPath = 'F:\Backups\Logs'
    }

    Desktop = @{
        Source = 'C:\Users\thbiv\Desktop'
        Destination = 'F:\Backups\Backup_User\Desktop'
        Parameters = '/MIR /V /FP /NP /NDL /BYTES /R:1 /W:1'
        LogPath = 'F:\Backups\Logs'
    }

    VSCodeData = @{
        Source = 'C:\Users\thbiv\.vscode'
        Destination = 'F:\Backups\Backup_User\.vscode'
        Parameters = '/MIR /V /FP /NP /NDL /BYTES /R:1 /W:1'
        LogPath = 'F:\Backups\Logs'
    }

    SSHData = @{
        Source = 'C:\Users\thbiv\.ssh'
        Destination = 'F:\Backups\Backup_User\.ssh'
        Parameters = '/MIR /V /FP /NP /NDL /BYTES /R:1 /W:1'
        LogPath = 'F:\Backups\Logs'
    }
}
```

---

## Usage

While putting together the BackupJob file, you can use ```Test-PSBackupFile``` to test the file for validity.

```Powershell
Test-PSBackupFile -Path 'BackupFile.psd1'
```

The command will output warming messages for anything it finds wrong. When you are satisfied with the backup jobs you wish to perform, you may use ```Get-PSBackup``` to display details on the BackupJobs in the file.

```Powershell
Get-PSBackup -Path 'BackupFile.psd1'
```

To perform the jobs that are described in a backup file, use ```Invoke-PSBackup```. You can use the ```-Verbose``` parameter to see what the command is doing.

```Powershell
Invoke-PSBackup -Path 'BackupFile.psd1' -Verbose
```

---

## Licensing

PSBackup is licensed under the [MIT License](LICENSE)

---

## Release Notes

Please refer to [Release Notes](Release-Notes.md)
