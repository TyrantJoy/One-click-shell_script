#!/bin/bash
stty erase '^H'
echo "请输入你要设置的端口号:"
read port
echo "你输入的端口号为:$port"

echo "请输入你要设置的密码:"
read password
echo "你输入的密码为:$password"

echo "请输入你服务器的ip:"
read ip
echo "你输入的ip为:$ip"

brook_ver=$(wget -qO- "https://github.com/txthinking/brook/tags"| grep "/txthinking/brook/releases/tag/"| head -n 1| awk -F "/tag/" '{print $2}'| sed 's/\">//')
wget -N --no-check-certificate "https://github.com/txthinking/brook/releases/download/${brook_ver}/brook"
chmod +x brook
directory=`pwd`

echo "
[Unit]
Description=brook service
After=network.target syslog.target
Wants=network.target

[Service]
Type=simple
ExecStart=$directory/brook server -l :$port -p $password

[Install]
WantedBy=multi-user.target
" > /lib/systemd/system/brook.service

systemctl enable brook
systemctl start brook

echo "Brook 服务器一栏填以下信息:"
echo "$ip:$port"
echo "Brook 密码一栏填以下信息:"
echo "$password"
