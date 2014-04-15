## Set job number and name
$jobnumber = 
$jobname = 

# Needed to work with DFS Namespaces
import-module DFSN

# To disable a namespace for the specified job
    set-dfsnfoldertarget -TargetPath SVR-CC-FS\Projects\$jobnumber' '-' '$jobname -state Offline

# To remove the namespace for the specified job
    Remove-DfsnFolderTarget -TargetPath SVR-CC-FS\Projects\$jobnumber' '-' '$jobname 
   
# To re-add the namespace for the specified job
    New-DfsnFolderTarget -TargetPath SVR-CC-FS\Projects\$jobnumber' '-' '$jobname -state Offline -Confirm
    set-dfsnfoldertarget -TargetPath SVR-CC-FS\Projects\$jobnumber' '-' '$jobname -state Online -Confirm