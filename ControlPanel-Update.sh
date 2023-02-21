#!/bin/bash -e

# Copyleft (c) 2022.
# -------==========-------
# Ubuntu Server 22.04.01
# Hostname: orcp6-5
# Username: c1tech
# Password: 1478963
# -------==========-------
# To Run This Script
# wget https://raw.githubusercontent.com/Hamid-Najafi/C1-Control-Panel/main/ControlPanel-Update.sh -O CP-Update.sh && chmod +x CP-Update.sh && sudo ./CP-Update.sh
# OR
# wget https://b2n.ir/e44282 -O CP-Update.sh && chmod +x CP-Update.sh && sudo ./CP-Update.sh
# -------==========-------
echo "-------------------------------------"
echo "Updating Contold Panel Application"
echo "-------------------------------------"
url="https://github.com/Hamid-Najafi/C1-Control-Panel.git"

folder="/home/c1tech/C1"
[ -d "${folder}" ] && rm -rf "${folder}"

folder="/home/c1tech/C1-Control-Panel"
[ -d "${folder}" ] && rm -rf "${folder}"    

git clone "${url}" "${folder}"
cd /home/c1tech/C1-Control-Panel/Panel
# Build Qt App
# make distclean
touch -r *.*
qmake
make -j4 
mv panel /home/c1tech/C1/

cp -r /home/c1tech/C1-Control-Panel/C1 /home/c1tech/
chown -R c1tech:c1tech /home/c1tech/C1
chown -R c1tech:c1tech /home/c1tech/C1-Control-Panel
chmod +x /home/c1tech/C1/ExecStart.sh
echo "-------------------------------------"
echo "Done, Performing System Reboot"
echo "-------------------------------------"
rm /home/c1tech/CP-Update.sh
runuser -l c1tech -c 'export XDG_RUNTIME_DIR=/run/user/$UID && export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus && systemctl --user restart orcp'
# init 6