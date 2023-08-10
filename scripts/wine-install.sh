#!/bin/bash

echo Instalando e configurando o Wine.

sudo apt update -y --fix-missing && sudo apt upgrade -y --fix-missing

sudo apt install

sudo apt --fix-broken install -y

sudo add-apt-repository ppa:cybermax-dexter/sdl2-backport -y

sudo mkdir -pm755 /etc/apt/keyrings

sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key --no-check-certificate

sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources --no-check-certificate

sudo apt update -y

sudo apt install --install-recommends winehq-stable -y --fix-missing

if [ $? -ne 0 ]; then
    sudo apt --fix-broken install -y

    sudo apt install --install-recommends winehq-stable -y --fix-missing
fi

sudo apt install

sudo apt update -y

if [ ! -d "/opt/reg" ]; then
    sudo mkdir -p "/opt/reg"
fi

if [ ! -d "/opt/reg_old" ]; then
    sudo mkdir -p "/opt/reg_old"
fi

data_atual=$(date +%d-%m-%Y)

dir_ver=/opt/reg/wine_ver

reg_ver="O script de configuração do Wine foi rodado na data $data_atual pelo técnico $domain_usr."

if [ -e $dir_ver ]; then
    if cmp -s "$dir_ver" <(echo "$reg_ver"); then
        echo "O conteúdo do registro da versão do sistema é o mesmo que está tentando registrar"
    else
        echo $(cat "$dir_ver") | sudo tee -a /opt/reg_old/wine_ver_old >/dev/null
        echo $reg_ver | sudo tee "$dir_ver" >/dev/null
    fi
else
    echo $reg_ver | sudo tee "$dir_ver" >/dev/null
fi

echo Processo de instalação e configuração do Wine finalizado

# Configuração para iniciar o Wine automaticamente no login do usuário
echo "wine &" >> ~/.bashrc
