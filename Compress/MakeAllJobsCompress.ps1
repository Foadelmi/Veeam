Import-Module "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.PowerShell.dll"
Connect-VBRServer -Server "YourVeeamServer"
Get-VBRJob | ForEach-Object { $options = Get-VBRJobOptions -Job $_; $options.BackupStorageOptions.CompressionLevel = 6; Set-VBRJobOptions -Job $_ -Options $options }
