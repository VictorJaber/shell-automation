#!/bin/bash

echo Instalando e configurando os temas.

Text='\033[1;32m'
NC='\033[0m'

if ((${EUID:-0} || "$(id -u)")); then
  clear
  sleep 1.5
  	echo -e "${NC}Sorry, You are not root"
  sleep 1.0
  	echo "Please run using sudo command"
  sleep 1.0
  	echo -e "${Text}Cancelling Installation Command"
  sleep 1.5
  exit 1
else
  clear
  sleep 1.5
  	echo -e "${Text}Please Wait Until Installing Complete"
  sleep 1.5
  	echo -e "${NC}Copying All MacBuntu Plymouth file"
  	cp -iRv macbuntu /usr/share/plymouth/themes/
  sleep 1.5
  clear
  	echo -e "${Text}Please Wait Until Installing Complete"
  	echo -e "${NC}Configuring All MacBuntu Plymouth"
  sleep 1.5
  	update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/macbuntu/macbuntu.plymouth 100
  	echo -e "${Text}All MacBuntu Plymouth Theme Configured"
  sleep 1.5
  clear
  	echo "Select Number of Plymouth Theme"
  sleep 1.0
    echo -e "${NC} "
  	echo "1" | update-alternatives --config default.plymouth
  	update-initramfs -u
  sleep 0.5
  	echo "Finish"
  sleep 1.5
  clear
fi
