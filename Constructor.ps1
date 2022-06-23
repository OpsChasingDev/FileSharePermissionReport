# constructor script intended to be invoked to other machines for processing their share data permissions

# copy all script files to the remote machine
# execute script logic on remote machine
# get data returned for use
# clean up and remove script files on remote machines

$Session = New-PSSession -ComputerName 'SL-FP-01'
$CopySplat = @{
    Path        = 'C:\git\FileSharePermissionReport\tools\'
    Destination = 'C:\Program Files\WindowsPowerShell\Modules\FSPR\'
    Force       = $true
    Recurse     = $true
    ToSession   = $Session
}
Copy-Item @CopySplat
$SMBInfo = FSPR_ShareInfoBasic | FSPR_SMBInfoACL
$NTFSInfo = FSPR_ShareInfoBasic | FSPR_NTFSInfoACL

Write-Output $SMBInfo
Write-Output $NTFSInfo