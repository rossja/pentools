md %COMPUTERNAME%
echo Domain: %USERDOMAIN >> basic-info.txt
echo This host: %COMPUTERNAME% >> basic-info.txt
echo This script running as: %USERNAME% >> basic-info.txt
set >> basic-info.txt
reg export HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall reg.txt
find "DisplayName" reg.txt |find /V "ParentDisplayName" > tmplist.txt
for /f "tokens=2,3 delims==" %%a in (tmplist.txt) do (echo %%a >> software.txt)
wmic qfe list >hotfixes.txt
sc query state= all >> services.txt
net view >> net-view.txt
net localgroup >> localgroups.txt
net user >> localusers.txt
net view \\%COMPUTERNAME% >> shares.txt
ipconfig /all >> ipconfig.txt
netstat -ban >> netstat.txt
at >> at.txt
dism /online /get-packages /format:table /English >packages.txt
%windir%\system32\inetsrv\AppCmd.exe list site > IIS_sites.txt
reg export HKLM hklm.reg
reg export HKCU hkcu.reg
reg export HKCR hkcr.reg
reg export HKU hku.reg
reg export HKCC hkcc.reg
