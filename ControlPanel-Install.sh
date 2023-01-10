#!/bin/bash -e

# Copyleft (c) 2022.
# -------==========-------
# Ubuntu Server 22.04.01
# Hostname: orcp6-5
# Username: c1tech
# Password: 1478963
# -------==========-------
# To Run This Script
# wget https://raw.githubusercontent.com/Hamid-Najafi/C1-Control-Panel/main/ControlPanel-Install.sh && chmod +x ControlPanel-Install.sh && sudo ./ControlPanel-Install.sh
# OR
# wget https://b2n.ir/g03701 -O CP-Install.sh && chmod +x CP-Install.sh && sudo ./CP-Install.sh
# -------==========-------
echo "-------------------------------------"
echo "Setting Hostname"
echo "-------------------------------------"
echo "Set New Hostname: (ORCP-Floor-Room)"
read hostname
hostnamectl set-hostname $hostname
echo "-------------------------------------"
echo "Setting TimeZone"
echo "-------------------------------------"
timedatectl set-timezone Asia/Tehran 
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
echo "Configuring Music"
echo "-------------------------------------"
apt install -y alsa alsa-tools alsa-utils pulseaudio portaudio19-dev libportaudio2 libportaudiocpp0
apt install -y libasound2-dev libpulse-dev gstreamer1.0-omx-* gstreamer1.0-alsa gstreamer1.0-plugins-good libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev  
apt purge -y pulseaudio
rm -rf /etc/pulse
apt install -y pulseaudio
amixer sset 'Master' 100%
amixer sset 'Capture' 85%
# amixer sset 'Rear Mic Boost' 70%
echo "-------------------------------------"
echo "Configuring Vosk"
echo "-------------------------------------"
string="options snd-hda-intel id=PCH,HDMI index=1,0"
file="/etc/modprobe.d/alsa-base.conf"
if ! grep -q "$string" "$file"; then
  echo "$string" | tee -a "$file"
fi
sudo -H -u c1tech bash -c 'pip3 install sounddevice vosk'
cat >> /home/c1tech/./DownloadVoskModel.py << EOF
from vosk import Model
model = Model(model_name="vosk-model-small-fa-0.5")
exit()
EOF
sudo -H -u c1tech bash -c 'python3 /home/c1tech/./DownloadVoskModel.py'
rm /home/c1tech/./DownloadVoskModel.py
#alsamixer
echo "-------------------------------------"
echo "Configuring User Groups"
echo "-------------------------------------"
usermod -a -G dialout c1tech
usermod -a -G audio c1tech
usermod -a -G video c1tech
usermod -a -G input c1tech
echo "c1tech user added to dialout, audio, video & input groups"
# Give c1tech Reboot Permision
chown root:c1tech /bin/systemctl
sudo chmod 4755 /bin/systemctl
echo "-------------------------------------"
echo "Installing PJSIP"
echo "-------------------------------------"
url="https://github.com/pjsip/pjproject.git"
folder="/home/c1tech/pjproject"
[ -d "${folder}" ] && rm -rf "${folder}"    
git clone "${url}" "${folder}"
cd pjproject
./configure --prefix=/usr --enable-shared
make dep -j4 
make -j4
make install
# Update shared library links.
ldconfig
# Verify that pjproject has been installed in the target location
ldconfig -p | grep pj
cd /home/c1tech/
echo "-------------------------------------"
echo "Installing USB Auto Mount"
echo "-------------------------------------"
apt install -y liblockfile-bin liblockfile1 lockfile-progs
url="https://github.com/rbrito/usbmount"
folder="/home/c1tech/usbmount"
[ -d "${folder}" ] && rm -rf "${folder}"    
git clone "${url}" "${folder}"
cd /home/c1tech/usbmount
dpkg-buildpackage -us -uc -b
cd /home/c1tech/
dpkg -i usbmount_0.0.24_all.deb
echo "-------------------------------------"
echo "Installing Contold Panel Application"
echo "-------------------------------------"
url="https://github.com/Hamid-Najafi/C1-Control-Panel.git"
folder="/home/c1tech/C1-Control-Panel"
[ -d "${folder}" ] && rm -rf "${folder}"    
git clone "${url}" "${folder}"
folder="/home/c1tech/C1"
[ -d "${folder}" ] && rm -rf "${folder}"    
mv /home/c1tech/C1-Control-Panel/C1 /home/c1tech/
cd /home/c1tech/C1-Control-Panel/Panel
touch -r *.*
qmake
make -j4 

chown -R c1tech:c1tech /home/c1tech/C1
chown -R c1tech:c1tech /home/c1tech/C1-Control-Panel
echo "-------------------------------------"
echo "Creating Service for Contold Panel Application"
echo "-------------------------------------"
journalctl --vacuum-time=60d
loginctl enable-linger c1tech
sudo -H -u c1tech bash << "EOF2"
export XDG_RUNTIME_DIR=/run/user/1000
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
# /usr/lib/systemd/user/orcp.service
# /etc/systemd/system/orcp.service
mkdir -p /home/c1tech/.config/systemd/user
cat > /home/c1tech/.config/systemd/user/orcp.service << "EOF"
[Unit]
Description=C1Tech Operating Room Control Panel V2.0
# After=pulseaudio.service

[Service]
# Type=idle
Environment="XDG_RUNTIME_DIR=/run/user/1000"
Environment="DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus"
ExecStartPre=amixer sset 'Capture' 85% 
ExecStart=/home/c1tech/C1-Control-Panel/Panel/panel -platform eglfs
Restart=always
# User=c1tech
[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable orcp
EOF2

# systemctl --user status orcp
# systemctl --user restart orcp
# journalctl --user --unit orcp --follow
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
echo "-------------------------------------"
echo "Test Mic and Spk"
echo "-------------------------------------"
sudo apt install -y lame sox libsox-fmt-mp3

arecord -v -f cd -t raw | lame -r - output.mp3
play output.mp3
# -------==========-------
wget https://raw.githubusercontent.com/alphacep/vosk-api/master/python/example/test_microphone.py
python3 test_microphone.py -m fa
# -------==========-------
sudo apt-get --purge autoremove pulseaudio
# -------==========-------
sudo rm /etc/systemd/system/orcp.service
sudo systemctl daemon-reload