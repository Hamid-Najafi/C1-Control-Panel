#!/bin/bash -e

# Copyleft (c) 2022.
#
# -------==========-------
# Ubuntu Server 22.04.01
# Hostname: orcp6-5
# Username: c1tech
# Password: 1478963
# -------==========-------
# To Run This Script
# wget -qO- https://raw.githubusercontent.com/Hamid-Najafi/C1-Control-Panel/main/ControlPanel-Install.sh 
# chmod +x ControlPanel-Install.sh 
# sudo ./ControlPanel-Install.sh ORCP6-5
# -------==========-------
# Config Openssh on System
# apt install openssh-server
# systemctl enable ssh --now
echo "-------------------------------------"
echo "Setting Hostname"
echo "-------------------------------------"
hostnamectl set-hostname $0
echo "-------------------------------------"
echo "Installing Pre-Requirements"
echo "-------------------------------------"
export DEBIAN_FRONTEND=noninteractive
apt update && apt upgrade -y
apt install -y software-properties-common git avahi-daemon python3-pip 
apt install -y debhelper build-essential gcc g++ gdb cmake 
echo "-------------------------------------"
echo "Installing Qt & Tools"
echo "-------------------------------------"
apt install -y mesa-common-dev libfontconfig1 libxcb-xinerama0 libglu1-mesa-dev
apt install -y qtbase5-dev qt5-qmake libqt5quickcontrols2-5 libqt5virtualkeyboard5*  libqt5webengine5 qtmultimedia5* libqt5serial*  libqt5multimedia*   qtwebengine5-dev libqt5svg5-dev libqt5qml5 libqt5quick5  qttools5*
apt install -y qml-module-qtquick* qml-module-qt-labs-settings qml-module-qtgraphicaleffects
# apt install -y qtcreator
# add-apt-repository ppa:beineri/opt-qt-5.15.4-focal
# apt update
# apt-get install qt515-meta-minimal -y
# apt-get install qt515-meta-full -y
# export LD_LIBRARY_PATH=/opt/qt515/lib/
echo "-------------------------------------"
echo "Configuring Music & Voice Command"
echo "-------------------------------------"
apt install -y alsa alsa-tools alsa-utils
apt install -y portaudio19-dev libportaudio2 libportaudiocpp0
apt install -y libasound2-dev libpulse-dev gstreamer1.0-omx-* gstreamer1.0-alsa gstreamer1.0-plugins-good libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev 
pip3 install sounddevice vosk
#alsamixer
echo "-------------------------------------"
echo "Configuring User and Groups"
echo "-------------------------------------"
usermod -a -G dialout c1tech
usermod -a -G video c1tech
usermod -a -G audio c1tech
echo "-------------------------------------"
echo "Installing PJSIP"
echo "-------------------------------------"
git clone https://github.com/pjsip/pjproject.git
cd pjproject
./configure --prefix=/usr --enable-shared
make dep -j4 
make -j4
make install
# Update shared library links.
ldconfig
# Verify that pjproject has been installed in the target location
ldconfig -p | grep pj
echo "-------------------------------------"
echo "USB Auto Mount"
echo "-------------------------------------"
apt install -y liblockfile-bin liblockfile1 lockfile-progs
git clone https://github.com/rbrito/usbmount
cd usbmount
dpkg-buildpackage -us -uc -b
cd ..
dpkg -i usbmount_0.0.24_all.deb
echo "-------------------------------------"
echo "Setup Contold Panel Application"
echo "-------------------------------------"
git clone https://github.com/Hamid-Najafi/C1-Control-Panel.git /home/c1tech/C1-Control-Panel
mv /home/c1tech/C1-Control-Panel/C1 .
cd /home/c1tech/C1-Control-Panel/Panel
touch -r *.*
qmake
make -j4 
echo "-------------------------------------"
echo "Create Service for Contold Panel Application"
echo "-------------------------------------"
journalctl --vacuum-time=60d
cat > /etc/systemd/system/orcp.service << "EOF"
[Unit]
Description=C1Tech Operating Room Control Panel V2.0

[Service]
ExecStart=/bin/bash -c '/home/c1tech/C1-Control-Panel/Panel/panel -platform eglfs'
Restart=always
User=c1tech
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable orcp --now
systemctl restart orcp
# journalctl -u orcp -f
echo "-------------------------------------"
echo "Configuring Splash Screen"
echo "-------------------------------------"
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/g' /etc/default/grub
update-grub

apt -y autoremove --purge plymouth
apt -y install plymouth plymouth-themes
# By default ubuntu-text is active 
# /usr/share/plymouth/themes/ubuntu-text/ubuntu-text.plymouth
# We Will use bgrt (which is same as spinner but manufacture logo is enabled) theme with our custom logo
cp /usr/share/plymouth/themes/spinner/bgrt-fallback.png{,.bak}
cp /usr/share/plymouth/themes/spinner/watermark.png{,.bak}
cp /usr/share/plymouth/ubuntu-logo.png{,.bak}
cp /home/c1tech/C1-Control-Panel/bgrt-c1.png /usr/share/plymouth/themes/spinner/bgrt-fallback.png
cp /home/c1tech/C1-Control-Panel/watermark-empty.png /usr/share/plymouth/themes/spinner/watermark.png
cp /home/c1tech/C1-Control-Panel/watermark-empty.png /usr/share/plymouth/ubuntu-logo.png
update-initramfs -u
# update-alternatives --list default.plymouth
# update-alternatives --display default.plymouth
# update-alternatives --config default.plymouth
echo "-------------------------------------"
echo "Done, Performing System Reboot"
echo "-------------------------------------"
init 6