#!/bin/bash

# O objetivo do script é configurar as imagens que aparecem durante a inicialização do sistema operacional, trocando o logo do Linux Mint pelo logo da Jatinox.

echo Instalando e configurando os temas.

sudo apt update -y --fix-missing && sudo apt upgrade -y --fix-missing

Text='\033[1;32m'
NC='\033[0m'

if ((${EUID:-0} || "$(id -u)")); then
  clear
  sleep 1.5
  	echo -e "${NC}Desculpe, você não é root"
  sleep 1.0
  	echo "Por favor, execute como root do sistema"
  sleep 1.0
  	echo -e "${Text}Cancelando comando de instalação"
  sleep 1.5
  exit 1
else
  clear
  sleep 1.5
  	echo -e "${Text}Por favor, aguarde a instalação dos temas da Jatinox"
  sleep 1.5
  	echo -e "${NC}Copiando os arquivos necessários para a customização da Jatinox"
  	cp -iRv macbuntu /usr/share/plymouth/themes/
  sleep 1.5
  clear
  	echo -e "${Text}Por favor, aguarde a instalação dos temas da Jatinox"
  	echo -e "${NC}Configuring All MacBuntu Plymouth"
  sleep 1.5
  	update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/macbuntu/macbuntu.plymouth 100
  	echo -e "${Text}Tema da Jatinox configurado com sucesso. rs"
  sleep 3
  clear
  	echo "Select Number of Plymouth Theme"
  sleep 3
    echo -e "${NC} "
  	echo "1" | update-alternatives --config default.plymouth
  	update-initramfs -u
  sleep 2
  	echo "Finalizado"
  sleep 5
  clear
fi
