# install putty on backup server (where you run this script)
# install putty on backup server (where you run this script)
# install putty on backup server (where you run this script)
# install putty on backup server (where you run this script)
# install putty on backup server (where you run this script)
# install putty on backup server (where you run this script)
# install putty on backup server (where you run this script)
# install putty on backup server (where you run this script)
# Define variables
$remoteUser = "root"
$password = "password"
$remoteFile = "/etc/someDIR/SomeFile.conf"
$localDestinationFolder = "d:\SomeDir"
$servers = @("Server1 IP", "Server2 IP", "Server3 IP")




# Ensure the local destination folder exists
if (-Not (Test-Path -Path $localDestinationFolder)) {
    New-Item -ItemType Directory -Path $localDestinationFolder
}

# Get the current date in YYYYMMDD format
$date = Get-Date -Format "yyyyMMdd"

# Loop through each server and perform the backup
foreach ($server in $servers) {
    # Define the local file name with date and server IP
    $localFileName = "Backup_$($server)_$($date).conf"
    $localFilePath = Join-Path -Path $localDestinationFolder -ChildPath $localFileName

    # Execute the pscp command
   pscp -pw $password root@${server}:"/etc/someDIR/SomeFile.conf" $localFilePath

    # Check if the file was copied successfully
    if (Test-Path -Path $localFilePath) {
        Write-Output "Backup from $server completed successfully: $localFilePath"
	$From = "veeam@domain.org"
	$To = "admin@domain.org"
	$Subject = "$($server) Backed Up SUCCESSFUL"
	$Body = "$($server) daily backup successful. No further action is required"
	$SMTPServer = "SMTP Server IP"
	$SMTPPort = "25"
	Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort

    } else {
        Write-Output "Backup from $server failed."
        	$From = "veeam@Domain.org"
	        $To = "admin@Domain.org"
	        $Subject = "$($server) Backed Up Failed!!!!!!"
	        $Body = "*********************************$($server) daily backup Failed. further action is required***********************"
	        $SMTPServer = "SMTP Server IP"
	        $SMTPPort = "25"
	        Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort
    }
}
