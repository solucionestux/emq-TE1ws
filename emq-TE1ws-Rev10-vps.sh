#!/bin/sh
echo Actualizando sistema 
apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y
############################################
echo instalando pre-requisitos
######################################################################################################
#!/bin/sh
apt-get install git -y
apt-get install screen -y
apt-get install gcc -y
apt-get install g++ -y
apt-get install make -y
apt-get install cmake -y
apt-get install libasound2-dev -y
apt-get install libudev-dev -y
apt-get install libusb-1.0-0-dev -y
apt-get install libgps-dev -y
apt-get install libx11-dev -y
apt-get install libfftw3-dev -y
apt-get install libpulse-dev -y
apt-get install build-essential -y
apt-get install alsa-utils -y
apt-get install rsyslog -y
apt-get install logrotate -y
apt-get install gpsd -y
apt-get install qt4-qmake -y
apt-get install libtool -y
apt-get install autoconf -y
apt-get install automake -y
apt-get install python-pkg-resources -y
apt-get install sox -y
apt-get install git-core -y
apt-get install libi2c-dev -y
apt-get install i2c-tools -y
apt-get install lm-sensors -y
apt-get install wiringpi -y
apt-get install chkconfig -y
apt-get install wavemon -y
apt-get install python3 -y
apt-get libffi-dev -y
apt-get libssl-dev -y
apt-get cargo -y 
apt-get sed -y
apt install python3-pip -y
apt install python3 
apt install python3-distutils -y
apt install python3-twisted -y
apt install python3-bitarray -y
apt install python3-dev -y
python3 get-pip.py
apt install python3-websockets
apt install python3-psutil
apt-get install python3-serial
apt install python3-gpiozero -y
apt-get install gpsd gpsd-clients python-gps -y
apt install socket
apt install threading
apt install queue
apt install sys
apt install os
apt install time
apt install re
apt install configparser
apt install datetime
apt install signal
apt install datetime
apt install bisect
apt install struct
apt install ansi2html
apt install logrotate
pip3 install ansi2html
apt-get install python-pip -y
apt-get install python-dev -y
 
##################
mkdir /var/www
mkdir /var/www/html

cat > /etc/default/gpsd  <<- "EOF"
USBAUTO="False"
DEVICES="/dev/ttyACM0"
START_DAEMON="true"
GPSD_OPTIONS="-n"
GPSD_SOCKET="/var/run/gpsd.sock"

EOF

gpsd /dev/ttyACM0 -F /var/run/gpsd.sock

#################
echo iniciando instalacion

cd /opt
git clone https://github.com/iu5jae/pYSFReflector.git
cd pYSFReflector/
#cp YSFReflector /usr/local/sbin/
#cp YSFReflector.ini /usr/local/etc/

cp YSFReflector /usr/local/bin/
chmod +x /usr/local/bin/YSFReflector
mkdir /etc/YSFReflector

cp YSFReflector.ini /etc/YSFReflector/
cd /etc/YSFReflector/
sed -i 's/FilePath=\/var\/log/FilePath=\/var\/log\/YSFReflector/' YSFReflector.ini
sed -i 's/42395/42000/' YSFReflector.ini
sed -i 's/FileRotate=1/FileRotate=0/' YSFReflector.ini
cd /opt/pYSFReflector/
cp deny.db /usr/local/etc/
chmod +x /usr/local/bin/YSFReflector
cd systemd/
cp YSFReflector.service /lib/systemd/system

groupadd mmdvm
useradd mmdvm -g mmdvm -s /sbin/nologin
mkdir /var/log/YSFReflector
chown -R mmdvm:mmdvm /var/log/YSFReflector

###############################

mkdir /opt/YSF2DMR

cd /opt
git clone https://github.com/juribeparada/MMDVM_CM.git
cp -r /opt/MMDVM_CM/YSF2DMR /opt/
cd YSF2DMR
make
make install

cd /opt
git clone https://github.com/osmocom/rtl-sdr.git
cd rtl-sdr/
mkdir build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
make install
ldconfig

cd /opt
git  clone https://github.com/asdil12/kalibrate-rtl.git
cd kalibrate-rtl/
./bootstrap
./configure
make
make install

##################################################################
#multimon-ng
cd /opt
git clone https://github.com/EliasOenal/multimon-ng.git
cd multimon-ng/
mkdir build
cd build
cmake ..
make
make install

cd /opt
git clone https://github.com/asdil12/pymultimonaprs.git
cd pymultimonaprs
python2 setup.py install

############################################################################################
#web
cd /opt/
git clone --recurse-submodules -j8 https://github.com/dg9vh/MMDVMHost-Websocketboard
chown -R mmdvm:mmdvm /opt/MMDVMHost-Websocketboard
#
cat > /opt/MMDVMHost-Websocketboard/logtailer.ini <<- "EOF"
[DEFAULT]
# No need to touch this. If you want to bind it to a specific IP-address (if there are more than one interface to the
# network you can set your ip here - but default it listens on every interface
Host=0.0.0.0

# If changeing the port please change it also in the index.html-file at the parts where you find:
# new WebSocket("ws://" + window.location.hostname ...
Port=5678

# set to True if SSL will be used
Ssl=False
SslCert=/path/to/cert
SslKey=/path/to/keyfile

# This defines the maximum amount of loglines to be sent on initial opening of the dashboard
MaxLines=500

# Keep this parameter synchrone to Filerotate in MMDVM.ini/DMRHost.ini - if 0 then False, if 1 then True
Filerotate=False
#True

[MMDVMHost]
# Don't throw away the trailing slash! It is important but check logfile-location and Prefix twice :-)
Logdir=/var/log/mmdvm/

# Change this to DMRHost, if you are using DMRHost and configured this as log-prefix in the host-ini.
Prefix=MMDVMHost
# if you want to have the operator-names as popup with the callsigns, set this parts = 1 and the LookupFile to
# the right position. On MMDVMHost comment out the DMRIDs.dat-line to have the DMRIds and not the callsigns in the
# logfile to have the callsigns with names transported to the dashboard.
DMR_ID_Lookup=1
DMR_ID_LookupFile=/opt/MMDVMHost/DMRIds.dat

# Location of your MMDVM.ini/DMRHost.ini or similar
MMDVM_ini=/opt/MMDVMHost/MMDVM.ini

# Localtion of your MMDVMHost/DMRHost-binary
MMDVM_bin=/opt/MMDVMHost/MMDVMHost
#/usr/local/bin/MMDVMHost

[DAPNETGateway]
# Don't throw away the trailing slash! It is important but check logfile-location and Prefix twice :-)
Logdir=/var/log/mmdvm
#/mnt/ramdisk/
Prefix=MMDVMHost
#DAPNETGateway

[ServiceMonitoring]
# Here you list your Services to be monitored. Just add additional lines if needed but be sure to count them up
BinaryName1=MMDVMHost
BinaryName2=DMRGateway
BinaryName3=DGIdGateway
BinaryName4=YSF2DMR



EOF
############################
cat > /lib/systemd/system/http.server-mmdvmh.service <<- "EOF"
[Unit]
Description=Python3 http.server.mmdvmhost
After=network.target

[Service]
User=root
Type=simple
#User=mmdvm
#Group=mmdvm
Restart=always
ExecStartPre=/bin/sleep 30
# Modify for different location of Python3 or other port
ExecStart=/usr/bin/python3 -m http.server 80 --directory /opt/MMDVMHost-Websocketboard/html

[Install]
WantedBy=multi-user.target


EOF
#
cat > /lib/systemd/system/logtailer-mmdvmh.service <<- "EOF"
[Unit]
Description=Python3 logtailer for MMDVMDash
After=network.target

[Service]
Type=simple
User=mmdvm
Group=mmdvm
Restart=always
ExecStartPre=/bin/sleep 30
# Modify for different location of Python3 or other port
WorkingDirectory=/opt/MMDVMHost-Websocketboard/
ExecStart=/usr/bin/python3 /opt/MMDVMHost-Websocketboard/logtailer.py

[Install]
WantedBy=multi-user.target


EOF
#
git clone --recurse-submodules -j8 https://github.com/dg9vh/WSYSFDash
cd /opt/WSYSFDash/
chown -R mmdvm /opt/WSYSFDash
#
cat > /opt/WSYSFDash/logtailer.ini <<- "EOF"
[DEFAULT]
# No need to change this line below
Host=0.0.0.0
Port=5678
# set to True if SSL will be used
Ssl=False
SslCert=/path/to/fullchain.pem
SslKey=/path/to/privkey.pem

# This defines the maximum amount of loglines to be sent on initial opening of the dashboard
MaxLines=500

# Keep this parameter synchrone to Filerotate in YSFReflector.ini - if 0 then False, if 1 then True
Filerotate=False
#True

# You can use the logtailer-Service for more than one reflector running on your system.
# To do this, just copy the [YSFReflectorN]-Section into a new one, renumber it and modify the Logdir and Prefix.
# To use this on systems with more than one reflector, it is recommended to use a real webserver to host the html-files.

[YSFReflector]
# Localtion of your YSFReflector-binary
YSFReflector_bin=/usr/local/bin/YSFReflector

Logdir=/var/log/YSFReflector/
Prefix=YSFReflector

#[YSFReflector2]
#Logdir=/var/log/YSFReflector2/
#Prefix=YSFReflector



EOF
#
cat > /lib/systemd/system/http.server-ysf.service <<- "EOF"
[Unit]
Description=Python3 http.server-ysf
After=network.target

[Service]
User=root
ExecStartPre=/bin/sleep 10
Type=simple
#User=mmdvm
#Group=mmdvm
Restart=always
# Modify for different location of Python3 or other port
ExecStart=/usr/bin/python3 -m http.server 80 --directory /opt/WSYSFDash/html

[Install]
WantedBy=multi-user.target

EOF
#
cat > /lib/systemd/system/logtailer-ysf.service <<- "EOF"
[Unit]
Description=Python3 logtailer for WSYSFDash
After=network.target

[Service]
ExecStartPre=/bin/sleep 10
Type=simple
User=mmdvm
Group=mmdvm
Restart=always
# Modify for different location of Python3 or location of files
WorkingDirectory=/opt/WSYSFDash/
ExecStart=/usr/bin/python3 /opt/WSYSFDash/logtailer.py

[Install]
WantedBy=multi-user.target


EOF
#

chmod +777 /var/log
mkdir /var/log/ysf2dmr
mkdir /var/log/mmdvm
chmod +777 /var/log/*

cd  /opt/MMDVMHost-Websocketboard/html/data/
rm TG_List.csv
wget https://raw.githubusercontent.com/hp3icc/emq-TE1ws/main/TG_List.csv

####################################

cd /boot
sed -i 's/console=serial0,115200 //' cmdline.txt

systemctl stop serial-getty@ttyAMA0.service
systemctl stop bluetooth.service
systemctl disable serial-getty@ttyAMA0.service
systemctl disable bluetooth.service

sed -i 's/#dtparam=i2c_arm=on/dtparam=i2c_arm=on/' config.txt
sed -i 's/dtparam=audio=on/#dtparam=audio=on/' config.txt

echo "enable_uart=1" >> config.txt
echo "dtoverlay=pi3-disable-bt" >> config.txt
echo "dtparam=spi=on" >> config.txt

##################
cat > /lib/systemd/system/monp.service  <<- "EOF"
[Unit]
Description=modprobe i2c-dev
#Wants=network-online.target
#After=syslog.target network-online.target
[Service]
User=root
#ExecStartPre=/bin/sleep 1800
ExecStart=modprobe i2c-dev
[Install]
WantedBy=multi-user.target
EOF

##########
cd /opt
git clone https://github.com/g4klx/MMDVMHost.git
cd MMDVMHost/
make
make install
git clone https://github.com/hallard/ArduiPi_OLED
cd ArduiPi_OLED
make
cd /opt/MMDVMHost/
make clean
make -f Makefile.Pi.OLED 

groupadd mmdvm 
useradd mmdvm -g mmdvm -s /sbin/nologin 
chown mmdvm /var/log/

#############################################################################################################################################################
######
cat > /bin/menu-mm-rtl <<- "EOF"
#!/bin/bash
while : ; do
choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion" 20 50 11 \
1 " Editar Multimon-ng  APRS " \
2 " Iniciar APRS " \
3 " Detener APRS " \
4 " Menu Principal " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
nano /etc/pymultimonaprs.json;;
2)
systemctl restart multimon-rtl.service && sudo systemctl enable multimon-rtl.service;;
3)
systemctl stop multimon-rtl.service && sudo systemctl disable multimon-rtl.service;;
4)
break;
esac
done
exit 0
EOF
###menu
cat > /bin/menu <<- "EOF"
#!/bin/bash

while : ; do

choix=$(whiptail --title "TE1ws-Rev10 Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion:" 22 56 14 \
1 " APRS Direwolf Analogo" \
2 " APRS Direwolf RTL-SDR " \
3 " APRS Multimon-ng " \
4 " APRS Ionosphere " \
5 " MMDVMHost " \
6 " Dvswitch " \
7 " pYSFReflector " \
8 " YSF2DMR " \
9 " HBLink Server " \
10 " FreeDMR Server " \
11 " Editar WiFi " \
12 " Reiniciar Raspberry " \
13 " APAGAR Raspberry " \
14 " Salir del menu " 3>&1 1>&2 2>&3)

exitstatus=$?

#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi

# case : action en fonction du choix

case $choix in
1)
menu-dw-analogo;;
2)
menu-dw-rtl;;
3)
menu-mm-rtl;;
4)
menu-ionos;;
5)
menu-mmdvm;;
6)
menu-dvs;;
7)
menu-ysf;;
8)
menu-ysf2dmr;;
9)
menu-hbl;;
10)
menu-fdmr;;
11)
menu-wifi;;
12)
sudo reboot ;;
13)
menu-apagar;;
14)
break;


esac

done
exit 0


EOF
##################################################
cat > /bin/menu-fdmr <<- "EOF"
#!/bin/bash

while : ; do

choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion" 20 50 11 \
1 " Editar FreeDMR Server " \
2 " Editar Interlink  " \
3 " Editar HBMon2  " \
4 " Parrot on  " \
5 " Parrot off  " \
6 " Iniciar FreeDMR Server  " \
7 " Detener FreeDMR Server   " \
8 " Dashboard HBMon2 on " \
9 " Dashboard HBMon2 off  " \
10 " Menu Principal " 3>&1 1>&2 2>&3)

exitstatus=$?

#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi

# case : action en fonction du choix

case $choix in
1)
nano /opt/FreeDMR/config/FreeDMR.cfg ;;
2)
nano /opt/FreeDMR/config/rules.py ;;
3)
nano /opt/HBMonv2/config.py ;;
4)
systemctl stop fdmrparrot.service && sudo systemctl start fdmrparrot.service && sudo systemctl enable fdmrparrot.service ;;
5)
systemctl stop fdmrparrot.service &&  sudo systemctl disable fdmrparrot.service ;;
6)
systemctl stop proxy.service && sudo systemctl start proxy.service && sudo systemctl enable proxy.service && sudo systemctl stop freedmr.service && sudo systemctl start freedmr.service && sudo systemctl enable freedmr.service ;;
7)
systemctl stop freedmr.service &&  sudo systemctl disable freedmr.service ;;
8)
systemctl stop hbmon2.service && sudo systemctl start hbmon2.service && sudo systemctl enable hbmon2.service && sudo cp -r /opt/HBMonv2/html/* /var/www/html/ && sudo systemctl restart lighttpd.service && sudo systemctl enable lighttpd.service && sudo chown -R www-data:www-data /var/www/html && sudo chmod +777 /var/www/html/* ;;
9)
systemctl stop hbmon2.service && sudo systemctl disable hbmon2.service && sudo systemctl disable lighttpd.service && sudo systemctl stop lighttpd.service && sudo rm -r  /var/www/html/* ;;
10)
break;




esac

done
exit 0




EOF
############################
cat > /bin/menu-hbl <<- "EOF"
#!/bin/bash

while : ; do

choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion" 20 50 11 \
1 " Editar HBLink Server " \
2 " Editar Interlink  " \
3 " Editar HBMon  " \
4 " Parrot on  " \
5 " Parrot off  " \
6 " Iniciar HBLink Server  " \
7 " Detener HBLink Server   " \
8 " Dashboard HBMon on " \
9 " Dashboard HBMon off  " \
10 " Menu Principal " 3>&1 1>&2 2>&3)

exitstatus=$?

#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi

# case : action en fonction du choix

case $choix in
1)
nano /opt/HBlink3/hblink.cfg ;;
2)
nano /opt/HBlink3/rules.py ;;
3)
nano /opt/HBmonitor/config.py ;;
4)
systemctl stop hbparrot.service && sudo systemctl start hbparrot.service && sudo systemctl enable hbparrot.service ;;
5)
systemctl stop hbparrot.service &&  sudo systemctl disable hbparrot.service ;;
6)
systemctl stop hblink.service && sudo systemctl start hblink.service && sudo systemctl enable hblink.service ;;
7)
systemctl stop hblink.service &&  sudo systemctl disable hblink.service ;;
8)
systemctl stop hbmon.service && sudo systemctl start hbmon.service && sudo systemctl enable hbmon.service;;
9)
systemctl stop hbmon.service && sudo systemctl disable hbmon.service ;;
10)
break;




esac

done
exit 0




EOF

######menu-wifi
cat > /bin/menu-wifi <<- "EOF"
#!/bin/bash
while : ; do
choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion" 20 50 11 \
1 " Editar redes WiFi " \
2 " Reiniciar dispositivo WiFi " \
3 " Buscar redes wifi cercanas " \
4 " Ver intensidad de WIFI  " \
5 " Menu Principal " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
nano /etc/wpa_supplicant/wpa_supplicant.conf ;;
2)
ifconfig wlan0 down && sudo ifconfig wlan0 up ;;
3)
sudo iwlist wlan0 scan | grep ESSID | grep -o '"[^"]\+"' >> ssid.txt && nano ssid.txt && rm ssid.txt ;;
4)
wavemon ;;
5)
break;
esac
done
exit 0
EOF


####menu-mmdvm
cat > /bin/menu-mmdvm <<- "EOF"
#!/bin/bash
while : ; do
choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion" 20 50 10 \
1 " Editar MMDVMHost " \
2 " Iniciar MMDVMHost " \
3 " Detener MMDVMHost " \
4 " Dashboard ON " \
5 " Dashboard Off " \
6 " Editar Puerto WebServer " \
7 " Editar HTML  " \
8 " actualizar nombres de TG y sala europelink  " \
9 " actualizar nombres de TG y sala worldlink " \
10 " Menu Principal " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
nano /opt/MMDVMHost/MMDVM.ini;;
2)
sh /opt/MMDVMHost/DMRIDUpdate.sh && sudo systemctl enable dmrid-mmdvm.service ;;
3)
systemctl stop mmdvmh.service && sudo systemctl stop dmrid-mmdvm.service && sudo systemctl disable dmrid-mmdvm.service;;
4)
systemctl restart logtailer-mmdvmh.service && sudo systemctl enable logtailer-mmdvmh.service && sudo systemctl restart http.server-mmdvmh.service && sudo systemctl enable http.server-mmdvmh.service ;;
5)
systemctl stop logtailer-mmdvmh.service && sudo systemctl disable logtailer-mmdvmh.service && sudo systemctl stop http.server-mmdvmh.service && sudo systemctl disable http.server-mmdvmh.service ;;
6)
nano /lib/systemd/system/http.server-mmdvmh.service && sudo systemctl daemon-reload && sudo systemctl restart http.server-mmdvmh.service ;;
7)
nano /opt/MMDVMHost-Websocketboard/html/index.html ;;
8)
cd  /opt/MMDVMHost-Websocketboard/html/data/ && wget https://raw.githubusercontent.com/hp3icc/emq-TE1ws/main/TG_List.csv && rm *.csv* && wget https://raw.githubusercontent.com/hp3icc/emq-TE1ws/main/TG_List.csv ;;
9)
cd  /opt/MMDVMHost-Websocketboard/html/data/ && wget https://raw.githubusercontent.com/hp3icc/emq-TE1ws/main/TG_List.csv && rm *.csv* && wget https://raw.githubusercontent.com/hp3icc/emq-TE1ws/main/TG_List-WL.csv && sudo mv TG_List-WL.csv TG_List.csv;;
10)
break;
esac
done
exit 0
EOF
########menu-ysf
cat > /bin/menu-ysf <<- "EOF"
#!/bin/bash
while : ; do
choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion" 20 50 11 \
1 " Editar pYSFReflector Server " \
2 " Iniciar Reflector  " \
3 " Detener Reflector  " \
4 " Dashboard on  " \
5 " Dashboard off  " \
6 " Editar Puerto WebServer  " \
7 " Editar HTML  " \
8 " Menu Principal " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
nano /etc/YSFReflector/YSFReflector.ini ;;
2)
systemctl stop YSFReflector.service && sudo systemctl start YSFReflector.service  && sudo systemctl enable YSFReflector.service ;;
3)
systemctl stop YSFReflector.service && sudo systemctl disable YSFReflector.service ;;
4)
systemctl restart logtailer-ysf.service && sudo systemctl enable logtailer-ysf.service && sudo systemctl restart http.server-ysf.service && sudo systemctl enable http.server-ysf.service ;;
5)
systemctl stop logtailer-ysf.service && sudo systemctl disable logtailer-ysf.service && sudo systemctl stop http.server-ysf.service && sudo systemctl disable http.server-ysf.service ;;
6)
nano /lib/systemd/system/http.server-ysf.service && sudo systemctl daemon-reload && sudo systemctl restart http.server-ysf.service ;;
7)
nano /opt/WSYSFDash/html/index.html ;;
8)
break;
esac
done
exit 0
EOF
##########menu-dvs
cat > /bin/menu-dvs <<- "EOF"
#!/bin/bash
while : ; do
choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion" 20 50 11 \
1 " Editar Dvswitch Server " \
2 " Iniciar Dvswitch  " \
3 " Detener Dvswitch  " \
4 " Dashboard on  " \
5 " Dashboard off  " \
6 " Menu Principal " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
/usr/local/dvs/dvs ;;
2)
systemctl restart dmrid-dvs.service && sudo systemctl restart analog_bridge.service && sudo systemctl enable analog_bridge.service && sudo systemctl enable dmrid-dvs.service ;;
3)
systemctl stop mmdvm_bridge.service && sudo systemctl stop dmrid-dvs.service && sudo systemctl stop analog_bridge.service && sudo systemctl disable analog_bridge.service && sudo systemctl disable mmdvm_bridge.service && sudo systemctl disable dmrid-dvs.service ;;
4)
cp -r /var/www/web-dvs/* /var/www/html/ && sudo systemctl restart lighttpd.service && sudo systemctl enable lighttpd.service && sudo chown -R www-data:www-data /var/www/html && sudo chmod +777 /var/www/html/* ;;
5)
systemctl disable lighttpd.service && sudo systemctl stop lighttpd.service && sudo rm -r  /var/www/html/* ;;
6)
break;
esac
done
exit 0
EOF
###menu-apagar
cat > /bin/menu-apagar <<- "EOF"
#!/bin/bash
while : ; do
choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion" 11 85 3 \
1 " Iniciar apagado seguro" \
2 " Retornar  menu " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
shutdown -h now
;;
2) break;
esac
done
exit 0
EOF
###menu-cp-rtl
cat > /bin/menu-cp-rtl <<- "EOF"
#!/bin/bash
while : ; do
choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion" 20 50 11 \
1 " Editar Direwolf " \
2 " Iniciar APRS " \
3 " Detener APRS " \
4 " Menu Principal " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
nano /opt/direwolf/dw.conf;;
2)
systemctl restart direwolf.service && sudo systemctl enable direwolf.service;;
3)
systemctl stop direwolf.service && sudo systemctl disable direwolf.service;;
4)
 break;
esac
done
exit 0
EOF
#####menu-dw-analogo
cat > /bin/menu-dw-analogo <<- "EOF"
#!/bin/bash
while : ; do
choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion" 20 50 11 \
1 " Editar Direwolf Analogo " \
2 " Iniciar APRS " \
3 " Detener APRS " \
4 " Menu Principal " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
nano /opt/direwolf/dw.conf;;
2)
systemctl restart direwolf.service && sudo systemctl enable direwolf.service;;
3)
systemctl stop direwolf.service && sudo systemctl disable direwolf.service;;
4)
break;
esac
done
exit 0
EOF
######menu-dw-rtl
cat > /bin/menu-dw-rtl <<- "EOF"
#!/bin/bash
while : ; do
choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion" 20 50 11 \
1 " Editar Direwolf RTL " \
2 " Editar RTL-SDR " \
3 " Iniciar APRS RX-IGate " \
4 " Detener APRS RX-IGate " \
5 " Menu Principal " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
nano /opt/direwolf/sdr.conf ;;
2)
nano /opt/direwolf/rtl.sh ;;
3)
systemctl restart direwolf-rtl.service && sudo systemctl enable direwolf-rtl.service;;
4)
systemctl stop direwolf-rtl.service && sudo systemctl disable direwolf-rtl.service;;
5)
break;
esac
done
exit 0
EOF

#####
######menu-ysf2dmr
cat > /bin/menu-ysf2dmr <<- "EOF"
#!/bin/bash
while : ; do
choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion" 20 50 11 \
1 " Editar YSF2DMR " \
2 " Iniciar YSF2DMR " \
3 " Detener YSF2DMR " \
4 " Menu Principal " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
nano /opt/YSF2DMR/YSF2DMR.ini;;
2)
sh /opt/YSF2DMR/DMRIDUpdate.sh && sudo systemctl enable dmrid-ysf2dmr.service;;
3)
systemctl stop ysf2dmr.service && sudo systemctl stop dmrid-ysf2dmr.service && sudo systemctl disable dmrid-ysf2dmr.service;;
4)
break;
esac
done
exit 0
EOF
########ionosphere
mkdir /opt/ionsphere 
cd /opt/ionsphere 
wget https://github.com/cceremuga/ionosphere/releases/download/v1.0.0-beta1/ionosphere-raspberry-pi.tar.gz
tar vzxf ionosphere-raspberry-pi.tar.gz

cd /opt/ionsphere/ionosphere-raspberry-pi

cat > /opt/ionsphere/ionosphere-raspberry-pi/ionos.sh <<- "EOF"
#!/bin/sh
PATH=/bin:/usr/bin:/usr/local/bin
unset LANG
/opt/ionsphere/ionosphere-raspberry-pi/ionosphere
EOF

chmod +x /opt/ionsphere/ionosphere-raspberry-pi/ionosphere
chmod +x /opt/ionsphere/ionosphere-raspberry-pi/ionos.sh
chmod +777 /opt/ionsphere/ionosphere-raspberry-pi/ionos.sh
###nano /opt/ionsphere/ionosphere-raspberry-pi/config/config.yml

#####menu-ionos
cat > /bin/menu-ionos <<- "EOF"
#!/bin/bash
while : ; do
choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion" 20 50 11 \
1 " Editar Ionosphere  APRS " \
2 " Iniciar APRS " \
3 " Detener APRS " \
4 " Menu Principal " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
nano /opt/ionsphere/ionosphere-raspberry-pi/config/config.yml ;;
2)
systemctl enable ionos.service && systemctl restart ionos.service ;;
3)
systemctl stop ionos.service && sudo systemctl disable ionos.service ;;
4)
break;
esac
done
exit 0
EOF
################################
cat > /lib/systemd/system/ionos.service <<- "EOF"
[Unit]
Description=Ionphere-RTL Service
Wants=network-online.target
After=syslog.target network-online.target
[Service]
User=root
Type=simple
Restart=always
RestartSec=3
StandardOutput=null
WorkingDirectory=/opt/ionsphere/ionosphere-raspberry-pi
#ExecStartPre=/bin/sleep 30
ExecStart=sh /opt/ionsphere/ionosphere-raspberry-pi/ionos.sh
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
[Install]
# To make the network-online.target available
# systemctl enable systemd-networkd-wait-online.service
WantedBy=network-online.target
EOF
##########################################
###################
cat > /lib/systemd/system/dmrid-mmdvm.service  <<- "EOF"
[Unit]
Description=DMRIDupdate MMDVMHost
Wants=network-online.target
After=syslog.target network-online.target

[Service]
User=root
#ExecStartPre=/bin/sleep 1800
ExecStart=/opt/MMDVMHost/DMRIDUpdate.sh

[Install]
WantedBy=multi-user.target

EOF
###################
cat > /lib/systemd/system/mmdvmh.service  <<- "EOF"
[Unit]
Description=MMDVM Host Service
After=syslog.target network.target

[Service]
User=root
WorkingDirectory=/opt/MMDVMHost
#ExecStartPre=/bin/sleep 10
ExecStart=/opt/MMDVMHost/MMDVMHost /opt/MMDVMHost/MMDVM.ini
#ExecStart=/usr/bin/screen -S MMDVMHost -D -m /home/MMDVMHost/MMDVMHost /home/M$
ExecStop=/usr/bin/screen -S MMDVMHost -X quit

[Install]
WantedBy=multi-user.target

EOF
################
cat > /lib/systemd/system/direwolf.service  <<- "EOF"
[Unit]
Description=DireWolf is a software "soundcard" modem/TNC and APRS decoder
Documentation=man:direwolf
AssertPathExists=/opt/direwolf/dw.conf

[Unit]
Description=Direwolf Service
#Wants=network-online.target
After=sound.target syslog.target
#network-online.target

[Service]
User=root
ExecStart=direwolf -c /opt/direwolf/dw.conf
#ExecStart=/usr/bin/direwolf -t 0 -c /opt/direwolf/dw.conf
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=direwolf

[Install]
WantedBy=multi-user.target

EOF
#####
cat > /lib/systemd/system/dmrid-ysf2dmr.service  <<- "EOF"
[Unit]
Description=DMRIDupdate YSF2DMR
Wants=network-online.target
After=syslog.target network-online.target

[Service]
User=root
#ExecStartPre=/bin/sleep 1800
ExecStart=/opt/YSF2DMR/DMRIDUpdate.sh

[Install]
WantedBy=multi-user.target

EOF
#########
cat > /lib/systemd/system/direwolf-rtl.service  <<- "EOF"
[Unit]
Description=Direwolf-RTL Service
Wants=network-online.target
After=syslog.target network-online.target

[Service]
User=root
#ExecStartPre=/bin/sleep 1800
ExecStart=/opt/direwolf/rtl.sh
# | direwolf -c /home/pi/direwolf/sdr.conf

[Install]
WantedBy=multi-user.target
#ExecStart= /usr/local/bin/rtl_fm -M fm -f 144.39M -p 0 -s 24000 -g 42 - | /usr/local/bin/direwolf-rtl -c /home/pi/direwolf/sdr.conf -r 24000 -D 1 -B 1200 -
EOF
#############

cat > /lib/systemd/system/multimon-rtl.service  <<- "EOF"
[Unit]
Description=Direwolf-RTL Service
Wants=network-online.target
After=syslog.target network-online.target

[Service]
User=root
#ExecStartPre=/bin/sleep 1800
ExecStart=pymultimonaprs

[Install]
WantedBy=multi-user.target
EOF
#####################
cat > /lib/systemd/system/ysf2dmr.service  <<- "EOF"
[Unit]
Description=YSF2DMR Service
After=syslog.target network.target

[Service]
User=root
WorkingDirectory=/opt/YSF2DMR
ExecStartPre=/bin/sleep 30
ExecStart=/opt/YSF2DMR/YSF2DMR /opt/YSF2DMR/YSF2DMR.ini

[Install]
WantedBy=multi-user.target

EOF
############

###############
cat > /opt/MMDVMHost/MMDVM.ini  <<- "EOF"
[General]
Callsign=HP3ICC
Id=714000000
Timeout=300
Duplex=0
ModeHang=3
#RFModeHang=10
#NetModeHang=3
Display=None
#Display=OLED
Daemon=0

[Info]
RXFrequency=438800000
TXFrequency=438800000
Power=1
# The following lines are only needed if a direct connection to a DMR master is being used
Latitude=0.0
Longitude=0.0
Height=0
Location=Panama
Description=Multi-Mode-MMDVM
URL=www.google.co.uk

[Log]
# Logging levels, 0=No logging
DisplayLevel=1
FileLevel=1
FilePath=/var/log/mmdvm
FileRoot=MMDVMHost
FileRotate=0

[CW Id]
Enable=0
Time=10
# Callsign=

[DMR Id Lookup]
File=/opt/MMDVMHost/DMRIds.dat
Time=24

[NXDN Id Lookup]
File=NXDN.csv
Time=24

[Modem]
# Port=/dev/ttyACM0
Port=/dev/ttyAMA0
#Port=\\.\COM4
#Protocol=uart
# Address=0x22
TXInvert=1
RXInvert=0
PTTInvert=0
TXDelay=100
RXOffset=0
TXOffset=0
DMRDelay=0
RXLevel=50
TXLevel=50
RXDCOffset=0
TXDCOffset=0
RFLevel=50
# CWIdTXLevel=50
# D-StarTXLevel=50
DMRTXLevel=50
YSFTXLevel=50
# P25TXLevel=50
# NXDNTXLevel=50
# POCSAGTXLevel=50
FMTXLevel=50
RSSIMappingFile=RSSI.dat
UseCOSAsLockout=0
Trace=0
Debug=0

[Transparent Data]
Enable=0
RemoteAddress=127.0.0.1
RemotePort=40094
LocalPort=40095
# SendFrameType=0

[UMP]
Enable=0
# Port=\\.\COM4
Port=/dev/ttyACM1

[D-Star]
Enable=0
Module=C
SelfOnly=0
AckReply=1
AckTime=750
AckMessage=0
ErrorReply=1
RemoteGateway=0
# ModeHang=10
WhiteList=

[DMR]
Enable=1
Beacons=0
BeaconInterval=60
BeaconDuration=3
ColorCode=1
SelfOnly=0
EmbeddedLCOnly=1
DumpTAData=0
# Prefixes=234,235
# Slot1TGWhiteList=
# Slot2TGWhiteList=
CallHang=3
TXHang=4
# ModeHang=10
# OVCM Values, 0=off, 1=rx_on, 2=tx_on, 3=both_on, 4=force off
# OVCM=0

[System Fusion]
Enable=1
LowDeviation=0
SelfOnly=0
TXHang=4
RemoteGateway=1
# ModeHang=10

[P25]
Enable=0
NAC=293
SelfOnly=0
OverrideUIDCheck=0
RemoteGateway=0
TXHang=5
# ModeHang=10

[NXDN]
Enable=0
RAN=1
SelfOnly=0
RemoteGateway=0
TXHang=5
# ModeHang=10

[POCSAG]
Enable=0
Frequency=439987500

[FM]
Enable=0
# Callsign=HP3ICC
CallsignSpeed=20
CallsignFrequency=1000
CallsignTime=10
CallsignHoldoff=0
CallsignHighLevel=50
CallsignLowLevel=20
CallsignAtStart=1
CallsignAtEnd=1
CallsignAtLatch=0
RFAck=K
ExtAck=N
AckSpeed=20
AckFrequency=1750
AckMinTime=4
AckDelay=1000
AckLevel=50
# Timeout=180
TimeoutLevel=80
CTCSSFrequency=88.4
CTCSSThreshold=30
# CTCSSHighThreshold=30
# CTCSSLowThreshold=20
CTCSSLevel=20
KerchunkTime=0
HangTime=7
AccessMode=1
COSInvert=0
RFAudioBoost=1
MaxDevLevel=90
ExtAudioBoost=1

[D-Star Network]
Enable=0
GatewayAddress=127.0.0.1
GatewayPort=20010
LocalPort=20011
# ModeHang=3
Debug=0

[DMR Network]
Enable=1
# Type may be either 'Direct' or 'Gateway'. When Direct you must provide the Master's
# address as well as the Password, and for DMR+, Options also.
Type=Direct
Address=3021.master.brandmeister.network
Port=62031
#Local=62032
Password=*********
Jitter=360
Slot1=1
Slot2=1
# Options=
# ModeHang=3
Debug=0

[System Fusion Network]
Enable=1
LocalAddress=127.0.0.1
#LocalPort=3200
GatewayAddress=europelink.pa7lim.nl
GatewayPort=42000
# ModeHang=3
Debug=0

[P25 Network]
Enable=0
GatewayAddress=127.0.0.1
GatewayPort=42020
LocalPort=32010
# ModeHang=3
Debug=0

[NXDN Network]
Enable=0
Protocol=Icom
LocalAddress=127.0.0.1
LocalPort=14021
GatewayAddress=127.0.0.1
GatewayPort=14020
# ModeHang=3
Debug=0

[POCSAG Network]
Enable=0
LocalAddress=127.0.0.1
LocalPort=3800
GatewayAddress=127.0.0.1
GatewayPort=4800
# ModeHang=3
Debug=0

[TFT Serial]
# Port=modem
Port=/dev/ttyAMA0
Brightness=50

[HD44780]
Rows=2
Columns=16
# For basic HD44780 displays (4-bit connection)
# rs, strb, d0, d1, d2, d3
Pins=11,10,0,1,2,3
# Device address for I2C
I2CAddress=0x20
# PWM backlight
PWM=0
PWMPin=21
PWMBright=100
PWMDim=16
DisplayClock=1
UTC=0

[Nextion]
# Port=modem
Port=/dev/ttyAMA0
Brightness=50
DisplayClock=1
UTC=0
#Screen Layout: 0=G4KLX 2=ON7LDS
ScreenLayout=2
IdleBrightness=20

[OLED]
Type=3
Brightness=1
Invert=0
Scroll=0
Rotate=1
Cast=0
LogoScreensaver=0

[LCDproc]
Address=localhost
Port=13666
#LocalPort=13667
DimOnIdle=0
DisplayClock=1
UTC=0

[Lock File]
Enable=0
File=/tmp/MMDVM_Active.lck

[Remote Control]
Enable=0
Address=127.0.0.1
Port=7642


EOF
########
cat > /opt/YSF2DMR/YSF2DMR.ini  <<- "EOF"
[Info]
RXFrequency=438800000
TXFrequency=438800000
Power=1
Latitude=0.0
Longitude=0.0
Height=0
Location=Panama
Description=Multi-Mode
URL=www.google.co.uk

[YSF Network]
Callsign=HP3ICC
Suffix=ND
#Suffix=RPT
DstAddress=127.0.0.1
DstPort=42000
LocalAddress=127.0.0.1
#LocalPort=42013
EnableWiresX=0
RemoteGateway=0
HangTime=1000
WiresXMakeUpper=0
# RadioID=*****
# FICHCallsign=2
# FICHCallMode=0
# FICHBlockTotal=0
# FICHFrameTotal=6
# FICHMessageRoute=0
# FICHVOIP=0
# FICHDataType=2
# FICHSQLType=0
# FICHSQLCode=0
DT1=1,34,97,95,43,3,17,0,0,0
DT2=0,0,0,0,108,32,28,32,3,8
Daemon=0

[DMR Network]
Id=714000000
#XLXFile=XLXHosts.txt
#XLXReflector=950
#XLXModule=D
StartupDstId=714
# For TG call: StartupPC=0
StartupPC=0
Address=3021.master.brandmeister.network
Port=62031
Jitter=500
EnableUnlink=0
TGUnlink=4000
PCUnlink=0
# Local=62032
Password=****************
# Options=
TGListFile=TGList-DMR.txt
Debug=0

[DMR Id Lookup]
File=/opt/YSF2DMR/DMRIds.dat
Time=24
DropUnknown=0

[Log]
# Logging levels, 0=No logging
DisplayLevel=1
FileLevel=1
FilePath=/var/log/ysf2dmr/
FileRoot=YSF2DMR

[aprs.fi]
Enable=0
AprsCallsign=HP3ICC
Server=noam.aprs2.net
#Server=euro.aprs2.net
Port=14580
Password=12345
APIKey=APIKey
Refresh=240
Description=APRS Description


EOF
###################

cat > /etc/pymultimonaprs.json  <<- "EOF"
{
        "callsign": "HP3ICC-10",
        "passcode": "12345",
        "gateway": ["igates.aprs.fi:14580","noam.aprs2.net:14580"],
        "preferred_protocol": "any",
        "append_callsign": true,
        "source": "rtl",
        "rtl": {
                "freq": 144.390,
                "ppm": 0,
                "gain": 24,
                "offset_tuning": false,
                "device_index": 0
        },
        "alsa": {
                "device": "default"
        },
        "beacon": {
                "lat": 8.5212,
                "lng": -80.3598,
                "table": "/",
                "symbol": "r",
                "comment": "APRS RX-IGATE / Raspbian Proyect by hp3icc",
                "status": {
                        "text": "",
                        "file": false
                },
                "weather": false,
                "send_every": 300,
                "ambiguity": 0
        }
}
EOF
#######
cat > /opt/ionsphere/ionosphere-raspberry-pi/config/config.yml  <<- "EOF"
rtl:
  path: "rtl_fm"
  frequency: "144.390M"
  gain: "49.6"
  ppm-error: "0"
  squelch-level: "0"
  sample-rate: "22050"
  additional-flags: ""
multimon:
  path: "multimon-ng"
  additional-flags: ""
beacon:
  enabled: false
  call-sign: ""
  interval: 30m
  comment: ""
handlers:
- id: "4967ade5-7a97-416f-86bf-6e2ae8a5e581"
  name: "stdout"
- id: "b67ac5d5-3612-4618-88a9-a63d36a1777c"
  name: "aprsis"
  options:
    enabled: true
    server: "igates.aprs.fi:14580"
    call-sign: "HP3ICC-10"
    passcode: "12345"
    filter: ""
EOF
#############
cat > /opt/direwolf/rtl.sh  <<- "EOF"
#!/bin/sh
PATH=/bin:/usr/bin:/usr/local/bin
unset LANG
rtl_fm -M fm -f 144.39M -p 0 -s 24000 -g 42 - | /usr/local/bin/direwolf -c /opt/direwolf/sdr.conf -r 24000 -D 1 -B 1200 -
EOF
chmod +x /opt/direwolf/rtl.sh
###############################################
##############################
#dvswitch

cd /opt

wget http://dvswitch.org/buster

chmod +x buster

./buster

apt-get update -y

apt-get install dvswitch-server -y

cd /opt/YSFGateway/
sed -i 's/42000/42500/' YSFGateway.ini
#/opt/YSFGateway/YSFGateway.ini
systemctl restart ysfgateway.service

####
cat > /opt/MMDVM_Bridge/MMDVM_Bridge.ini  <<- "EOF"
[General]
Callsign=N0CALL
Id=1234567
Timeout=300
Duplex=0

[Info]
RXFrequency=147000000
TXFrequency=147000000
Power=1
Latitude=8.5211
Longitude=-80.3598
Height=0
Location=Panama
Description=MMDVM_Bridge
URL=https://groups.io/g/DVSwitch

[Log]
# Logging levels, 0=No logging, 1=Debug, 2=Message, 3=Info, 4=Warning, 5=Error, 6=Fatal
DisplayLevel=1
FileLevel=2
FilePath=/var/log/mmdvm
FileRoot=MMDVM_Bridge

[DMR Id Lookup]
File=/var/lib/mmdvm/DMRIds.dat
Time=24

[NXDN Id Lookup]
File=/var/lib/mmdvm/NXDN.csv
Time=24

[Modem]
Port=/dev/null
RSSIMappingFile=/dev/null
Trace=0
Debug=0

[D-Star]
Enable=0
Module=B

[DMR]
Enable=0
ColorCode=1
EmbeddedLCOnly=1
DumpTAData=0

[System Fusion]
Enable=0

[P25]
Enable=0
NAC=293

[NXDN]
Enable=0
RAN=1
Id=12345

[D-Star Network]
Enable=0
GatewayAddress=127.0.0.1
GatewayPort=20010
LocalPort=20011
Debug=0

[DMR Network]
Enable=0
Address=hblink.dvswitch.org
Port=62031
Jitter=360
Local=62032
Password=passw0rd
# for DMR+ see https://github.com/DVSwitch/MMDVM_Bridge/blob/master/DOC/DMRplus_startup_options.md
# for XLX the syntax is: Options=XLX:4009
# Options=
Slot1=0
Slot2=1
Debug=0

[System Fusion Network]
Enable=0
LocalAddress=0
LocalPort=3200
GatewayAddress=127.0.0.1
GatewayPort=4200
Debug=0

[P25 Network]
Enable=0
GatewayAddress=127.0.0.1
GatewayPort=42020
LocalPort=32010
Debug=0

[NXDN Network]
Enable=0
#LocalAddress=127.0.0.1
Debug=0
LocalPort=14021
GatewayAddress=127.0.0.1
GatewayPort=14020
EOF
####
cd /home/
cat > /home/requirements.txt <<- "EOF"
Twisted
dmr_utils3
bitstring
autobahn
jinja2==2.11.3

EOF
#
pip3 install setuptools wheel
pip3 install -r requirements.txt
rm requirements.txt
#
cd /opt/
wget https://bootstrap.pypa.io/get-pip.py
git clone https://github.com/lz5pn/HBlink3
mv /opt/HBlink3/ /opt/backup/
mv /opt/backup/HBlink3/ /opt/
mv /opt/backup/HBmonitor/ /opt/
mv /opt/backup/dmr_utils3/ /opt/
rm -r /opt/backup/
cd /opt/dmr_utils3
chmod +x install.sh
./install.sh
/usr/bin/python3 -m pip install --upgrade pip
pip install --upgrade dmr_utils3
cd /opt/HBlink3
cp hblink-SAMPLE.cfg hblink.cfg
cp rules-SAMPLE.py rules.py
chmod +x playback.py
mkdir /var/log/hblink
#
cat > /lib/systemd/system/hbparrot.service <<- "EOF"
[Unit]

Description=HB bridge all Service

After=network-online.target syslog.target

Wants=network-online.target

[Service]

StandardOutput=null

WorkingDirectory=/opt/HBlink3

RestartSec=3

ExecStart=/usr/bin/python3 /opt/HBlink3/playback.py -c /opt/HBlink3/playback.cfg

Restart=on-abort

[Install]

WantedBy=multi-user.target


EOF


#nano /lib/systemd/system/hblink.service
#Copiar este texto en el archivo
cat > /lib/systemd/system/hblink.service <<- "EOF"
[Unit]
Description=Start HBlink

After=multi-user.target

[Service]
User=root
ExecStart=/usr/bin/python3 /opt/HBlink3/bridge.py

[Install]
WantedBy=multi-user.target



EOF
############
rm /opt/HBlink3/*.json

###############################

#systemctl enable hblink

# Editar estos archivos para configurar el hblink
# nano /opt/HBlink3/hblink.cfg

# nano /opt/HBlink3/rules.py

#Ejecutar manualmente el servidor

# python3 /opt/HBlink3/bridge.py

### Instalar el  web monitor de HBLink.
cd /opt/HBmonitor
chmod +x install.sh
./install.sh
cp config_SAMPLE.py config.py
## Configurar el monitor
##nano /opt/HBmonitor/config.py
cd /opt/HBmonitor/
sed -i 's/8080/80/' config.py
#cp utils/hbmon.service /lib/systemd/system/
cat > /lib/systemd/system/hbmon.service <<- "EOF"
[Unit]
Description=HBMonitor
# To make the network-online.target available
# systemctl enable systemd-networkd-wait-online.service

After=network-online.target syslog.target
Wants=network-online.target

[Service]
User=root
StandardOutput=null
WorkingDirectory=/opt/HBmonitor
RestartSec=3
ExecStart=/usr/bin/python3 /opt/HBmonitor/monitor.py
Restart=on-abort

[Install]
WantedBy=multi-user.target





EOF

##################
##DMRI DVS service 
cat > /lib/systemd/system/dmrid-dvs.service <<- "EOF"
[Unit]
Description=DMRIDupdate DVS
Wants=network-online.target
After=syslog.target network-online.target

[Service]
User=root
#ExecStartPre=/bin/sleep 1800
ExecStart=/opt/MMDVM_Bridge/DMRIDUpdate.sh

[Install]
WantedBy=multi-user.target
EOF
##########
#web

groupadd www-data

usermod -G www-data -a pi

chown -R www-data:www-data /var/www/html

chmod -R 775 /var/www/html
#############################


mkdir /var/www/web-dvs
chmod +777 /var/www/web-dvs
chmod +777 /var/www/html/*
cp -r /var/www/html/* /var/www/web-dvs/
rm -r /var/www/html/*
##

cat > /opt/DMRIDUpdate.sh <<- "EOF"
#! /bin/bash
###############################################################################
#
#                              CONFIGURATION
#
# Full path to DMR ID file, without final slash
DMRIDPATH=/opt
DMRIDFILE=${DMRIDPATH}/DMRIds.dat
# DMR IDs now served by RadioID.net
#DATABASEURL='https://ham-digital.org/status/users.csv'
DATABASEURL='https://www.radioid.net/static/user.csv'
#
# How many DMR ID files do you want backed up (0 = do not keep backups)
DMRFILEBACKUP=1
#
# Command line to restart MMDVMHost
RESTARTCOMMAND="systemctl restart mmdvmhost.service"
# RESTARTCOMMAND="killall MMDVMHost ; /path/to/MMDVMHost/executable/MMDVMHost /path/to/MMDVM/ini/file/MMDVM.ini"
###############################################################################
#
# Do not edit below here
#
###############################################################################
# Check we are root
if [ "$(id -u)" != "0" ]
then
        echo "This script must be run as root" 1>&2
        exit 1
fi
# Create backup of old file
if [ ${DMRFILEBACKUP} -ne 0 ]
then
        cp ${DMRIDFILE} ${DMRIDFILE}.$(date +%d%m%y)
fi
# Prune backups
BACKUPCOUNT=$(ls ${DMRIDFILE}.* | wc -l)
BACKUPSTODELETE=$(expr ${BACKUPCOUNT} - ${DMRFILEBACKUP})
if [ ${BACKUPCOUNT} -gt ${DMRFILEBACKUP} ]
then
        for f in $(ls -tr ${DMRIDFILE}.* | head -${BACKUPSTODELETE})
        do
               rm $f
        done
fi
# Generate new file
curl ${DATABASEURL} 2>/dev/null | sed -e 's/\t//g' | awk -F"," '/,/{gsub(/ /, "", $2); printf "%s\t%s\t%s\n", $1, $2, $3}' | sed -e 's/\(.\) .*/\1/g' > ${DMRIDPATH}/DMRIds.tmp
NUMOFLINES=$(wc -l ${DMRIDPATH}/DMRIds.tmp | awk '{print $1}')
if [ $NUMOFLINES -gt 1 ]
then
   mv ${DMRIDPATH}/DMRIds.tmp ${DMRIDFILE}
else
   echo " ERROR during file update "
   rm ${DMRIDPATH}/DMRIds.tmp
fi
# Restart ysf2dmr
eval ${RESTARTCOMMAND}
EOF
#######

cp /opt/DMRIDUpdate.sh /opt/MMDVMHost/
cd /opt/MMDVMHost/
sed -i 's/\/opt/\/opt\/MMDVMHost/' DMRIDUpdate.sh
sed -i 's/systemctl restart mmdvmhost.service/systemctl restart mmdvmh.service/' DMRIDUpdate.sh


cp /opt/DMRIDUpdate.sh /opt/YSF2DMR/
cd /opt/YSF2DMR/
sed -i 's/\/opt/\/opt\/YSF2DMR/' DMRIDUpdate.sh
sed -i 's/systemctl restart mmdvmhost.service/systemctl restart ysf2dmr.service/' DMRIDUpdate.sh



cp /opt/DMRIDUpdate.sh /opt/MMDVM_Bridge/
cd /opt/MMDVM_Bridge/
sed -i 's/\/opt/\/opt\/MMDVM_Bridge/' DMRIDUpdate.sh
sed -i 's/systemctl restart mmdvmhost.service/systemctl restart mmdvm_bridge.service/' DMRIDUpdate.sh

rm /opt/DMRIDUpdate.sh

###########################
systemctl stop mmdvm_bridge.service 
systemctl stop dmrid-dvs.service 
systemctl stop analog_bridge.service 
systemctl disable analog_bridge.service 
systemctl disable mmdvm_bridge.service 
systemctl disable dmrid-dvs.service
systemctl disable lighttpd.service
systemctl stop lighttpd.service
rm -r  /var/www/html/* 
###########################
cat > /etc/modprobe.d/raspi-blacklist.conf <<- "EOF"
blacklist snd_bcm2835
# blacklist spi and i2c by default (many users don't need them)
#blacklist spi-bcm2708
#blacklist i2c-bcm2708
blacklist snd-soc-pcm512x
blacklist snd-soc-wm8804
# dont load default drivers for the RTL dongle
blacklist dvb_usb_rtl28xxu
blacklist rtl_2832
blacklist rtl_2830
EOF
################################
cd /usr/share/alsa/
sed -i 's/defaults.ctl.card 0/defaults.ctl.card 1/' alsa.conf
sed -i 's/defaults.pcm.card 0/defaults.pcm.card 1/' alsa.conf
###################################
cat > /var/spool/cron/crontabs/root <<- "EOF"
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command
* */1 * * * sync ; echo 3 > /proc/sys/vm/drop_caches >/dev/null 2>&1

EOF
##############
cd /opt
git clone https://github.com/hacknix/FreeDMR.git
cd FreeDMR
chmod 0755 install.sh
./install.sh
mkdir config
#cp FreeDMR-SAMPLE-commented.cfg config/FreeDMR.cfg
#cp rules_SAMPLE.py config/rules.py

chmod +x /opt/FreeDMR/bridge_master.py
chmod +x /opt/FreeDMR/playback.py
chmod +x /opt/FreeDMR/hotspot_proxy_v2.py

cat > /lib/systemd/system/proxy.service <<- "EOF"
[Unit]
Description= Proxy Service 

After=syslog.target network.target


[Service]
User=root
WorkingDirectory=/opt/FreeDMR
ExecStart=/usr/bin/python3 hotspot_proxy_v2.py

[Install]
WantedBy=multi-user.target

EOF
#########
cat > /lib/systemd/system/freedmr.service <<- "EOF"
[Unit]
Description=FreeDmr

After=multi-user.target

[Service]
User=root
ExecStartPre=/bin/sleep 30
#ExecStart=/usr/bin/python3 /opt/FreeDMR/bridge.py -c /opt/FreeDMR/config/FreeDMR.cfg -r /opt/FreeDMR/config/rules.py
ExecStart=/usr/bin/python3 /opt/FreeDMR/bridge_master.py -c /opt/FreeDMR/config/FreeDMR.cfg -r /opt/FreeDMR/config/rules.py
#ExecStart=/usr/bin/python3 /opt/FreeDMR/bridge_all_master.py -c /opt/FreeDMR/config/FreeDMR.cfg -r /opt/FreeDMR/config/rules.py

#bridge_all_master.py

[Install]
WantedBy=multi-user.target

EOF
###
cat > /lib/systemd/system/fdmrparrot.service <<- "EOF"
[Unit]

Description=Freedmr Parrot

After=network-online.target syslog.target

Wants=network-online.target

[Service]

StandardOutput=null

WorkingDirectory=/opt/FreeDMR

RestartSec=3

ExecStart=/usr/bin/python3 /opt/FreeDMR/playback.py -c /opt/FreeDMR/playback.cfg
#/usr/bin/python3 /opt/HBlink3/playback.py -c /opt/HBlink3/playback.cfg

Restart=on-abort

[Install]

WantedBy=multi-user.target

EOF
#######
cd /opt
git clone https://github.com/sp2ong/HBMonv2.git
cd HBMonv2
chmod +x install.sh
./install.sh
cp config_SAMPLE.py config.py
chmod +x /opt/HBMonv2/monitor.py

cat > /lib/systemd/system/hbmon2.service <<- "EOF"
[Unit]
Description=HBMonitor
# To make the network-online.target available
# systemctl enable systemd-networkd-wait-online.service

After=network-online.target syslog.target
Wants=network-online.target

[Service]
StandardOutput=null
WorkingDirectory=/opt/HBMonv2
RestartSec=3
ExecStart=/usr/bin/python3 /opt/HBMonv2/monitor.py
Restart=on-abort

[Install]
WantedBy=multi-user.target

EOF
###################
cat > /opt/FreeDMR/config/FreeDMR.cfg <<- "EOF"
# PROGRAM-WIDE PARAMETERS GO HERE
# PATH - working path for files, leave it alone unless you NEED to change it
# PING_TIME - the interval that peers will ping the master, and re-try registraion
#           - how often the Master maintenance loop runs
# MAX_MISSED - how many pings are missed before we give up and re-register
#           - number of times the master maintenance loop runs before de-registering a peer
#
# ACLs:
#
# Access Control Lists are a very powerful tool for administering your system.
# But they consume packet processing time. Disable them if you are not using them.
# But be aware that, as of now, the configuration stanzas still need the ACL
# sections configured even if you're not using them.
#
# REGISTRATION ACLS ARE ALWAYS USED, ONLY SUBSCRIBER AND TGID MAY BE DISABLED!!!
#
# The 'action' May be PERMIT|DENY
# Each entry may be a single radio id, or a hypenated range (e.g. 1-2999)
# Format:
# 	ACL = 'action:id|start-end|,id|start-end,....'
#		--for example--
#	SUB_ACL: DENY:1,1000-2000,4500-60000,17
#
# ACL Types:
# 	REG_ACL: peer radio IDs for registration (only used on HBP master systems)
# 	SUB_ACL: subscriber IDs for end-users
# 	TGID_TS1_ACL: destination talkgroup IDs on Timeslot 1
# 	TGID_TS2_ACL: destination talkgroup IDs on Timeslot 2
#
# ACLs may be repeated for individual systems if needed for granularity
# Global ACLs will be processed BEFORE the system level ACLs
# Packets will be matched against all ACLs, GLOBAL first. If a packet 'passes'
# All elements, processing continues. Packets are discarded at the first
# negative match, or 'reject' from an ACL element.
#
# If you do not wish to use ACLs, set them to 'PERMIT:ALL'
# TGID_TS1_ACL in the global stanza is used for OPENBRIDGE systems, since all
# traffic is passed as TS 1 between OpenBridges
[GLOBAL]
PATH: ./
PING_TIME: 10
MAX_MISSED: 3
USE_ACL: True
REG_ACL: PERMIT:ALL
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL
GEN_STAT_BRIDGES: False
ALLOW_NULL_PASSPHRASE: False
ANNOUNCEMENT_LANGUAGES: en_GB,en_GB_2,en_US,es_ES,es_ES_2,fr_FR,de_DE,dk_DK,it_IT,no_NO,pl_PL,se_SE,pt_PT,CW
SERVER_ID: 0


# NOT YET WORKING: NETWORK REPORTING CONFIGURATION
#   Enabling "REPORT" will configure a socket-based reporting
#   system that will send the configuration and other items
#   to a another process (local or remote) that may process
#   the information for some useful purpose, like a web dashboard.
#
#   REPORT - True to enable, False to disable
#   REPORT_INTERVAL - Seconds between reports
#   REPORT_PORT - TCP port to listen on if "REPORT_NETWORKS" = NETWORK
#   REPORT_CLIENTS - comma separated list of IPs you will allow clients
#       to connect on. Entering a * will allow all.
#
# ****FOR NOW MUST BE TRUE - USE THE LOOPBACK IF YOU DON'T USE THIS!!!****
[REPORTS]
REPORT: True
REPORT_INTERVAL: 60
REPORT_PORT: 4321
REPORT_CLIENTS: 127.0.0.1


# SYSTEM LOGGER CONFIGURAITON
#   This allows the logger to be configured without chaning the individual
#   python logger stuff. LOG_FILE should be a complete path/filename for *your*
#   system -- use /dev/null for non-file handlers.
#   LOG_HANDLERS may be any of the following, please, no spaces in the
#   list if you use several:
#       null
#       console
#       console-timed
#       file
#       file-timed
#       syslog
#   LOG_LEVEL may be any of the standard syslog logging levels, though
#   as of now, DEBUG, INFO, WARNING and CRITICAL are the only ones
#   used.
#
[LOGGER]
LOG_FILE: /tmp/hblink.log
LOG_HANDLERS: console-timed
LOG_LEVEL: DEBUG
LOG_NAME: HBlink

# DOWNLOAD AND IMPORT SUBSCRIBER, PEER and TGID ALIASES
# Ok, not the TGID, there's no master list I know of to download
# This is intended as a facility for other applcations built on top of
# HBlink to use, and will NOT be used in HBlink directly.
# STALE_DAYS is the number of days since the last download before we
# download again. Don't be an ass and change this to less than a few days.
[ALIASES]
TRY_DOWNLOAD: True
PATH: ./
PEER_FILE: peer_ids.json
SUBSCRIBER_FILE: subscriber_ids.json
TGID_FILE: talkgroup_ids.json
PEER_URL: https://www.radioid.net/static/rptrs.json
SUBSCRIBER_URL: https://www.radioid.net/static/users.json
TGID_URL: http://downloads.freedmr.uk/downloads/talkgroup_ids.json
STALE_DAYS: 7

#Read further repeater configs from MySQL
[MYSQL]
USE_MYSQL: False
USER: hblink
PASS: mypassword
DB: hblink
SERVER: 127.0.0.1
PORT: 3306
TABLE: repeaters

# OPENBRIDGE INSTANCES - DUPLICATE SECTION FOR MULTIPLE CONNECTIONS
# OpenBridge is a protocol originall created by DMR+ for connection between an
# IPSC2 server and Brandmeister. It has been implemented here at the suggestion
# of the Brandmeister team as a way to legitimately connect HBlink to the
# Brandemiester network.
# It is recommended to name the system the ID of the Brandmeister server that
# it connects to, but is not necessary. TARGET_IP and TARGET_PORT are of the
# Brandmeister or IPSC2 server you are connecting to. PASSPHRASE is the password
# that must be agreed upon between you and the operator of the server you are
# connecting to. NETWORK_ID is a number in the format of a DMR Radio ID that
# will be sent to the other server to identify this connection.
# other parameters follow the other system types.
#
# ACLs:
# OpenBridge does not 'register', so registration ACL is meaningless.
# OpenBridge passes all traffic on TS1, so there is only 1 TGID ACL.
# Otherwise ACLs work as described in the global stanza

[OBP-xx]
MODE: OPENBRIDGE
ENABLED: False
IP: 
PORT: 62081
NETWORK_ID: xxxx
PASSPHRASE: xxxxx
TARGET_IP: xxxxxxxxxxx
TARGET_PORT: 62081
USE_ACL: True
SUB_ACL: DENY:0-1000000
TGID_ACL: PERMIT:ALL
TGID_TS1_ACL: DENY :0-89
#DEFAULT_UA_TIMER: 15
RELAX_CHECKS: False
ENHANCED_OBP: True



# MASTER INSTANCES - DUPLICATE SECTION FOR MULTIPLE MASTERS
# HomeBrew Protocol Master instances go here.
# IP may be left blank if there's one interface on your system.
# Port should be the port you want this master to listen on. It must be unique
# and unused by anything else.
# Repeat - if True, the master repeats traffic to peers, False, it does nothing.
#
# MAX_PEERS -- maximun number of peers that may be connect to this master
# at any given time. This is very handy if you're allowing hotspots to
# connect, or using a limited computer like a Raspberry Pi.
#
# ACLs:
# See comments in the GLOBAL stanza
[MASTER-1]
MODE: MASTER
ENABLED: True
REPEAT: True
MAX_PEERS: 1
EXPORT_AMBE: False
IP: 127.0.0.1
PORT: 54000 
#54001
PASSPHRASE: passw0rd 
GROUP_HANGTIME: 3
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL
DEFAULT_UA_TIMER: 999
SINGLE_MODE: True
VOICE_IDENT: False
TS1_STATIC:
TS2_STATIC:
DEFAULT_REFLECTOR: 0
ANNOUNCEMENT_LANGUAGE: es_ES_2
#es_ES_2
#es_ES
GENERATOR: 100
#en_GB



[EchoTest]
MODE: PEER
ENABLED: False
LOOSE: True
EXPORT_AMBE: False
IP: 
#127.0.0.1
PORT: 49060
MASTER_IP: 127.0.0.1
MASTER_PORT: 49061
PASSPHRASE: passw0rd
CALLSIGN: ECHOTEST
RADIO_ID: 9990
RX_FREQ: 449000000
TX_FREQ: 444000000
TX_POWER: 25
COLORCODE: 1
SLOTS: 3
LATITUDE: 38.0000
LONGITUDE: -095.0000
HEIGHT: 75
LOCATION: Local Parrot
DESCRIPTION: This is a cool repeater
URL: www.w1abc.org
SOFTWARE_ID: 20170620
PACKAGE_ID: MMDVM_HBlink
GROUP_HANGTIME: 3
OPTIONS:
#TS2=9990;DIAL=0;VOICE=0;TIMER=0
USE_ACL: True
SUB_ACL: DENY:1
TGID_TS1_ACL: DENY:ALL
TGID_TS2_ACL: PERMIT:9990
TS1_STATIC:
TS2_STATIC:9990
DEFAULT_REFLECTOR: 0
ANNOUNCEMENT_LANGUAGE: en_GB
GENERATOR: 0
DEFAULT_UA_TIMER: 999
SINGLE_MODE: True
VOICE_IDENT: False

EOF
######
cat > /opt/FreeDMR/config/rules.py <<- "EOF"
'''
THIS EXAMPLE WILL NOT WORK AS IT IS - YOU MUST SPECIFY YOUR OWN VALUES!!!

In FreeDMR, the rules file should be *empty* unless you have static routing required. Please see the 
documentation for more details.

This file is organized around the "Conference Bridges" that you wish to use. If you're a c-Bridge
person, think of these as "bridge groups". You might also liken them to a "reflector". If a particular
system is "ACTIVE" on a particular conference bridge, any traffid from that system will be sent
to any other system that is active on the bridge as well. This is not an "end to end" method, because
each system must independently be activated on the bridge.

The first level (e.g. "WORLDWIDE" or "STATEWIDE" in the examples) is the name of the conference
bridge. This is any arbitrary ASCII text string you want to use. Under each conference bridge
definition are the following items -- one line for each HBSystem as defined in the main HBlink
configuration file.

    * SYSTEM - The name of the sytem as listed in the main hblink configuration file (e.g. hblink.cfg)
        This MUST be the exact same name as in the main config file!!!
    * TS - Timeslot used for matching traffic to this confernce bridge
        XLX connections should *ALWAYS* use TS 2 only.
    * TGID - Talkgroup ID used for matching traffic to this conference bridge
        XLX connections should *ALWAYS* use TG 9 only.
    * ON and OFF are LISTS of Talkgroup IDs used to trigger this system off and on. Even if you
        only want one (as shown in the ON example), it has to be in list format. None can be
        handled with an empty list, such as " 'ON': [] ".
    * TO_TYPE is timeout type. If you want to use timers, ON means when it's turned on, it will
        turn off afer the timout period and OFF means it will turn back on after the timout
        period. If you don't want to use timers, set it to anything else, but 'NONE' might be
        a good value for documentation!
    * TIMOUT is a value in minutes for the timout timer. No, I won't make it 'seconds', so don't
        ask. Timers are performance "expense".
    * RESET is a list of Talkgroup IDs that, in addition to the ON and OFF lists will cause a running
        timer to be reset. This is useful   if you are using different TGIDs for voice traffic than
        triggering. If you are not, there is NO NEED to use this feature.
'''

BRIDGES = {

# '9990': [ 
#	{'SYSTEM': 'EchoTest', 		'TS': 2, 'TGID': 9990, 'ACTIVE':True, 'TIMEOUT': 0, 'TO_TYPE': 'NONE', 'ON': [], 'OFF': [], 'RESET': []}, 

#	],


}
if __name__ == '__main__':
    from pprint import pprint
    pprint(BRIDGES)

EOF
########
cat > /opt/FreeDMR/playback.cfg <<- "EOF"
# PROGRAM-WIDE PARAMETERS GO HERE
# PATH - working path for files, leave it alone unless you NEED to change it
# PING_TIME - the interval that peers will ping the master, and re-try registraion
#           - how often the Master maintenance loop runs
# MAX_MISSED - how many pings are missed before we give up and re-register
#           - number of times the master maintenance loop runs before de-registering a peer
#
# ACLs:
#
# Access Control Lists are a very powerful tool for administering your system.
# But they consume packet processing time. Disable them if you are not using them.
# But be aware that, as of now, the configuration stanzas still need the ACL
# sections configured even if you're not using them.
#
# REGISTRATION ACLS ARE ALWAYS USED, ONLY SUBSCRIBER AND TGID MAY BE DISABLED!!!
#
# The 'action' May be PERMIT|DENY
# Each entry may be a single radio id, or a hypenated range (e.g. 1-2999)
# Format:
# 	ACL = 'action:id|start-end|,id|start-end,....'
#		--for example--
#	SUB_ACL: DENY:1,1000-2000,4500-60000,17
#
# ACL Types:
# 	REG_ACL: peer radio IDs for registration (only used on HBP master systems)
# 	SUB_ACL: subscriber IDs for end-users
# 	TGID_TS1_ACL: destination talkgroup IDs on Timeslot 1
# 	TGID_TS2_ACL: destination talkgroup IDs on Timeslot 2
#
# ACLs may be repeated for individual systems if needed for granularity
# Global ACLs will be processed BEFORE the system level ACLs
# Packets will be matched against all ACLs, GLOBAL first. If a packet 'passes'
# All elements, processing continues. Packets are discarded at the first
# negative match, or 'reject' from an ACL element.
#
# If you do not wish to use ACLs, set them to 'PERMIT:ALL'
# TGID_TS1_ACL in the global stanza is used for OPENBRIDGE systems, since all
# traffic is passed as TS 1 between OpenBridges
[GLOBAL]
PATH: ./
PING_TIME: 10
MAX_MISSED: 3
USE_ACL: True
REG_ACL: PERMIT:ALL
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL
GEN_STAT_BRIDGES: False
ALLOW_NULL_PASSPHRASE: False
ANNOUNCEMENT_LANGUAGES: es_ES
SERVER_ID: 9990



# NOT YET WORKING: NETWORK REPORTING CONFIGURATION
#   Enabling "REPORT" will configure a socket-based reporting
#   system that will send the configuration and other items
#   to a another process (local or remote) that may process
#   the information for some useful purpose, like a web dashboard.
#
#   REPORT - True to enable, False to disable
#   REPORT_INTERVAL - Seconds between reports
#   REPORT_PORT - TCP port to listen on if "REPORT_NETWORKS" = NETWORK
#   REPORT_CLIENTS - comma separated list of IPs you will allow clients
#       to connect on. Entering a * will allow all.
#
# ****FOR NOW MUST BE TRUE - USE THE LOOPBACK IF YOU DON'T USE THIS!!!****
[REPORTS]
REPORT: False
REPORT_INTERVAL: 60
REPORT_PORT: 4821
REPORT_CLIENTS: 127.0.0.1


# SYSTEM LOGGER CONFIGURAITON
#   This allows the logger to be configured without chaning the individual
#   python logger stuff. LOG_FILE should be a complete path/filename for *your*
#   system -- use /dev/null for non-file handlers.
#   LOG_HANDLERS may be any of the following, please, no spaces in the
#   list if you use several:
#       null
#       console
#       console-timed
#       file
#       file-timed
#       syslog
#   LOG_LEVEL may be any of the standard syslog logging levels, though
#   as of now, DEBUG, INFO, WARNING and CRITICAL are the only ones
#   used.
#
[LOGGER]
LOG_FILE: /dev/null
LOG_HANDLERS: null
LOG_LEVEL: DEBUG
LOG_NAME: HBlink

# DOWNLOAD AND IMPORT SUBSCRIBER, PEER and TGID ALIASES
# Ok, not the TGID, there's no master list I know of to download
# This is intended as a facility for other applcations built on top of
# HBlink to use, and will NOT be used in HBlink directly.
# STALE_DAYS is the number of days since the last download before we
# download again. Don't be an ass and change this to less than a few days.
[ALIASES]
TRY_DOWNLOAD: False
PATH: ./
PEER_FILE: peer_ids.json
SUBSCRIBER_FILE: subscriber_ids.json
TGID_FILE: talkgroup_ids.json
PEER_URL: https://www.radioid.net/static/rptrs.json
SUBSCRIBER_URL: https://www.radioid.net/static/users.json
TGID_URL: http://downloads.freedmr.uk/downloads/talkgroup_ids.json
STALE_DAYS: 7

#Read further repeater configs from MySQL
[MYSQL]
USE_MYSQL: False
USER: hblink
PASS: mypassword
DB: hblink
SERVER: 127.0.0.1
PORT: 3306
TABLE: repeaters

# OPENBRIDGE INSTANCES - DUPLICATE SECTION FOR MULTIPLE CONNECTIONS
# OpenBridge is a protocol originall created by DMR+ for connection between an
# IPSC2 server and Brandmeister. It has been implemented here at the suggestion
# of the Brandmeister team as a way to legitimately connect HBlink to the
# Brandemiester network.
# It is recommended to name the system the ID of the Brandmeister server that
# it connects to, but is not necessary. TARGET_IP and TARGET_PORT are of the
# Brandmeister or IPSC2 server you are connecting to. PASSPHRASE is the password
# that must be agreed upon between you and the operator of the server you are
# connecting to. NETWORK_ID is a number in the format of a DMR Radio ID that
# will be sent to the other server to identify this connection.
# other parameters follow the other system types.
#
# ACLs:
# OpenBridge does not 'register', so registration ACL is meaningless.
# OpenBridge passes all traffic on TS1, so there is only 1 TGID ACL.
# Otherwise ACLs work as described in the global stanza
[OBP-TEST]
MODE: OPENBRIDGE
ENABLED: False
IP:
PORT: 62044
NETWORK_ID: 1
PASSPHRASE: mypass
TARGET_IP: 
TARGET_PORT: 62044
USE_ACL: True
SUB_ACL: DENY:1
TGID_ACL: PERMIT:9990
RELAX_CHECKS: False

# MASTER INSTANCES - DUPLICATE SECTION FOR MULTIPLE MASTERS
# HomeBrew Protocol Master instances go here.
# IP may be left blank if there's one interface on your system.
# Port should be the port you want this master to listen on. It must be unique
# and unused by anything else.
# Repeat - if True, the master repeats traffic to peers, False, it does nothing.
#
# MAX_PEERS -- maximun number of peers that may be connect to this master
# at any given time. This is very handy if you're allowing hotspots to
# connect, or using a limited computer like a Raspberry Pi.
#
# ACLs:
# See comments in the GLOBAL stanza
[PARROT]
MODE: MASTER
ENABLED: True
REPEAT: True
MAX_PEERS: 1
EXPORT_AMBE: False
IP: 127.0.0.1
PORT: 49061
#54915
PASSPHRASE: passw0rd
#passw0rd
GROUP_HANGTIME: 30
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:9990
DEFAULT_UA_TIMER: 9999
SINGLE_MODE: True
VOICE_IDENT: False
TS1_STATIC:
TS2_STATIC:9990 
DEFAULT_REFLECTOR: 0
GENERATOR: 1
ANNOUNCEMENT_LANGUAGE:es_ES

EOF
###########
cp /bin/menu /bin/MENU
chmod +x /bin/MENU
chmod +x /bin/menu*

##########################

timedatectl set-timezone America/Panama

#####
cat > /boot/wpa_supplicant.conf <<- "EOF"
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=PA
##################################################################
# 							         #
#  Favor tomar como referencia, las dos redes wifi  que aparecen #
#  abajo, puede editar con los datos de su red wifi o agregar un #
#  network nuevo, por cada red wifi nueva que quiera almacenar.  #
#  							         #
#  Raspbian proyect by HP3ICC, 73.			         #
#							         #
##################################################################
network={
        ssid="Coloque_aqui_nombre_de_red_wifi"
        psk="Coloque_aqui_la_clave_wifi"
}
network={
        ssid="WiFi-Net"
        psk="Panama310"
}
EOF
#######
################################################
#Direwolf
apt-get remove --purge pulseaudio -y
apt-get autoremove -y
rm -rf /home/pi/.pulse
cd /opt
	
git clone https://www.github.com/wb2osz/direwolf
cd direwolf
git checkout dev
mkdir build
cd build
cmake ..
make -j4
make install
make install-conf

rm /usr/local/bin/direwolf
cd /tmp/
wget https://github.com/hp3icc/emq-TE1ws/raw/main/direwolf
mv /tmp/direwolf /usr/local/bin/
chmod +x /usr/local/bin/direwolf
##########
cat > /opt/direwolf/sdr.conf <<- "EOF"
#############################################################
#                                                           #
#       Configuration file for Dire Wolf 1.7a               #
#                                                           #
#         Linux version setting by hp3icc        	    #
#                                                           #
#                emq-TE1ws-rev9   		     	    #
#                                                           #
#        configuration for SDR read-only IGate. 	    #
#############################################################
ADEVICE null null
CHANNEL 0
MYCALL HP3ICC-10
PBEACON sendto=IG delay=0:40 every=30 symbol="/r" lat=08^31.27N long=080^21.59W comment="APRS RX-IGATE / Raspbian Proyect by hp3icc"
# First you need to specify the name of a Tier 2 server.
# The current preferred way is to use one of these regional rotate addresses:
#       noam.aprs2.net          - for North America
#       soam.aprs2.net          - for South America
#       euro.aprs2.net          - for Europe and Africa
#       asia.aprs2.net          - for Asia
#       aunz.aprs2.net          - for Oceania
IGSERVER  igates.aprs.fi:14580
#noam.aprs2.net
# You also need to specify your login name and passcode.
# Contact the author if you can't figure out how to generate the passcode.
IGLOGIN HP3ICC-10 12345
# That's all you need for a receive only IGate which relays
# messages from the local radio channel to the global servers.
#
#AGWPORT 9000
#KISSPORT 9001
EOF
###
cat > /opt/direwolf/dw.conf <<- "EOF"
#############################################################
#                                                           #
#       Configuration file for Dire Wolf 1.7a               #
#                                                           #
#         Linux version setting by hp3icc        	    #
#                                                           #
#                emq-TE1ws-rev9   		     	    #
#                                                           #
#############################################################
#############################################################
#                                                           #
#               FIRST AUDIO DEVICE PROPERTIES               #
#               (Channel 0 + 1 if in stereo)                #
#                                                           #
#############################################################
ADEVICE plughw:1,0
#ADEVICE null null
# ADEVICE - plughw:1,0
# ADEVICE UDP:7355 default
# Number of audio channels for this souncard:  1 or 2.
#
ACHANNELS 1
#############################################################
#                                                           #
#               CHANNEL 0 PROPERTIES                        #
#                                                           #
#############################################################
CHANNEL 0
MYCALL HP3ICC-10
MODEM 1200
#MODEM 1200 1200:2200
#MODEM 300  1600:1800
#MODEM 9600 0:0
#
#MODEM 1200 E+ /3
#
#
# If not using a VOX circuit, the transmitter Push to Talk (PTT)
# DON'T connect it directly!
#
# For the PTT command, specify the device and either RTS or DTR.
# RTS or DTR may be preceded by "-" to invert the signal.
# Both can be used for interfaces that want them driven with opposite polarity.
#
# COM1 can be used instead of /dev/ttyS0, COM2 for /dev/ttyS1, and so on.
#
#PTT CM108
#PTT COM1 RTS
#PTT COM1 RTS -DTR
#PTT /dev/ttyUSB0 RTS
#PTT /dev/ttyUSB0 DTR
#PTT GPIO 25
#PTT GPIO 26
# The Data Carrier Detect (DCD) signal can be sent to the same places
# as the PTT signal.  This could be used to light up an LED like a normal TNC.
#DCD COM1 -DTR
#DCD GPIO 24
#pin18 (GPIO 24) - (cathode) LED (anode) - 270ohm resistor - 3.3v
#DCD GPIO 13
#############################################################
#                                                           #
#               VIRTUAL TNC SERVER PROPERTIES               #
#                                                           #
#############################################################
#
# Dire Wolf acts as a virtual TNC and can communicate with
# client applications by different protocols:
#
#       - the "AGW TCPIP Socket Interface" - default port 8000
#       - KISS protocol over TCP socket - default port 8001
#       - KISS TNC via pseudo terminal   (-p command line option)
#
#Setting to 0 disables UI-proto only AGW and TCP-KISS ports
AGWPORT 8000
KISSPORT 8001
#KISSPORT 0
#
# It is sometimes possible to recover frames with a bad FCS.
# This applies to all channels.
#       0  [NONE] - Don't try to repair.
#       1  [SINGLE] - Attempt to fix single bit error.  (default)
#       2  [DOUBLE] - Also attempt to fix two adjacent bits.
#       ... see User Guide for more values and in-depth discussion.
#
#FIX_BITS 0
#Enable fixing of 1 bits and use generic AX25 heuristics data (not APRS heuristi$
#FIX_BITS 1 AX25
#
#############################################################
#                                                           #
#               BEACONING PROPERTIES                        #
#                                                           #
#############################################################
#GPSD
#TBEACON every=0:30 symbol="/v" comment="APRS TRACKER / Raspbian Proyect by hp3icc" via=WIDE1-1,WIDE2-1
#PBEACON delay=0:05 every=30 symbol="/r" lat=08^31.27N long=080^21.59W comment="APRS DIGI-IGATE / Raspbian Proyect by hp3icc" via=WIDE2-2
#PBEACON sendto=IG delay=0:40 every=30 symbol="/r" lat=08^31.27N long=080^21.59W comment="APRS DIGI-IGATE / Raspbian Proyect by hp3icc"
#############################################################
#                                                           #
#               DIGIPEATER PROPERTIES                       #
#                                                           #
#############################################################
DIGIPEAT 0 0 ^WIDE[3-7]-[1-7]$|^TEST$ ^WIDE[12]-[12]$ TRACE
FILTER 0 0 t/poimqstunw
#############################################################
#                                                           #
#               INTERNET GATEWAY                            #
#                                                           #
#############################################################
# First you need to specify the name of a Tier 2 server.
# The current preferred way is to use one of these regional rotate addresses:
#       noam.aprs2.net          - for North America
#       soam.aprs2.net          - for South America
#       euro.aprs2.net          - for Europe and Africa
#       brazil.d2g.com
#
#IGSERVER igates.aprs.fi:14580
#IGSERVER noam.aprs2.net:14580
#IGSERVER cx2sa.net:14580

#IGLOGIN HP3ICC-10  12345
IGTXVIA 0 WIDE1-1,WIDE2-1
#WIDE2-2
#
#
#IGFILTER f/HP3ICC-5/600
#IGFILTER p/HP
#m/600
#
FILTER IG 0 t/p
#poimqstunw
IGTXLIMIT 6 10
#
EOF
########################
echo finalizando instalacion
chown -R mmdvm:mmdvm /opt/MMDVMHost/MMDVMHost
chmod +777 /opt/*
chmod +777 /opt/MMDVMHost-Websocketboard/*
chmod +777 /opt/WSYSFDash/*
chmod +777 /opt/direwolf/*
chmod +777 /opt/direwolf/dw.conf
chmod +777 /opt/direwolf/sdr.conf
chmod +777 /opt/direwolf/src/*
chmod +777 /opt/MMDVMHost/*
chmod +777 /opt/MMDVMHost/MMDVM.ini
chmod +777 /opt/YSF2DMR/*
chmod +777 /opt/YSF2DMR/YSF2DMR.ini
chmod +777 /opt/ionsphere/*
chmod +777 /opt/ionsphere/ionosphere-raspberry-pi/config/config.yml
chmod +777 /opt/pymultimonaprs/* 
chmod +777 /opt/multimon-ng/*
chmod +777 /opt/kalibrate-rtl/*
chmod +777 /opt/YSFClients/*
chmod +777 /opt/MMDVM_CM/*
chmod +777 /opt/MMDVM_Bridge/*
chmod +777 /opt/MMDVM_Bridge/MMDVM_Bridge.ini
chmod +777 /etc/pymultimonaprs.json

chmod +x /usr/bin/python3
chmod +x /opt/HBmonitor/monitor.py
chmod +x /opt/HBlink3/playback.py
chmod +x /opt/HBlink3/bridge.py
chmod +x /opt/MMDVM_Bridge/DMRIDUpdate.sh
chmod +x /opt/YSF2DMR/DMRIDUpdate.sh
chmod +x /opt/MMDVMHost/DMRIDUpdate.sh

chmod 755 /lib/systemd/system/freedmr.service
chmod 755 /lib/systemd/system/proxy.service
chmod 755 /lib/systemd/system/hbmon2.service
chmod 755 /lib/systemd/system/hblink.service
chmod 755 /lib/systemd/system/hbmon.service
chmod 755 /lib/systemd/system/hbparrot.service
chmod 755 /lib/systemd/system/YSFReflector.service
chmod 755 /lib/systemd/system/monp.service
chmod 755 /lib/systemd/system/dmrid-ysf2dmr.service
chmod 755 /lib/systemd/system/dmrid-dvs.service
chmod 755 /lib/systemd/system/dmrid-mmdvm.service
chmod 755 /lib/systemd/system/mmdvmh.service
chmod 755 /lib/systemd/system/direwolf.service
chmod 755 /lib/systemd/system/direwolf-rtl.service
chmod 755 /lib/systemd/system/multimon-rtl.service
chmod 755 /lib/systemd/system/ionos.service
chmod 755 /lib/systemd/system/ysf2dmr.service
chmod 755 /lib/systemd/system/http.server-mmdvmh.service
chmod 755 /lib/systemd/system/logtailer-mmdvmh.service
chmod 755 /lib/systemd/system/http.server-ysf.service
chmod 755 /lib/systemd/system/logtailer-ysf.service
systemctl daemon-reload

systemctl enable monp.service

#####
cat > /tmp/completado.sh <<- "EOF"
#!/bin/bash
while : ; do
choix=$(whiptail --title "Raspbian Proyect HP3ICC Esteban Mackay 73." --menu " Precione enter (return o intro) para finalizar la instalacion y reiniciar su equipo " 11 85 3 \
1 " Iniciar Reinicio de Raspberry " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
sudo reboot
;;
esac
done
exit 0
EOF
chmod +x /tmp/completado.sh
history -c && history -w
sh /tmp/completado.sh
