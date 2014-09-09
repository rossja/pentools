#!/bin/bash
#Author: J Stroud

OS=`cat /etc/issue`
kernel=`uname -r`
uptime=`uptime`
firewall=`iptables -L`
connections=`netstat -tunap`
processes=`ps -ef`
passwd=`cat /etc/passwd`
rootFiles=`find / -uid 0 -perm -4000 -print`
hiddenFiles=`find / -regex '.+[^A-Za-z0-9(+=_-/.,!@#$%^&*~:;)]' -print`
installed_packages=`dpkg -l`

package_versions()
{
	printf "\n\n"	
	echo "-----------------------------------"
	echo "----- Package Information    ------"
	echo "-----------------------------------"
	echo "-----------------------------------"

	languages_v=(perl ruby gcc)
	languages_version=(python, java)

	for language in "${languages_v[@]}"
	
	do
		echo `$language -v`
	done

	printf "\n"
	for language in "${languages_version[@]}"

	do
		echo`$language --version`
	
	done
	
	echo "Other installed packages: $installed_packages"

}

print_configs()
{	
	configs=(group, hosts, crontab, resolv.conf, fstab)
	
	for config in "${configs[@]}"
	
		do
			echo `/etc/$config`
		done
}

echo "Platform is: $OS" 
echo "Kernel is: $kernel"
echo "This machine has been up for $uptime"
echo "Current users logged in: `who`"
printf "last logged in users: `last -a`"


printf "\n\n"
echo "-----------------------------------"
echo "----- Networking Information ------"
echo "-----------------------------------"
echo "-----------------------------------"
printf "\n\n"

echo "Interfaces are: `ifconfig`"
echo "Default route: `route -n`"
echo "Current connections on this machine: $connections"
echo "Current firewall tables: $firewall"
echo "current running processes $processes"
printf "\n\n"

echo "-----------------------------------"
echo "--------- File   Information ------"
echo "-----------------------------------"
echo "-----------------------------------"
printf "\n\n"

echo "Files with root permissions: $rootFiles"
echo "Hiden files by '.': $hiddenFiles"
echo "Mounted file system `df -l`"
package_versions
print_configs


echo "-----------------------------------"
echo "------- Hardware Information ------"
echo "-----------------------------------"
echo "-----------------------------------"
printf "\n\n"

echo "Last system boot: `dmesg`"
echo "PCI buses: `lspci`"
echo "CPU information: `lscpu`"
echo "Hardware info: `lshw`"
echo "Memory iformation: `cat /proc/meminfo`"
