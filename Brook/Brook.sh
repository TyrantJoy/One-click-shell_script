#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

print_logo(){
    echo -e "==================================================
System Required: ${red}CentOS 6+/Debian 6+/Ubuntu 14.04+${plain}
Description: Install the Brook server
Version: ${green}v2.0${plain}
Author: ${yellow}TyrantLucifer${plain}
Blog: ${yellow}https://www.linuxstudy.cn${plain}
=================================================
"
}

init_info(){
    stty erase '^H'
    stty erase '^?'
    echo "请输入你要设置的端口号:"
    read port
    echo -e "你输入的端口号为:${green} $port ${plain}"
    echo "请输入你要设置的密码:"
    read password
    echo -e "你输入的密码为:${green} $password ${plain}"
    echo "请输入你服务器的ip:"
    read ip
    echo -e "你输入的ip为:${green} $ip ${plain}"
}

download_brook(){
    brook_ver=$(wget -qO- "https://github.com/txthinking/brook/tags"| grep "/txthinking/brook/releases/tag/"| head -n 1| awk -F "/tag/" '{print $2}'| sed 's/\">//')
    wget -N --no-check-certificate "https://github.com/txthinking/brook/releases/download/${brook_ver}/brook"
    chmod +x brook
    echo -e "Brook最新版本号为:${red} $brook_ver ${plain}"
}

generate_service(){
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
}

uninstall_brook(){
    killall brook
    rm -rf /lib/systemd/system/brook.service
    systemctl daemon-reload
}

start_brook(){
    systemctl enable brook
    systemctl start brook
}

stop_brook(){
    systemctl stop brook
}

print_menu(){
    echo -e "Brook一键管理脚本
---- TyrantLucifer | linuxstudy.cn ----
${yellow}1.${plain} 安装 Brook
${yellow}2.${plain} 更新 Brook
${yellow}3.${plain} 卸载 Brook
${yellow}4.${plain} 停止 Brook
    "
}
print_info(){

    echo "Brook 服务器一栏填以下信息:"
    echo -e "${red} $ip:$port ${plain}"
    echo "Brook 密码一栏填以下信息:"
    echo -e "${red} $password ${plain}"
}

print_logo
print_menu
echo && read -e -p "请输入数字 [1-4]：" num
case "$num" in
	1)
	init_info
    download_brook
    generate_service
    start_brook
    print_info
	;;
	2)
    download_brook
	;;
	3)
	uninstall_brook
	;;
    4)
    stop_brook
    ;;
    *)
	echo -e "${red}请输入正确的数字 [1-4] ${plain}"
	;;
esac
