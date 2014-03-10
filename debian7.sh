#!/bin/bash

# go to root
cd



# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart



# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;

# update
apt-get update; apt-get -y upgrade;






# update apt-file
apt-file update









# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/Port 22/Port  22/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service ssh restart
service dropbear restart



# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.660_all.deb"
dpkg --install webmin_1.660_all.deb;
apt-get -y -f install;
rm /root/webmin_1.660_all.deb
service webmin restart
service vnstat restart



# finalisasi

service ssh restart
service dropbear restart

service webmin restart

# info
clear
echo "computika.org | arun | ganteng | :p"
echo "==============================================="
echo ""
echo "Service"
echo "-------"
echo "OpenSSH  : 22, 143"
echo "Dropbear : 109, 110, 443"
echo "Squid    : 8080 (limit to IP SSH)"
echo "badvpn   : badvpn-udpgw port 7300"
echo ""
echo "Script"
echo "------"
echo "./ps_mem.py"
echo "./speedtest_cli.py --share"
echo "./bench-network.sh"
echo "./user-login.sh"
echo "./user-expire.sh"
echo "./user-limit.sh 2"
echo ""
echo "Account Default (utk SSH dan VPN)"
echo "---------------"
echo "User     : gapteek"
echo "Password : $PASS"
echo ""
echo "Fitur lain"
echo "----------"
echo "Webmin   : https://$MYIP:10000/"
echo "vnstat   : http://$MYIP/vnstat/"
echo "MRTG     : http://$MYIP/mrtg/"
echo "Timezone : Asia/Jakarta"
echo "Fail2Ban : [on]"
echo "IPv6     : [off]"
echo ""
echo "SILAHKAN REBOOT VPS ANDA !"
echo ""
echo "==============================================="
