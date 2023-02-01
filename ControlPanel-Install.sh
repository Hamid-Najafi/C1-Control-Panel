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
echo "Create Account"
echo "-------------------------------------"
# adduser c1tech
# usermod -aG sudo c1tech
echo "-------------------------------------"
echo "Setting Hostname"
echo "-------------------------------------"
echo "Set New Hostname: (ORCP-Floor-Room)"
read hostname
hostnamectl set-hostname $hostname
string="$hostname"
file="/etc/hosts"
if ! grep -q "$string" "$file"; then
  printf "\n%s" "127.0.0.1 $hostname" >> "$file"
fi
echo "-------------------------------------"
echo "Setting TimeZone"
echo "-------------------------------------"
timedatectl set-timezone Asia/Tehran 
echo "-------------------------------------"
echo "Installing Pre-Requirements"
echo "-------------------------------------"
# string="http://ir.archive.ubuntu.com/ubuntu"
# file="/etc/apt/sources.list"
# if grep -q "$string" "$file"; then
#   echo "Replacing APT Sources File"
#   mv /etc/apt/sources.list{,.backup}
#   sh -c "echo 'deb [trusted=yes] https://debian.iranrepo.ir bullseye main' >> /etc/apt/sources.list"
#   # sh -c "echo 'deb [trusted=yes] https://debian.iranrepo.ir jammy main' >> /etc/apt/sources.list"
#   sudo apt-key adv --keyserver debian.iranrepo.ir --recv-keys  648ACFD622F3D138
#   sudo apt-key adv --keyserver debian.iranrepo.ir --recv-keys  0E98404D386FA1D9
#   sudo apt-key adv --keyserver debian.iranrepo.ir --recv-keys  605C66F00D6C9793
#   # wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/Apt/amd64-sources.list -O /etc/apt/sources.list
#   # wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/Apt/arm64-sources.list -O /etc/apt/sources.list
# fi
# string="http://archive.ubuntu.com/ubuntu"
# if grep -q "$string" "$file"; then
#   echo "Replacing APT Sources File"
#   mv /etc/apt/sources.list{,.backup}
#   sh -c "echo 'deb [trusted=yes] https://debian.iranrepo.ir bullseye main' >> /etc/apt/sources.list"
#   # sh -c "echo 'deb [trusted=yes] https://debian.iranrepo.ir jammy main' >> /etc/apt/sources.list"
#   # wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/Apt/amd64-sources.list -O /etc/apt/sources.list
#   # wget https://raw.githubusercontent.com/Hamid-Najafi/DevOps-Notebook/master/Apps/Apt/arm64-sources.list -O /etc/apt/sources.list
# fi

export DEBIAN_FRONTEND=noninteractive
apt update && apt upgrade -q -y
apt install -q -y software-properties-common git avahi-daemon python3-pip nano lame sox libsox-fmt-mp3 curl zip unzip atop bmon
apt install -q -y debhelper build-essential gcc g++ gdb cmake
echo "-------------------------------------"
echo "Installing Qt & Tools"
echo "-------------------------------------"
apt install -q -y mesa-common-dev libfontconfig1 libxcb-xinerama0 libglu1-mesa-dev 
apt install -q -y qt5* qttools5* qtmultimedia5* qtwebengine5* qtvirtualkeyboard* qtdeclarative* qt3d*
apt install -q -y qtbase5* 
apt install -q -y libqt5*
apt install -q -y qml-module*
echo "-------------------------------------"
echo "Configuring Sound & Mic"
echo "-------------------------------------"
apt install -q -y alsa alsa-tools alsa-utils portaudio19-dev libportaudio2 libportaudiocpp0 pulseaudio
apt install -q -y libasound2-dev libpulse-dev gstreamer1.0-omx-* gstreamer1.0-alsa gstreamer1.0-plugins-good libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev  
apt purge -y pulseaudio
rm -rf /etc/pulse
apt install -q -y pulseaudio

# #**** BOYA BY-MC2 ****
# c1tech@orcp:~$ aplay -l
# **** List of PLAYBACK Hardware Devices ****
# .....
# card 1: Device [PDP Audio Device], device 0: USB Audio [USB Audio]
#   Subdevices: 0/1
#   Subdevice #0: subdevice #0

# #**** List sound cards ****
# cat /proc/asound/cards

# #**** Set default sound cards ****
# cat >> /etc/asound.conf << EOF
# defaults.pcm.card 3
# defaults.ctl.card 3
# EOF


# This is for MINIPCs
# string="options snd-hda-intel id=PCH,HDMI index=1,0"
# file="/etc/modprobe.d/alsa-base.conf"
# if ! grep -q "$string" "$file"; then
#   echo "Setting ALSA Device Priority"
#   echo "$string" | tee -a "$file"
# fi

# amixer -c 1 scontrols
# amixer -c 1 sset 'Speaker' 68 && amixer -c 1 sset 'Mic' 68
echo "-------------------------------------"
echo "Configuring Vosk"
echo "-------------------------------------"
if [ ! -d /home/c1tech/.pip ]
then
mkdir /home/c1tech/.pip
chown c1tech:c1tech /home/c1tech/.pip
cat >> /home/c1tech/.pip/pip.conf << EOF
[global]
index-url = https://pypi.iranrepo.ir/simple
EOF
fi

sudo -H -u c1tech bash -c 'pip3 install sounddevice vosk shadowsocksr-cli'

mkdir -p /home/c1tech/.cache/vosk
chown -R c1tech:c1tech /home/c1tech
# Manually Model Download (Because of Sanctions!)
if [ ! -f /home/c1tech/.cache/vosk/vosk-model-small-fa-0.5.zip ]
then
  wget https://raw.githubusercontent.com/Hamid-Najafi/C1-Control-Panel/main/vosk-model-small-fa-0.5.zip -P /home/c1tech/.cache/vosk
  unzip /home/c1tech/.cache/vosk/vosk-model-small-fa-0.5.zip -d /home/c1tech/.cache/vosk
  rm /home/c1tech/.cache/vosk/vosk-model-small-fa-0.5.zip
fi

# Vosk Model Download
# cat >> /home/c1tech/./DownloadVoskModel.py << EOF
# from vosk import Model
# model = Model(model_name="vosk-model-small-fa-0.5")
# exit()
# EOF
# sudo -H -u c1tech bash -c 'python3 /home/c1tech/./DownloadVoskModel.py'
# rm /home/c1tech/./DownloadVoskModel.py
echo "-------------------------------------"
echo "Configuring User Groups"
echo "-------------------------------------"
usermod -a -G dialout c1tech
usermod -a -G audio c1tech
usermod -a -G video c1tech
usermod -a -G input c1tech
echo "c1tech user added to dialout, audio, video & input groups"
echo "-------------------------------------"
echo "Installing PJSIP"
echo "-------------------------------------"
url="https://github.com/pjsip/pjproject.git"
folder="/home/c1tech/pjproject"
[ -d "${folder}" ] && rm -rf "${folder}"    
git clone "${url}" "${folder}"
cd /home/c1tech/pjproject
./configure --prefix=/usr --enable-shared
make dep -j4 
make -j4
make install
# Update shared library links.
ldconfig
# Verify that pjproject has been installed in the target location
ldconfig -p | grep pj
cd /home/c1tech/
# IF COMPILING ON ARM64:
# sudo nano /usr/include/pj/config.h
#   define PJ_IS_LITTLE_ENDIAN  1
#   define PJ_IS_BIG_ENDIAN     0
echo "-------------------------------------"
echo "Installing USB Auto Mount"
echo "-------------------------------------"
apt install -q -y liblockfile-bin liblockfile1 lockfile-progs
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

folder="/home/c1tech/C1"
[ -d "${folder}" ] && rm -rf "${folder}"

folder="/home/c1tech/C1-Control-Panel"
[ -d "${folder}" ] && rm -rf "${folder}"    

git clone "${url}" "${folder}"
cd /home/c1tech/C1-Control-Panel/Panel
# Build Qt App
touch -r *.*
qmake
make -j4 

mv /home/c1tech/C1-Control-Panel/C1 /home/c1tech/
chown -R c1tech:c1tech /home/c1tech/C1
chown -R c1tech:c1tech /home/c1tech/C1-Control-Panel
chmod +x /home/c1tech/C1/ExecStart.sh
echo "-------------------------------------"
echo "Creating Service for Contold Panel Application"
echo "-------------------------------------"
journalctl --vacuum-time=60d
loginctl enable-linger c1tech

mkdir -p /home/c1tech/.config/systemd/user/default.target.wants/
chown -R c1tech:c1tech /home/c1tech/.config
export "XDG_RUNTIME_DIR=/run/user/$UID"
export "DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus"

cat > /home/c1tech/.config/systemd/user/orcp.service << "EOF"
[Unit]
Description=C1Tech Operating Room Control Panel V2.0

[Service]
Environment="XDG_RUNTIME_DIR=/run/user/$UID"
Environment="DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus"
Environment="QT_QPA_PLATFORM=eglfs"
Environment="QT_QPA_EGLFS_ALWAYS_SET_MODE=1"
# Environment="QT_QPA_EGLFS_HIDECURSOR=1"
ExecStart=/bin/sh -c '/home/c1tech/C1/ExecStart.sh'
Restart=always

[Install]
WantedBy=default.target
EOF
runuser -l c1tech -c 'export XDG_RUNTIME_DIR=/run/user/$UID && export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus && systemctl --user daemon-reload && systemctl --user enable orcp'
# systemctl --user daemon-reload
# systemctl --user enable orcp --now
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
# By default ubuntu-text is active ÷
# /usr/share/plymouth/themes/ubuntu-text/ubuntu-text.plymouth
# We Will use bgrt (which is same as spinner but manufacture logo is enabled) theme with our custom logo
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
# Give c1tech Reboot Permision, CAUTION: This will break user connection to systemctl!
apt autoremove -y -q
chown root:c1tech /bin/systemctl
chmod 4755 /bin/systemctl
init 6
echo "-------------------------------------"
echo "Test Mic and Spk"
echo "-------------------------------------"
sudo apt install -q -y lame sox libsox-fmt-mp3

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