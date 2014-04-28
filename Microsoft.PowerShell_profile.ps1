## Because I like working in my home directory
set-location C:\Users\6onGit\scripts\

## Bash-style prompt
function prompt {
"[$env:username@$([System.Net.Dns]::GetHostName())]$ "
}

## Helpful tools
set-alias psexec C:\PSTools\PsExec.exe
set-alias putty C:\Users\6onGit\Downloads\kitty.exe
set-alias kitty C:\Users\6onGit\Downloads\kitty.exe
set-alias firefox 'C:\Program Files (x86)\Mozilla Firefox\firefox.exe'
set-alias psfile C:\PSTools\psfile.exe
set-alias psgetsid C:\PSTools\PsGetsid.exe
set-alias psinfo C:\PSTools\PsInfo.exe
set-alias pskill C:\PSTools\pskill.exe
set-alias pslist C:\PSTools\pslist.exe
set-alias psloggedon C:\PSTools\PsLoggedon.exe
set-alias psloglist C:\PSTools\psloglist.exe
set-alias pspasswd C:\PSTools\pspasswd.exe
set-alias psping C:\PSTools\psping.exe
set-alias psservice C:\PSTools\PsService.exe
set-alias psshutdown C:\PSTools\psshutdown.exe
set-alias pssuspend C:\PSTools\pssuspend.exe

## I missed using the one-worder of "uptime." 
Function Uptime
{$computer = read-host "Please type in computer name you would like to check uptime on"

$lastboottime = (Get-WmiObject -Class Win32_OperatingSystem -computername $computer).LastBootUpTime

$sysuptime = (Get-Date) – [System.Management.ManagementDateTimeconverter]::ToDateTime($lastboottime)
 
Write-Host "$computer has been up for: " $sysuptime.days "days" $sysuptime.hours "hours" $sysuptime.minutes "minutes" $sysuptime.seconds "seconds"}

Function diskusage
{$remotepc = Read-host 'For which computer?'
Get-WmiObject win32_logicaldisk -ComputerName $remotepc  -Filter "drivetype=3" | select SystemName,DeviceID,VolumeName,@{Name="Size(GB)";Expression={"0:N1}" -f($_.size/1gb)}},@{Name="FreeSpace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}}}

Function patches
{ $remotepc = Read-host 'For which box?'
Get-WmiObject -Class "win32_quickfixengineering" -ComputerName $remotepc | select hotfixid,installedon}

function get-subnets
{Get-ADObject -filter 'objectclass -eq "site"' -SearchBase 'CN=Configuration,DC=YourOrg,DC=Com' -Properties siteObjectBL | foreach {$_.siteobjectbl}}

function get-sites
{Get-ADObject -filter 'objectclass -eq "site"' -SearchBase 'CN=Configuration,DC=YourOrg,DC=Com' | select Name,ObjectGUID}

function new-adsite
{new-ADObject -filter 'objectclass -eq "site"' -SearchBase 'CN=Configuration,DC=YourOrg,DC=Com' | select Name,ObjectGUID}

function isitup
{$jobnumber = Read-Host 'Which job number?'
$jobnet = $jobnumber -replace '(?<=\d)(?=(\d{2})+\b)', '.'
ping 10.$jobnet.1
ping 10.$jobnet.20}