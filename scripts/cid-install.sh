#!/bin/bash

# Esse script faz a instalação de todos os recursos necessários para o funcionamento do CID, de forma o colaborador possa acessar o domínio jati.local e consiga logar com seu usuário nas máquinas com o sistema Linux.

echo Instalando e configurando o CID.

sudo apt update -y && sudo apt upgrade -y

sudo apt install

sudo apt --fix-broken install -y

sudo add-apt-repository ppa:emoraes25/cid -y

sudo apt update -y

sudo apt install cid cid-gtk -y

if [ $? -ne 0 ]; then
    sudo apt --fix-broken install -y
    
    sudo apt install cid cid-gtk -y --fix-missing
fi

# O processo a seguir é o processo de criação de um registro no diretório /opt para controle do que foi executado no sistema.

if [ ! -d "/opt/reg" ]; then
    sudo mkdir -p "/opt/reg"
fi

if [ ! -d "/opt/reg_old" ]; then
    sudo mkdir -p "/opt/reg_old"
fi

data_atual=$(date +%d-%m-%Y)

dir_ver=/opt/reg/cid_ver

reg_ver="O script de instalação do cid foi executado na data $data_atual pelo técnico $domain_usr."

if [ -e "$dir_ver" ]; then
    if cmp -s "$dir_ver" <(echo "$reg_ver"); then
        echo "O conteúdo do registro da versão do sistema é o mesmo que está tentando registrar"
    else
        echo $(cat "$dir_ver") | sudo tee -a /opt/reg_old/cid_ver_old >/dev/null
        echo $reg_ver | sudo tee "$dir_ver" >/dev/null
    fi
else
    echo $reg_ver | sudo tee "$dir_ver" >/dev/null
fi

# O processo a seguir utilizar variáveis do ambiente definidas anteriormente para configurar o acesso ao domínio, a variável $mi é definida como 1 no main.sh para que o sistema reinicie após a configuração do CID mas definida como 0 no mintinstall para que o sistema finalize o script e mantenha o sistema ligado.

read -s -p "Digite sua senha do usuário do domínio: " domain_passwd

sudo cid join domain=jati.local user=$domain_usr pass=$domain_passwd

if [ "$mi" = "1" ]; then
    echo Processo de instalação e configuração do CID finalizado
    read -p "Atenção, o sistema deve ser reiniciado para que as alterações possam fazer efeito, deseja fazer isso agora? [Y/N] " qa
    if [[ "$qa" == [Yy] ]]; then
        echo "Reiniciando o sistema operacional em 5..."
        sleep 5
        reboot
    else
        echo "O sistema não será reiniciado agora."
    fi
else
    echo Processo de instalação e configuração do CID finalizado
fi