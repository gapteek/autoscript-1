#!/bin/bash

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
wget -O /etc/apt/sources.list "https://raw.github.com/gapteek/autoscript-1/master/conf/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;

# update
apt-get update; apt-get -y upgrade;



# install essential package
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois sslh ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

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



# install fail2ban
apt-get -y install fail2ban;service fail2ban restart


# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.660_all.deb"
dpkg --install webmin_1.660_all.deb;
apt-get -y -f install;
rm /root/webmin_1.660_all.deb
service webmin restart
service vnstat restart

# downlaod script
cd
wget -O speedtest_cli.py "https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py"
wget -O bench-network.sh "https://raw.github.com/gapteek/autoscript-1/master/conf/bench-network.sh"
wget -O ps_mem.py "https://raw.github.com/pixelb/ps_mem/master/ps_mem.py"
wget -O limit.sh "https://raw.github.com/gapteek/autoscript-1/master/conf/limit.sh"
curl http://script.jualssh.com/user-login.sh > user-login.sh
curl http://script.jualssh.com/user-expire.sh > user-expire.sh
curl http://script.jualssh.com/user-limit.sh > user-limit.sh
echo "0 0 * * * root /root/user-expire.sh" > /etc/cron.d/user-expire
sed -i '$ i\screen -AmdS limit /root/limit.sh' /etc/rc.local
chmod +x bench-network.sh
chmod +x speedtest_cli.py
chmod +x ps_mem.py
chmod +x user-login.sh
chmod +x user-expire.sh
chmod +x user-limit.sh
chmod +x limit.sh

# finalisasi

service ssh restart
service dropbear restart
service fail2ban restart
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
