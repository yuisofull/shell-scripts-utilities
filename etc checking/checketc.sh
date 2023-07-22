#!/bin/bash
find /etc -type f > /var/tmp/etc_old_state
echo '
#!/bin/bash
find /etc -type f -mmin -15 > /var/tmp/etc_changes
find /etc -type f > /var/tmp/etc_new_state
echo "[Log checketc - $(date +"%T %d/%m/%Y")]" >/var/log/checketc1.log
echo "=== Danh sach file tao moi ===" >>/var/log/checketc1.log
while read line; do
	if [ -z "$(grep "$line" /var/tmp/etc_old_state)" ]; then
		echo $line >>/var/log/checketc1.log
		cat $line | head -n 10 >>/var/log/checketc1.log
	else
		echo $line >> /var/tmp/etc_modified
	fi
done < <(cat /var/tmp/etc_changes)
echo "xxxxxxxxxx">>/var/log/checketc1.log
echo "=== Danh sach file duoc chinh sua ===" >>/var/log/checketc1.log
while read line; do	
	echo $line >>/var/log/checketc1.log>>/var/log/checketc.log
done < <(cat /var/tmp/etc_modified)
rm /var/tmp/etc_modified
diff /var/tmp/etc_new_state /var/tmp/etc_old_state > /var/tmp/etc_deleted
echo "xxxxxxxxxx">>/var/log/checketc1.log>>/var/log/checketc.log
echo "=== Danh sach file bi xoa ===" >>/var/log/checketc1.log
while read line; do
	if [[ $line == \>* ]]; then
		if [ -z "$(grep "$(awk '"'{print \$2}'"' <<< "$line")" /var/tmp/etc_new_state)" ]; then
			echo $(awk '"'{print \$2}'"' <<< "$line") >>/var/log/checketc1.log
		fi
	fi
done < <(cat /var/tmp/etc_deleted)
cp /var/tmp/etc_new_state /var/tmp/etc_old_state
echo "xxxxxxxxxx">>/var/log/checketc1.log
mail -s "checketc.log" root@localhost -a /var/log/checketc.log </var/log/checketc1.log 
cat /var/log/checketc1.log >> /var/log/checketc.log' >/var/tmp/checketc.sh
chmod a+x /var/tmp/checketc.sh
echo "*/15 * * * * /var/tmp/checketc.sh" | crontab -