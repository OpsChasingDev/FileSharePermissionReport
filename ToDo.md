- nail down the invokation to other machines
- debug:
Run from SL-DC-01
~~~
PS C:\git\FileSharePermissionReport> .\FSPR_GetInfo.ps1
Get-Acl: C:\git\FileSharePermissionReport\FSPR_GetInfo.ps1:127
Line |
 127 |          $NTFSACL = Get-ACL -Path $NTFSInfo.LocalPath
     |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | Cannot find path 'TEST02-PRT,LocalsplOnly' because it does not exist.
~~~
