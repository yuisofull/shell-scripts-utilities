#!/bin/bash

last -i -F -s -5min | head -n -2 | awk '{print $1}' | sort | uniq > /var/tmp/old_login.txt
echo '
last -i -F -s -5min | head -n -2 | awk '"'{print \$1}'"' | sort | uniq > /var/tmp/new_login.txt


while read line; do
	if [ -z "$(grep "$line" /var/tmp/old_login.txt)" ]; then
		time="$(last -i -F -s -5min | grep "$line" | awk '"'{print \$7}'"')"
		echo "User "$line" dang nhap thanh cong vao thoi gian $time $(date '+%d/%m/%Y')" | mail root@localhost -s "sshmonitor"
	fi
done < /var/tmp/new_login.txt ' > /var/tmp/sshmonitor.sh
chmod a+x /var/tmp/sshmonitor.sh
echo "*/5 * * * * /var/tmp/sshmonitor.sh" | crontab -