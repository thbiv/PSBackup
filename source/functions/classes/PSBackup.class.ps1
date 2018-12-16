Class PSBackupBackupJob {
    [string]$Name
    [string]$Source
    [string]$Destination
    [string]$Parameters
    [string]$LogPath

    PSBackupBackupJob ([string]$Name, [string]$Source, [string]$Destination, [string]$Parameters, [string]$LogPath) {
        $this.Name = $Name
        $this.Source = $Source
        $this.Destination = $Destination
        $this.Parameters = $Parameters
        $this.LogPath = $LogPath
    }

    [string]ToString(){
        return ("{0}|{1}|{2}|{3}|{4}" -f $this.Name, $this.Source, $this.Destination, $this.Parameters, $this.LogPath)
    }
}