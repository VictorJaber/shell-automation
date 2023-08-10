#!/bin/bash

# Script de instalação de configuração do OCS, conectando a máquina com nosso servidor para termos um controle da mesma.

echo Instalando e configurando o OCS.

sudo apt update -y --fix-missing && sudo apt upgrade -y --fix-missing

sudo apt --fix-broken install

sudo apt-get install libxml-simple-perl -y

cd ..

cd Ocsinventory-Unix-Agent-2.10.0

sudo apt install libmodule-install-perl dmidecode libxml-simple-perl libcompress-zlib-perl libnet-ip-perl libwww-perl libdigest-md5-perl libdata-uuid-perl -y

sudo apt install libcrypt-ssleay-perl libnet-snmp-perl libproc-pid-file-perl libproc-daemon-perl net-tools libsys-syslog-perl pciutils smartmontools read-edid nmap libnet-netmask-perl -y

sudo perl Makefile.PL

sudo make

sudo make install

cd ..

if [ ! -d "/opt/reg" ]; then
    sudo mkdir -p "/opt/reg"
fi

if [ ! -d "/opt/reg_old" ]; then
    sudo mkdir -p "/opt/reg_old"
fi

data_atual=$(date +%d-%m-%Y)

dir_ver=/opt/reg/ocs_ver

reg_ver="O script de configuração do OCS foi rodado na data $data_atual pelo técnico $domain_usr."

if [ -e "$dir_ver" ]; then
    if cmp -s "$dir_ver" <(echo "$reg_ver"); then
        echo "O conteúdo do registro da versão do sistema é o mesmo que está tentando registrar"
    else
        echo $(cat "$dir_ver") | sudo tee -a /opt/reg_old/ocs_ver_old >/dev/null
        echo $reg_ver | sudo tee "$dir_ver" >/dev/null
    fi
else
    echo $reg_ver | sudo tee "$dir_ver" >/dev/null
fi

echo Ocs finalizado