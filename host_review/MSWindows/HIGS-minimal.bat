@echo off
md %COMPUTERNAME%
cd %COMPUTERNAME%
echo Output Created on %DATE% at %TIME% >> basic-info.txt
echo Domain: %USERDOMAIN >> basic-info.txt
echo This host: %COMPUTERNAME% >> basic-info.txt
echo This script running as: %USERNAME% >> basic-info.txt
set >> basic-info.txt

wmic os get caption,osarchitecture,buildnumber /value >> os-version.txt

reg export HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall reg.txt
find "DisplayName" reg.txt |find /V "ParentDisplayName" > tmplist.txt
for /f "tokens=2,3 delims==" %%a in (tmplist.txt) do (echo %%a >> software.txt)

wmic qfe list >hotfixes.txt

sc query state= all >> services.txt

net localgroup >> localgroups.txt
net user >> localusers.txt

ipconfig /all >> ipconfig.txt
ipconfig /displaydns >> dnscache.txt

netstat -ban >> netstat.txt

net view >> net-view.txt
net view %LOGONSERVER% >> net-view-logonserver.txt
nbtstat -n >> nbtstat-local.txt
nbtstat -S >> nbtstat-sessions.txt
net view \\%COMPUTERNAME% >> shares.txt
net use >> mapped-drives.txt

schtasks /query /fo LIST /v >> schtasks.txt

dism /online /get-packages /format:table /English >packages.txt

%systemroot%\system32\inetsrv\AppCmd.exe list sites >> IIS_sites.txt

md regdump
reg export HKLM regdump\hklm.reg
reg export HKCU regdump\hkcu.reg
reg export HKCR regdump\hkcr.reg
reg export HKU regdump\hku.reg
reg export HKCC regdump\hkcc.reg

md secretsdump
reg save hklm\sam secretsdump\sam.save 
reg save hklm\security secretsdump\security.save 
reg save hklm\system secretsdump\system.save