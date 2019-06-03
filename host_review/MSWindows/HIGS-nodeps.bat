@echo off
REM ---------------------------------------------
REM Host Information Gathering Script (Windows Edition)
REM Written by Jason Ross <algorythm@gmail.com>
REM ---------------------------------------------
REM Version: 0.4
REM Last Modified: 2018.08.31
REM ---------------------------------------------
REM Simple Windows batch file to gather system
REM information for use during a host config
REM review, or as an aid to Incident Response.
REM All output goes into a folder which named
REM whatever the %COMPUTERNAME% variable is set to.
REM ---------------------------------------------
REM Depends on the psloglist and procdump tools from SysInternals
REM https://docs.microsoft.com/en-us/sysinternals/
REM ---------------------------------------------
REM Tested on the following platforms:
REM Server:
REM    Windows 2003 SP2
REM    Windows Server 2012
REM    Windows Server 2012 R2
REM    Windows Server 2016
REM Desktop:
REM    Windows 7 Professional (32 bit)
REM    Windows 7 Professional (64 bit)
REM    Windows XP SP3
REM    Windows XP SP2
REM ---------------------------------------------
REM TODO: update this to check for powershell
REM       and use that to perform more robust
REM       checks. Also needs to be updated badly
REM       to utilize the newer features of IIS
REM ---------------------------------------------
REM This program is free software: you can redistribute it and/or modify
REM it under the terms of the GNU General Public License as published by
REM the Free Software Foundation, either version 3 of the License, or
REM (at your option) any later version.
REM
REM This program is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM GNU General Public License for more details.
REM
REM You should have received a copy of the GNU General Public License
REM along with this program.  If not, see <http://www.gnu.org/licenses/>.
REM ---------------------------------------------
REM Copyright 2010-2018 Jason Ross <algorythm /at/ gmail /dot/ com>
REM ---------------------------------------------
md %COMPUTERNAME%
cd %COMPUTERNAME%


echo =================
echo Gathering basic information
echo =================
echo Host Configuration Tool >> basic-info.txt
echo Output Created on %DATE% at %TIME% >> basic-info.txt
echo ================= >> basic-info.txt
echo Domain: %USERDOMAIN >> basic-info.txt
echo This host: %COMPUTERNAME% >> basic-info.txt
echo This script running as: %USERNAME% >> basic-info.txt
echo ================= >> basic-info.txt
echo Environment Variables: >> basic-info.txt
set >> basic-info.txt
echo Done!
echo.

echo =================
echo Detecting OS version
echo =================
wmic os get caption,osarchitecture,buildnumber /value >> os-version.txt
echo Done!
echo.

echo =================
echo Detecting installed software
echo =================
reg export HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall reg.txt
find "DisplayName" reg.txt |find /V "ParentDisplayName" > tmplist.txt
for /f "tokens=2,3 delims==" %%a in (tmplist.txt) do (echo %%a >> software.txt)
echo Done!
echo.


echo =================
echo Detecting installed hotfixes
echo =================
wmic qfe list >hotfixes.txt
echo Done!
echo.

echo =================
echo Creating list of registered services
echo =================
sc query state= all >> services.txt
echo Done!
echo.


echo =================
echo Gathering local user and group information
echo =================
net localgroup >> localgroups.txt
net user >> localusers.txt
echo Done!
echo.


echo =================
echo Gathering IP configuration
echo =================
ipconfig /all >> ipconfig.txt
ipconfig /displaydns >> dnscache.txt
echo Done!
echo.


echo =================
echo Detecting open ports
echo =================
netstat -ban >> netstat.txt
echo Done!
echo.


echo Enumerating network information visible to this host
echo ================= > net-view.txt
net view >> net-view.txt
net view %LOGONSERVER% >> net-view-logonserver.txt
nbtstat -n >> nbtstat-local.txt
nbtstat -S >> nbtstat-sessions.txt
echo Done!
echo.


echo =================
echo Gathering local shared folder information
echo =================
net view \\%COMPUTERNAME% >> shares.txt
echo Done!
echo.


echo =================
echo Gathering mapped drives information
echo =================
net use >> mapped-drives.txt
echo Done!
echo.


echo =================
echo Checking scheduled jobs
echo =================
schtasks /query /fo LIST /v >> schtasks.txt
echo Done!
echo.


echo =================
echo Checking installed updates
echo =================
dism /online /get-packages /format:table /English >packages.txt
echo Done!
echo.


echo =================
echo Checking IIS sites
echo =================
%systemroot%\system32\inetsrv\AppCmd.exe list sites >> IIS_sites.txt
echo Done!
echo.


echo =================
echo Dumping the registry
echo =================
md regdump
reg export HKLM regdump\hklm.reg
reg export HKCU regdump\hkcu.reg
reg export HKCR regdump\hkcr.reg
reg export HKU regdump\hku.reg
reg export HKCC regdump\hkcc.reg
echo Done!
echo.


echo =================
echo Dumping SAM and Security hives
echo =================
md secretsdump
reg save hklm\sam secretsdump\sam.save 
reg save hklm\security secretsdump\security.save 
reg save hklm\system secretsdump\system.save
echo Done!
echo.


REM ---------------------------------------------
REM wrapup
REM ---------------------------------------------
echo =================
echo Cleaning up temporary files
echo =================
del reg.txt tmplist.txt
echo Done!
echo.

cd ..

echo =================
echo Host Information Gathering Script finished!
echo To copy the data to another location run:
echo "xcopy /E /H /I %COMPUTERNAME% <other-location>"
echo =================
echo.
