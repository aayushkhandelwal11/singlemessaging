#!/bin/sh

# 
# Use this script to install Phusion Passenger on a RailsMachine CentOS 4/5 image. 
# Please see the wiki for additional instructions.
# http://wiki.railsmachine.com/PhusionPassenger
#

set -e

REEVERSION="ruby-enterprise-1.8.6-20090610"

if [ -n "`gem list | grep passenger`" ]; then
	while [ "$choice" != 'y' ]; do
	  echo -e "Passenger is already installed on your system. \n\nAre you sure you want to continue? (y/n) "; read choice;
	  case $choice in
	      'y') echo "Ok, Installing Phusion Passenger and Ruby Enterprise Edition"
	          ;;
	      'n') echo "Bye!"
	            exit 0;;
	     *) echo "Invalid option -- please enter (y/n)"
	  esac
	done
fi

# resolve any dependencies
echo "Installing dependencies"
sudo yum install gcc-c++ httpd-devel readline-devel ncurses ncurses-devel -y

# download and install REE /opt/ree
wget http://assets.railsmachine.com/other/$REEVERSION.tar.gz
tar xzvf $REEVERSION.tar.gz
yes | sudo ./$REEVERSION/installer -a /opt/$REEVERSION
sudo ln -nfs /opt/$REEVERSION /opt/ree

# install passenger on system ruby
sudo gem install passenger
yes | sudo passenger-install-apache2-module

# install passenger module in REE
yes | sudo /opt/ree/bin/passenger-install-apache2-module

# get the passenger configuration file
wget http://assets.railsmachine.com/wiki/passenger.conf

# check that the install went well
/opt/ree/bin/passenger-config --version || { echo "Installation of Passenger failed."; exit 1; }

VERSION=`/opt/ree/bin/passenger-config --version`
ARCH=""

if [ `uname -i` == 'x86_64' ]; then
 ARCH="64"
fi

# make sure we have the correct libs
sed -i "s/ARCH/$ARCH/" passenger.conf
echo -e "Updated passenger.conf for proper architecture.\n"

# use the lastest version of passenger
sed -i "s/VERSION/$VERSION/" passenger.conf
echo -e "Updated passenger.conf to use $VERSION of Passenger.\n"

# make sure conf.d exists
sudo mkdir -p /etc/httpd/conf.d

# move the conf to httpd/conf dir
sudo mv -v passenger.conf /etc/httpd/conf.d/passenger.conf

# make sure httpd.conf is writeable
sudo chmod 666 /etc/httpd/conf/httpd.conf 
    
# include passenger.conf 
sudo [  -z "`/usr/sbin/apachectl -t -D DUMP_MODULES 2>&1 | grep passenger`" ] && echo 'Include conf.d/*.conf' >> /etc/httpd/conf/httpd.conf || echo 'Passenger module already included.'
 
# reset httpd.conf permissions   
sudo chmod 644 /etc/httpd/conf/httpd.conf

# reload Apache
sudo service httpd reload

# all done
echo -e "\n\n------------------\nInstallation is complete!\n\nRuby Enterprise is installed at /opt/ree.\nImportant: Use /opt/ree/bin/gem to install gems for use under Passenger."



