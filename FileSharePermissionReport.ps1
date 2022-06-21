.\FSPR_ShareInfoBasic.ps1
.\FSPR_SMBInfoACL.ps1
.\FSPR_NTFSInfoACL.ps1

$SMBInfoACL = FSPR_ShareInfoBasic | FSPR_SMBInfoACL
$NTFSInfoACL = FSPR_ShareInfoBasic | FSPR_NTFSInfoACL