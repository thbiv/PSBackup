$Script:ModuleName = Split-Path -Path $PSScriptRoot -Leaf
$Script:SourceRoot = "$BuildRoot\source"
$Script:DocsRoot = "$BuildRoot\docs"
$Script:OutputRoot = "$BuildRoot\_output"
$Script:TestResultsRoot = "$BuildRoot\_testresults"
$Script:TestsRoot = "$BuildRoot\tests"
$Script:FileHashRoot = "$BuildRoot\_filehash"
$Script:Source_PSD1 = "$SourceRoot\$ModuleName.psd1"
$Script:Dest_PSD1 = "$OutputRoot\$ModuleName\$ModuleName.psd1"
$Script:Dest_PSM1 = "$OutputRoot\$ModuleName\$ModuleName.psm1"
$Script:Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@

# Synopsis: Empty the _output and _testresults folders
Task CleanAndPrep {
    If (Test-Path -Path $OutputRoot) {
        Get-ChildItem -Path $OutputRoot -Recurse | Remove-Item -Force -Recurse
    } Else {
        New-Item -Path $OutputRoot -ItemType Directory -Force | Out-Null
    }
    New-Item -Path "$OutputRoot\$ModuleName" -ItemType Directory | Out-Null
    If (Test-Path -Path $TestResultsRoot) {
        Get-ChildItem -Path $TestResultsRoot -Recurse | Remove-Item -Force -Recurse
    } Else {
        New-Item -Path $TestResultsRoot -ItemType Directory -Force | Out-Null
    }
}

Task CompileModuleFile {
# Synopsis: Compile the module file (PSM1)
    If (Test-Path -Path "$SourceRoot\functions\classes") {
        Write-Host "Compiling Classes"
        Get-ChildItem -Path "$SourceRoot\functions\classes" -file | ForEach-Object {
            $_ | Get-Content | Add-Content -Path $Dest_PSM1
        }
    } 

    If (Test-Path -Path "$SourceRoot\functions\private") {
        Write-Host "Compiling Private Functions"
        Get-ChildItem -Path "$SourceRoot\functions\private" -file | ForEach-Object {
            $_ | Get-Content | Add-Content -Path $Dest_PSM1
        }
    }

    If (Test-Path -Path "$SourceRoot\functions\public") {
        Write-Host "Compiling Public Functions"
        Get-ChildItem -Path "$SourceRoot\functions\public" -File | ForEach-Object {
            $_ | Get-Content | Add-Content -Path  $Dest_PSM1
        }
    }
}

# Synopsis: Compile the manifest file (PSD1)
Task CompileManifestFile {
    Write-Host "Copying Module Manifest"
    Copy-Item -Path $Source_PSD1 -Destination $Dest_PSD1
}

# Synopsis: Compile/Copy formats file (PS1XML)
Task CompileFormats {
    If (Test-Path -Path "$SourceRoot\$ModuleName.format.ps1xml") {
        Write-Host "Copying Formats File"
        Copy-Item -Path "$SourceRoot\$ModuleName.format.ps1xml" -Destination "$OutputRoot\$ModuleName\$ModuleName.format.ps1xml"
    }
}

# Synopsis: Compile the help MAML file from Markdown documents
Task CompileHelp {
    If (Test-Path -Path $DocsRoot) {
        Write-Host 'Creating External Help'
        New-ExternalHelp -Path $DocsRoot -OutputPath "$OutputRoot\$ModuleName" -Force
        If (Test-Path -Path "$DocsRoot\about_help") {
            Write-Host 'Creating About Help file(s)'
            New-ExternalHelp -Path "$DocsRoot\about_help" -OutputPath "$OutputRoot\$ModuleName\en-US" -Force
        }
    }
}

Task Build CompileModuleFile, CompileManifestFile, CompileFormats, CompileHelp

# Synopsis: Test the Project
Task Test {
    $PesterBasic = @{
        Script = @{Path="$TestsRoot\BasicModule.tests.ps1";Parameters=@{Path=$OutputRoot;ProjectName=$ModuleName}}
        PassThru = $True
    }
    $Results = Invoke-Pester @PesterBasic
    $Manifest = Import-PowerShellDataFile -Path "$SourceRoot\$ModuleName.psd1"
    $FileName = "Results_{0}_{1}" -f $ModuleName, $($Manifest.ModuleVersion)
    $Results | Export-Clixml -Path "$TestResultsRoot\$FileName.xml"
    Write-Host "Processing Pester Results"
    $PreContent = @()
    $PreContent += "Total Count: $($Results.TotalCount)"
    $PreContent += "Passed Count: $($Results.PassedCount)"
    $PreContent += "Failed Count: $($Results.FailedCount)"
    $PreContent += "Duration: $($Results.Time)"
    
    $HTML = $($Results.TestResult | ConvertTo-Html -Property Describe,Context,Name,Result,Time,FailureMessage,StackTrace,ErrorRecord -Head $Header -PreContent $($PreContent -join '<BR>') | Out-String)
    $HTML | Out-File -FilePath "$TestResultsRoot\$FileName.html"
    If ($Results.FailedCount -ne 0) {Throw "One or more Basic Module Tests Failed"}
    Else {Write-Host "All tests have passed...Build can continue."}
}

# Synopsis: Produce File Hash for all output files
Task Hash {
    $Manifest = Import-PowerShellDataFile -Path $Dest_PSD1
    $Files = Get-ChildItem -Path "$OutputRoot\$ModuleName" -File -Recurse
    $HashOutput = @()
    ForEach ($File in $Files) {
        $HashOutput += Get-FileHash -Path $File.fullname
    }
    $HashExportFile = "ModuleFiles_Hash_$ModuleName.$($Manifest.ModuleVersion).xml"
    $HashOutput | Export-Clixml -Path "$FileHashRoot\$HashExportFile"
}

# Synopsis: Publish to repository
Task PublishModule {
    Write-Host "Publishing Module to 'PSLocalGallery'"
    $Params = @{
        Path = "$OutputRoot\$ModuleName"
        Repository = 'PSLocalGallery'
        Force = $True
    }
    Publish-Module @Params
}

Task PublishOnlineHelp {

}

Task Deploy PublishModule, PublishOnlineHelp

Task . CleanAndPrep, Build, Test, Hash, Deploy
Task Testing CleanAndPrep, Build, Test