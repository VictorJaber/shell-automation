#!/bin/bash

: ' Esse script serve para padronizar máquinas com o sistema Linux Mint 20.3 que já estavam em ambiente de produção.
Esse script garante a remoção de softwares que não usamos mais além de atualizar os recursos da máquina.
'

# Remoção de softwares obsoletos

export domain_usr

usr=$(echo $(who | awk '$1 != "administrador" {print $1}'))

zoiper_dir=/usr/bin/zoiper5

webmin_setup_dir=/webmin-setup.out

net2phone_dir=/home/$usr/.wine/drive_c/users/$usr/AppData/Local/com.net2phone.office.winx

microsip_dir=/home/$usr/.wine/drive_c/users/$usr/AppData/Roaming/MicroSIP

# Chave de verificação para remover o Zoiper
if [ -e $zoiper_dir ]; then
    sudo apt remove zoiper5
fi

# Chave de verificação para remover o instalador do Webmin
if [ -e $webmin_setup_dir ]; then
    sudo rm -r $webmin_setup_dir
fi

# Chave de verificação para remover o Net2phone
if [ -e $net2phone_dir ]; then
    sudo rm -r $net2phone_dir
    sudo rm -r "/home/$usr/.wine/drive_c/users/$usr/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/net2phone.lnk"
    sudo rm -r "/home/$usr/Área de Trabalho/net2phone.desktop"
fi

# Chave de verificação para remover o Microsip
if [ -e $microsip_dir ]; then
    sudo rm -r $microsip_dir
    sudo rm -r "/home/$usr/.wine/drive_c/users/$usr/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/MicroSIP"
    sudo rm -r "/home/$usr/Área de Trabalho/MicroSIP.desktop"
fi

# Atualização de recursos e configurações

sudo apt update -y

sudo apt upgrade -y

sudo apt install google-chrome-stable -y

sudo chown root:root /usr/share/applications/org.gnome.Terminal.desktop # Garante que o proprietário do arquivo org.gnome.Terminal.desktop é o root

sudo chmod 700 /usr/share/applications/org.gnome.Terminal.desktop # Garante que somente o proprietário do arquivo org.gnome.Terminal.desktop pode executá-lo

sudo cp -r Fontes/ /usr/share/fonts/truetype/ # Atualiza as fontes para impressão

cd imagens

sudo cp default_background.jpg /usr/share/backgrounds/linuxmint # Atualiza o plano de fundo do sistema

sudo cp linuxmint-logo-ring-symbolic.svg /usr/share/icons/hicolor/scalable/apps/linuxmint-logo-ring-symbolic.svg # Atualiza o logo do sistema operacional

cd ..

sudo chmod +x temasJATI.sh

sudo -E ./temasJATI.sh # Executa um script para alterar a logo do sistema durante o boot

sudo sed -i '/EnableAudio/s/1/0/' /usr/NX/etc/node.cfg  # Altera o conteúdo do arquivo node.cfg na linha com o valor "EnableAudio" de 1 para 0 

sudo chmod 700 /home/administrador

cd ..

sudo chmod +x ocs-install.sh

sudo ./ocs-install.sh

cd mintjati_new_att

# Configurando um valor no kerberos para que a impressora quando configurada via SMB não desconfigure caso o usuário altere a senha
echo "        forwardable = true
        proxiable = true" >> /etc/krb5.conf
        sudo service smbd restart

echo

# Criando o registro da versão do script na máquina

if [ ! -d "/opt/reg" ]; then
    sudo mkdir -p "/opt/reg"
fi

if [ ! -d "/opt/reg_old" ]; then
    sudo mkdir -p "/opt/reg_old"
fi

att_ver="1"

data_atual=$(date +%d-%m-%Y)

dir_ver=/opt/reg/att_ver

reg_ver="O script atualização do sistema operacional foi rodado na versão $att_ver na data $data_atual pelo técnico $domain_usr."

if [ -e $dir_ver ]; then
    if cmp -s "$dir_ver" <(echo "$reg_ver"); then
        echo "O conteúdo do registro da versão do sistema é o mesmo que está tentando registrar"
    else
        echo "Já há um registro de versão do sistema, segue a versão atual: $(cat $dir_ver)"
        echo $(cat "$dir_ver") | sudo tee -a /opt/reg_old/att_old >/dev/null
        echo $reg_ver | sudo tee "$dir_ver" >/dev/null
    fi
else
    echo $reg_ver | sudo tee "$dir_ver" >/dev/null
fi

cd ..

sudo cp -r skel-att/. /etc/skel/