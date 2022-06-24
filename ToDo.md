- make remote machines group all ACL results into collection objects:
    ShareName = name of share
    LocalPath = local path of the share
    Permissions = collection of all results for that share
    - store the SMB and NTFS outputs in variables
    - pipe FSPR_ShareInfoBasic to new function:
      - for each share object, find all objects stored in the SMB and NTFS output whose local path matches that of the share object's local path, and add that entire object as a new member of a new advanced share object called "Permissions"