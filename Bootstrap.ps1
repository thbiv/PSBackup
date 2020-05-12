[CmdletBinding()]
Param (
    [ValidateSet('.','Testing')]
    [string]$BuildTask = '.',

    [switch]$BumpMajorVersion,

    [switch]$BumpMinorVersion
)

If (-not(Get-PackageProvider -Name Nuget)) {
    Install-PackageProvider -Name Nuget -Force -Scope CurrentUser
}

[xml]$ModuleConfig = Get-Content Module.Config.xml
$RequiredModules = $ModuleConfig.requires.modules.module
ForEach ($Module in $RequiredModules) {
    If (-not(Get-Module -Name $Module -ListAvailable)) {
        $Params = @{
            Name = $($Module.name)
            Scope = 'CurrentUser'
            Force = $True
        }
        If ($Null -ne $Module.version) {$Params += @{RequiredVersion = $($Module.version)}}
        If ($Null -ne $Module.repository) {$Params += @{Repository = $($Module.repository)}}
        Install-Module @Params
    }
    If (-not(Get-Module -Name $Module)) {
        Import-Module -Name $Module
    }
}

$Params = @{
    Task = $BuildTask
}
If ($BumpMajorVersion) {
    $Params.Add('BumpMajorVersion',$True)
}
If ($BumpMinorVersion) {
    $Params.Add('BumpMinorVersion',$True)
}
Invoke-Build @Params