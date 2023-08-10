#!/bin/bash

chmod +x rep.sh 

./rep sh

export domain_usr

echo "Iniciando a padronização do Linux Mint V.3! ( ͡❛ ͜ʖ ͡❛)"

sleep 5

# Atualizando os pacotes do sistema para garantir o funcionamento de todos os softwares.

sudo apt update -y --fix-missing && sudo apt upgrade -y --fix-missing

sudo apt --fix-broken install -y

# Garante que o dono do atalho para o terminalé root para impedir mudanças indevidas de usuários sem permissão

sudo chown root:root /usr/share/applications/org.gnome.Terminal.desktop

sudo chmod 700 /usr/share/applications/org.gnome.Terminal.desktop
''
# Realiza a troca dos logos do Linux Mint para os logos da Jatinox

cd ..

sudo cp -r Fontes/ /usr/share/fonts/truetype/

cd imagens

sudo cp default_background.jpg /usr/share/backgrounds/linuxmint

sudo cp linuxmint-logo-ring-symbolic.svg /usr/share/icons/hicolor/scalable/apps/linuxmint-logo-ring-symbolic.svg

cd ..

cd scripts

sudo chmod +x temasJATI.sh

sudo ./temasJATI.sh

cd ..

sudo mv /usr/bin/cinnamon-settings /usr/local/bin/cinnamon-settings-disabled

# Realiza a instalação de diversos programas e algumas configurações básicas deles

cd programas

sudo cp BaldussiTelecom.exe /home/administrador/Área\ de\ Trabalho/

sudo dpkg -i spark_2_9_4.deb

sudo cp spark-core-2.9.4.jar /opt/Spark/lib/

sudo dpkg -i nomachine_8.5.3_1_amd64.deb

sudo sed -i '/EnableAudio/s/# *//; s/1/0/' /usr/NX/etc/node.cfg

sudo apt install libauthen-pam-perl libio-pty-perl -y

sudo apt install libfaudio0 -y

sudo apt install openssh-server -y --fix-missing

sudo apt install default-jre -y

sudo apt --fix-broken install -y

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo dpkg -i -y google-chrome-stable_current_amd64.deb

sudo apt-get install -y -f

cd ..

# Realiza a instalação do driver de impressão

cd Driver_impressora_M4020

sudo chmod +x noarch/package_install.sh

sudo chmod +x install.sh && sudo ./install.sh

cd ..

# Executa scripts secundários que realizam a instalação de softwares mais complexos

cd scripts

sudo apt --fix-broken install -y

chmod +x firefox-cache.sh

sudo -E ./firefox-cache.sh

chmod +x chrome-cache.sh

sudo -E ./chrome-cache.sh

sudo chmod +x ocs-install.sh

sudo -E ./ocs-install.sh

mi=0

export mi

sudo chmod +x cid-install.sh

sudo -E ./cid-install.sh

sudo chmod +x wine-install.sh

sudo -E ./wine-install.sh

# Essa seção em específico altera o kerberos para impedir que as impressoras configuradas através do método samba não percam autênticação caso o usuário mude de senha
echo "        forwardable = true
        proxiable = true" >> /etc/krb5.conf

sudo service smbd restart
#
echo Alterando senha do usuário root

sudo apt-get update

sudo apt-get install language-pack-pt language-pack-pt-base

export LANG=pt_BR.UTF-8 && sudo passwd root

sudo apt update -y --fix-missing && sudo apt upgrade -y --fix-missing

sudo apt --fix-broken install -y

# Aplica o skel predefinido para que algumas alterações como aplicativos presentes na área de trabalho e configuração dos navegadores estejam no padrão predefinido

cd ..

echo Copiando skel

sudo cp -r skel-att/. /etc/skel/

sudo chmod 700 /home/administrador

if [ ! -d "/opt/reg" ]; then
    sudo mkdir -p "/opt/reg"
fi

if [ ! -d "/opt/reg_old" ]; then
    sudo mkdir -p "/opt/reg_old"
fi

wine /home/administrador/Área\ de\ Trabalho/BaldussiTelecom.exe

# Desativar proteção de tela 

sudo gsettings set org.gnome.desktop.screensaver idle-activation-enabled false

script_ver="1"

data_atual=$(date +%d-%m-%Y)

dir_ver=/opt/reg/mint_ver

reg_ver="Esse sistema foi configurado na versão "$script_ver" na data "$data_atual" pelo técnico "$domain_usr"."

if [ -e "$dir_ver" ]; then
    if cmp -s "$dir_ver" <(echo "$reg_ver"); then
        echo "O conteúdo do registro da versão do sistema é o mesmo que está tentando registrar"
    else
        echo $(cat "$dir_ver") | sudo tee -a /opt/reg_old/mint_ver_old >/dev/null
        echo "$reg_ver" | sudo tee "$dir_ver" >/dev/null
    fi
else
    echo "$reg_ver" | sudo tee "$dir_ver" >/dev/null
fi
