#!/bin/bash
echo [System Information]
echo Hostname: $(lshw | head -1)
echo Distribution: $(lsb_release -d | awk '{print $2,$3}')
echo OS Version: $(lsb_release -d | awk '{print $2,$3,$4}')
echo CPU Name: $(lscpu | grep "Model name" | awk '{$1=$2="";print}')
echo CPU Mode: $(lscpu | grep "op-" | awk '{$1=$2="";print}')
echo Physical Memory Information: $(df -BM / | tail -1 | awk '{print $2}')
echo Available Disk Space: $(df -BM / | tail -1 | awk '{print $4}')
echo List of System IP Addresses: $(ifconfig | grep "inet " | awk '{print $2}')
echo List of Users on the System: "$(cat /etc/passwd | grep /bin/bash | awk -F: '{print $1}' | sort)"
echo Information about Processes Running with Root Privileges: "$(ps -aux | grep root | awk '{print $11}' | sort)"
echo List of Open Ports: "$(ss -lntu | awk '{print $5}'| grep '^[0-9[]' | awk -F: '{print $NF}'| sort | uniq)"
echo List of Directories Allowing Others to Write: "$(find / -maxdepth 1 -type d -perm -o=w | cut -c 2-)"
ppp=$(sudo apt list | sed 's///:/g')
echo List of Installed Software Packages: "$ppp"