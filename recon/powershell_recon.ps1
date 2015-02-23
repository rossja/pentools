#Author: Jared Stroud
#Purpose: Enumerate Windows hosts for useful information

write-host "Hostname of this machine is: " + hostname
write-host "You are running this script as : " + whoami

#Dumping running processes
get-process > running_processes.txt

#Dumping Scheduled tasks
Get-ScheduledTask | Export-Csv scheduled_tasks.csv

#Dumping services
get-service | Export-Csv services.csv

#Lists local users
get-acl > users.txt

#List AD users with non expiring passwords, not not on a DC then it'll just error out and continue.
try
{
	Search-ADAccount -PasswordNeverExpires | FT Name,  ObjectClass, UserPrincipalName > ad_users_nonexpire_passwords.txt
}
catch
{
	write-host "Error, could not enumerate AD accounts!"
}

#Firewall rules
get-netfirewallrule > firewall_rules.txt

#Enumerate shares
get-wmiObject Win32_Share > shares.txt

#IP Address Configs & Networking information
get-netipaddress > ip_configs.txt
get-netipinterface > ip_interface.txt


# Installed software
Get-WmiObject win32_product >  installed_software.txt

# List those  Updates & Hotfix IDS
Get-WmiObject -Class "win32_quickfixengineering" | Export-Csv updates.csv

