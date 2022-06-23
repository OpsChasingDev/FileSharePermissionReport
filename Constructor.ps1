
# open new session to remote machine
$Session = New-PSSession -ComputerName 'SL-FP-01'

# copy module file to remote machine
Invoke-Command -Session $Session {
    New-Item -ItemType Directory -Path 'C:\Program Files\WindowsPowerShell\Modules\FSPR\'
}
$CopySplat = @{
    Path        = 'C:\git\FileSharePermissionReport\FSPR.psm1'
    Destination = 'C:\Program Files\WindowsPowerShell\Modules\FSPR\FSPR.psm1'
    Force       = $true
    ToSession   = $Session
}
Copy-Item @CopySplat

# execute script logic on remote machine
Invoke-Command -Session $Session {
    FSPR_ShareInfoBasic | FSPR_SMBInfoACL
    FSPR_ShareInfoBasic | FSPR_NTFSInfoACL
}

# clean up and remove script files on remote machines
Invoke-Command -Session $Session {
    Remove-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\FSPR' -Recurse -Force
}

# close session
Remove-PSSession -Session $Session