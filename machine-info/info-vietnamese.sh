#!/bin/bash
echo [Thong tin he thong]
echo Ten may: $(lshw | head -1)
echo Ten ban phan phoi:$(lsb_release -d | awk '{print $2,$3}')
echo Phien ban he dieu hanh:$(lsb_release -d | awk '{print $2,$3,$4}')
echo Ten CPU:$(lscpu | grep "Model name" | awk '{$1=$2="";print}')
echo CPU mode:$(lscpu | grep "op-" | awk '{$1=$2="";print}')
echo Thong tin bo nho vat ly:$(df -BM / | tail -1 | awk '{print $2}')
echo Thong tin o dia con trong:$(df -BM / | tail -1 | awk '{print $4}')
echo Danh sach dia chi ip he thong:$(ifconfig | grep "inet " | awk '{print $2}')
echo Danh sach user tren he thong:"$(cat /etc/passwd | grep /bin/bash | awk -F: '{print $1}' | sort)"
echo Thong tin cac tien trinh dang chay voi quyen root:"$(ps -aux | grep root | awk '{print $11}' | sort)"
echo Thong tin cac port dang mo:"$(ss -lntu | awk '{print $5}'| grep '^[0-9\[]' | awk -F: '{print $NF}'| sort | uniq)"
echo Danh sach cac thu muc tren he thong cho phep other co quyen ghi:"$(find / -maxdepth 1 -type d -perm -o=w | cut -c 2-)"
ppp=$(sudo apt list | sed 's/\//:/g')
echo Danh sach cac goi phan mem duoc cai tren he thong:"$ppp"
