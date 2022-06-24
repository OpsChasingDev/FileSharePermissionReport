param (
    [Parameter(ValueFromPipelineByPropertyName,
        Mandatory)]
    [string]$ComputerName,
    
    [string]$ModulePath = 'C:\Program Files\WindowsPowerShell\Modules'
    
)

# open new session to remote machine
$Session = New-PSSession -ComputerName $ComputerName

# copy module file to remote machine
Invoke-Command -Session $Session {
    New-Item -ItemType Directory -Path "$using:ModulePath\FSPR" -ErrorAction SilentlyContinue > $null
}
$CopySplat = @{
    Path        = 'C:\git\FileSharePermissionReport\FSPR.psm1'
    Destination = "$ModulePath\FSPR\FSPR.psm1"
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
    Remove-Item -Path "$using:ModulePath\FSPR" -Recurse -Force
}

# close session
Remove-PSSession -Session $Session