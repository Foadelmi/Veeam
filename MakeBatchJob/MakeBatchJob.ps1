```
# Import the Veeam PowerShell Module
Import-Module "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.PowerShell.dll"

# Connect to Veeam Backup & Replication server
Connect-VBRServer -Server "YourVeeamServer"

# Verify and get the backup repository
$repository = Get-VBRBackupRepository -Name "put repository name here where backups are written"
if ($repository -eq $null) {
    Write-Host "Backup repository 'Backup' not found." -ForegroundColor Red
    exit
}

# Retrieve all VMs from the vCenter server
$vCenterServer = Get-VBRServer -Name "put vcenter ip here"
$vms = Find-VBRViEntity -Server $vCenterServer -VMsAndTemplates

if ($vms -eq $null -or $vms.Count -eq 0) {
    Write-Host "No VMs found on the vCenter server 'put vcenter ip here'." -ForegroundColor Red
    exit
}

foreach ($vm in $vms) {
    # Create a new backup job for each VM
    $jobName = $vm.Name

    # Check if a job with the same name already exists
    $existingJob = Get-VBRJob -Name $jobName -ErrorAction SilentlyContinue
    if ($existingJob) {
        Write-Host "Backup job for VM: $($vm.Name) already exists." -ForegroundColor Yellow
        continue
    }

    # Create a new backup job
    $job = Add-VBRViBackupJob -Name $jobName -BackupRepository $repository -Entity $vm -Description "Backup job for $jobName"

    if ($job -eq $null) {
        Write-Host "Failed to create backup job for VM: $($vm.Name)" -ForegroundColor Red
        continue
    }

    # Set the retention policy (7 restore points)
    $options = Get-VBRJobOptions -Job $job
    $options.BackupStorageOptions.RetentionPolicy = "RestorePoints"
    $options.BackupStorageOptions.RetentionPolicyRestorePoints = 7
    Set-VBRJobOptions -Job $job -Options $options

    # Disable schedule (set to manual)
    Set-VBRJobSchedule -Job $job -DisableSchedule
}

# Disconnect from the Veeam Backup & Replication server
Disconnect-VBRServer

```
