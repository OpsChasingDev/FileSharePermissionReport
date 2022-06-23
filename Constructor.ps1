# constructor script intended to be invoked to other machines for processing their share data permissions

# copy all script files to the remote machine
# execute script logic on remote machine
# get data returned for use
# clean up and remove script files on remote machines

$Session = New-PSSession -ComputerName 'SL-FP-01'
Invoke-Command -Session $Session {New-Item -ItemType Directory -Path 'C:\Program Files\WindowsPowerShell\Modules\FSPR\'}
$CopySplat = @{
    Path        = 'C:\git\FileSharePermissionReport\FSPR.psm1'
    Destination = 'C:\Program Files\WindowsPowerShell\Modules\FSPR\FSPR.psm1'
    Force       = $true
    ToSession   = $Session
}
Copy-Item @CopySplat