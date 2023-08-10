#!/bin/bash

: '
Esse script serve para remover o software USBguard e seus serviços.
'
if [[ $EUID -ne 0 ]]; then
    echo "Este script precisa ser executado como root"
    exit 1
fi

echo "Removendo o USBguard do sistema"
# Parando e desabilitando os serviços do usbguard
systemctl stop usbguard.service

systemctl disable usbguard.service

systemctl stop usbguard-dbus.service

systemctl disable usbguard-dbus.service
# Removendo o usbguard
apt remove usbguard -y

apt purge usbguard -y

rm -rf /etc/usbguard/

read -p "Atenção, o sistema deve ser reiniciado para que as alterações possam fazer efeito, deseja fazer isso agora? [Y/N] " qa

if [ ! -d "/opt/reg" ]; then
    sudo mkdir -p "/opt/reg"
fi

if [ ! -d "/opt/reg_old" ]; then
    sudo mkdir -p "/opt/reg_old"
fi

usb_remove_ver="1"

data_atual=$(date +%d-%m-%Y)

dir_ver=/opt/reg/usb_remove_ver

reg_ver="O script de remoção do bloqueio de dispositivos usb foi executado na versão $usb_remove_ver na data $data_atual pelo técnico $domain_usr."

if [ -e $dir_ver ]; then
    if cmp -s "$dir_ver" <(echo "$reg_ver"); then
        echo "O conteúdo do registro da versão do sistema é o mesmo que está tentando registrar"
    else
        echo "Já há um registro de versão do sistema, segue a versão atual: $(cat $dir_ver)"
        echo $(cat "$dir_ver") | sudo tee -a /opt/reg_old/usb_remove_ver_old >/dev/null
        echo $reg_ver | sudo tee "$dir_ver" >/dev/null
    fi
else
    echo $reg_ver | sudo tee "$dir_ver" >/dev/null
fi

if [[ "$qa" == [Yy] ]]; then
    echo "Reiniciando o sistema operacional em 5..."
    sleep 5
    reboot
else
    echo "O sistema não será reiniciado agora."
fi