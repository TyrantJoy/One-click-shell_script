function get_linux_platform_type()
{
    if which apt-get > /dev/null ; then
        echo "ubuntu" # debian ubuntu系列
    elif which yum > /dev/null ; then
        echo "centos" # centos redhat系列
    elif which pacman > /dev/null; then
        echo "archlinux" # archlinux系列
    else
        echo "invaild"
    fi
}
stty erase '^H'
type=`get_linux_platform_type`
echo "当前服务器平台为:$type"

if [ ${type} == "ubuntu" ]; then
	apt install git cmake make gcc curl openssl vim vim-common -y
    elif [ ${type} == "centos" ]; then
	yum install git cmake make gcc curl openssl-devel vim vim-common -y
fi

serverIp=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -n 1`


echo "请输入你想要设置的端口号:"
read port
echo "您输入的端口号为:$port"

echo "请输入你服务器的IP地址:"
read ip
echo "您输入的服务器的IP为:$ip"

git clone https://github.com/TelegramMessenger/MTProxy
cd MTProxy
make && cd objs/bin
directory=`pwd`
curl -s https://core.telegram.org/getProxySecret -o proxy-secret
curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf
secret=`head -c 16 /dev/urandom | xxd -ps`

if [ $serverIp == $ip ]
then
	ExecStart="$directory/mtproto-proxy -u nobody -p 8888 -H $port -S $secret --aes-pwd proxy-secret proxy-multi.conf -M 1"
else
	ExecStart="$directory/mtproto-proxy -u nobody -p 8888 -H $port -S $secret --nat-info $serverIp:$ip --aes-pwd proxy-secret proxy-multi.conf -M 1"
fi
echo "
[Unit]
Description=MTProxy
After=network.target

[Service]
Type=simple
WorkingDirectory=$directory
ExecStart=$ExecStart
Restart=on-failure

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/MTProxy.service
systemctl enable MTProxy
systemctl start MTProxy
clear
echo "你的专属MTProxy链接为:"
echo -e "\e[1;31m tg://proxy?server=$ip&port=$port&secret=$secret \e[0m"

