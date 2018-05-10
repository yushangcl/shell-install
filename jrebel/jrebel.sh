#!/usr/bin/env bash
#URL: https://github.com/yushangcl/JRebelServer
#E-mail: gayhub@live.cn
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #             Build Jrebel Server              #"
echo "    #            https://blog.itbat.cn             #"
echo "    #                Version 0.4.1                 #"
echo "    ################################################"
#Prepare the installation environment
echo -e ""
echo -e "Prepare the installation environment."
if cat /etc/*-release | grep -Eqi "centos|red hat|redhat"; then
  echo "RPM-based"
  yum -y install git
elif cat /etc/*-release | grep -Eqi "debian|ubuntu|deepin"; then
  echo "Debian-based"
  apt-get -y install git
else
  echo "This release is not supported."
  exit
fi
#Check instruction
if getconf LONG_BIT | grep -Eqi "64"; then
  arch=64
else
  arch=32
fi
#Build KMS Server
git clone https://github.com/yushangcl/JRebelServer
if cat /etc/*-release | grep -Eqi "raspbian"; then
  mv JRebelServer/binaries/ReverseProxy_linux_arm jrebel
else
  if [ "$arch" -eq 32 ]; then
    mv JRebelServer/binaries/ReverseProxy_linux_386 jrebel
  else
    mv JRebelServer/binaries/ReverseProxy_linux_amd64 jrebel
  fi
fi
mv jrebel /usr/bin/
chmod +x /usr/bin/jrebel
nohup jrebel -l '0.0.0.0:1018' -r 'http://idea.lanyus.com:80' > /home/jrebel.log 2>&1 &
echo -ne '\n@reboot root nohup jrebel > /home/jrebel.log 2>&1 &\n\n' >>/etc/crontab
#Cleaning Work
rm -rf JRebelServer
#Check jrebel server status
sleep 1
echo "Check jrebel Server status..."
sleep 1
PIDS=`ps -ef |grep jrebel |grep -v grep | awk '{print $2}'`
if [ "$PIDS" != "" ]; then
  echo "jrebel server is runing!"
else
  echo "jrebel server is NOT running!"
fi