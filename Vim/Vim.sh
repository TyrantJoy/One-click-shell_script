#!/bin/bash

python2_release=`ls /usr/lib | grep python2`
python3_release=`ls /usr/lib | grep python3`

python2_config_dir=`ls /usr/lib/$python2_release | config-`
python3_config_dir=`ls /usr/lib/$python3_release | config-`

# 卸载自带的vim
sudo apt-get remove vim vim-runtime gvim -y
sudo apt-get remove vim-tiny vim-common vim-gui-common vim-nox -y

# 安装对应依赖
sudo apt install libncurses5-dev libgnome2-dev libgnomeui-dev \
libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev git checkinstall -y

# 下载源码包
git clone https://github.com/vim/vim.git

# 编译安装
cd vim
./configure --with-features=huge \
            --enable-multibyte \
        --enable-rubyinterp=yes \
        --enable-pythoninterp=yes \
        --with-python-config-dir=/usr/lib/$python2_release/$python2_config_dir \ 
        --enable-python3interp=yes \
        --with-python3-config-dir=/usr/lib/$python3_release/$python3_config_dir \
        --enable-perlinterp=yes \
        --enable-luainterp=yes \
            --enable-gui=gtk2 \
            --enable-cscope \
       --prefix=/usr/local
make -j4
sudo checkinstall
