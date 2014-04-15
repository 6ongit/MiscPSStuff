### Welcome to the fantastic Jobsite Server Setup script!
# Please note that while we are still using Server 2008, we are not barbarians.
# We can still update to a decent version of Windows Management Framework.
# Please note that a large amount of this script is rendered useless if your WinMF version is below 4.0,
# you will have a bad time.

## Download links to updated versions of the framework are below.

# Windows Management Framework 3.0
# http://www.microsoft.com/en-us/download/details.aspx?id=34595

# Windows Management Framework 4.0
# http://www.microsoft.com/en-us/download/details.aspx?id=40855

##  Update the below variables as necessary.  
# 4 digit number
$jobnumber = '2667'
# Now add a decimal to determine the subnets (at least until I find out how to do it automatically)
$subnet = '26.67'
# What is the job name
$jobname = 'FSU Program Mgmt'

## Uncomment this if you want to be able to run unsigned powershell scripts on this server
#set-executionpolicy unrestricted

# This turns on PowerShell Remoting
Enable-PSRemoting

# Grab and install the needed features on Server 2012 or newer (DHCP, DFS, Print server) 
#get-windowsfeature -name DHCP, FS-DFS*, Print* | install-windowsfeature


# On Server 2008
ServerManagerCMD.exe -install DHCP, FS-*, Print-services

# DHCP Configuration (Scope, Gateway, DNS, and Domain name)

## !!!ONLY WORKS ON SERVER 2012 AND NEWER!!!!
Import-module DHCPServer
    Add-DhcpServerv4Scope -name JS-$jobnumber -StartRange 10.$subnet.128 -EndRange 10.$subnet.254 -SubnetMask 255.255.255.0 -State Active
    Set-DhcpServerv4OptionValue -OptionId 3 -Value 10.$subnet.1 -ScopeId 10.$subnet.0
    Set-DhcpServerv4OptionValue -OptionId 6 -Value 10.1.1.10, 10.1.1.18 -ScopeId 10.$subnet.0
    Set-DhcpServerv4OptionValue -OptionId 15 -Value clarkcc.com -ScopeId 10.$subnet.0

## DFS Setup
# WinMF under 4.0 needs to use DFSUtil and DFSRAdmin
# DFS cmdLet coming soon

mkdir C:\Projects\$jobnumber' '-' '$jobname
cp \\clarkcc.com\storage\projects\$jobnumber '-' $jobname\* c:\projects\$jobnumber '-' $jobname\
dfsutil target add \\clarkcc.com\storage\Projects\$jobnumber - $jobname
DFSRAdmin member new /rgname:$jobnumber /memname:$env:computername
DFSRAdmin conn new /rgname:$jobnumber /SendMem:$env:computername /RecvMem:svr-cc-fs /ConnEnabled:true
DFSRAdmin conn new /rgname:$jobnumber /SendMem:$env:computername /RecvMem:svr-lw-fs /ConnEnabled:true
DFSRAdmin conn new /rgname:$jobnumber /SendMem:svr-cc-fs /RecvMem:$env:computername /ConnEnabled:true
DFSRAdmin conn new /rgname:$jobnumber /SendMem:svr-lw-fs /RecvMem:$env:computername /ConnEnabled:true
DFSRAdmin membership set /rgname:$jobnumber /rfname:$jobnumber - $jobname /memname:clarkcc\$env.computername /localpath:C:\Projects\$jobnumber - $jobname /MembershipEnabled:true /StagingSize: 4000000 /CDSize:660 /IsPrimary:false /force 

## Set Hostname


## Set static IP
# Wooo hoooo!
New-NetIPAddress -InterfaceAlias "Wired Ethernet Connection" -IPv4Address 10.$jobnumber.20 -PrefixLength 24 -DefaultGateway 10.$jobnumber.1 
# DNS Settings
Set-DNSClientServerAddress -InterfaceAlias "Wired Ethernet Connection" -ServerAddresses 10.1.1.18 10.1.1.10 