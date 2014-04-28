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

## Log history on close
function Export-History {
 param ([string]$path=$historyPath)
 $cmdArray = @()
 if (Test-Path $path) {
  $savedHistory = @(Import-Clixml $historyPath)            

        $savedHistory | % { $cmdArray += $_.CommandLine }            

  Get-History -Count $MaximumHistoryCount | % {
                #first level of filtering
                if ($cmdArray -notcontains $_.CommandLine) { $savedHistory += $_ }             

                #Second level of filtering to remove duplicates from current session also
                $cmdArray = @()
                $savedHistory | % { $cmdArray += $_.CommandLine }
                }            

  $savedHistory | Export-Clixml $path
  Write-Host -ForegroundColor Green "`nExported history to $path along with old import`n"
 } else {
  Get-History -Count $MaximumHistoryCount | Export-Clixml $path
  Write-Host -ForegroundColor Green "`nExported history to $path`n"
 }
}            

function Import-History {
 param ([parameter(mandatory=$true)][string]$path=$historyPath)
 if (Test-Path $(Split-Path $path)) {
  Import-Clixml $path | ? {$count++;$true} | Add-History
  Write-Host -Fore Green "`nLoaded $count history item(s) from $path`n"
 }
}            

#reset $MaximumHistoryCount to 150
$MaximumHistoryCount = 150            

#Generate Histry export path for this session
$date = Get-Date
#This is not so good. But OK for now
$historyPath = "$((split-path $profile))\History$($date.Month)$($date.Day)$($date.Year).clixml"            

# This is from Nivot Ink's (@oising) blog post http://www.nivot.org/2009/08/15/PowerShell20PersistingCommandHistory.aspx
Register-EngineEvent -SourceIdentifier powershell.exiting -SupportEvent -Action { Export-History }            

# load the most recent history, if it exists
if ((Test-Path $(Split-Path $profile))) {
 (Test-Path $historyPath)
   Import-History $historyPath
  }