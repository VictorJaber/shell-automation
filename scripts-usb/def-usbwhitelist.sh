#!/bin/bash
# Script para bloquear os dispositivos USB, exceto mouse e teclado e outros específicados.
# V.4 22/05/2023

: " O objetivo desse script é utilizar o software Usbguard para bloquear o uso de alguns dispositivos conectados nas máquinas.
Para isso eu identifiquei caracteres comuns nos dispositivos que queremos permitir e criei uma lista para que esses nomes sejam usados como parâmetros durante a pesquisa pelos dispositivos conectados na máquina.
Após criar essa lista e adicionar o ID dos dispositivos que estão conectados e que correspondem a esses parâmetros à regra do Usbguard esses dispositivos são permitidos enquanto quaisquer outros não.
"

# Verifica se o usuário é root
if [[ $EUID -ne 0 ]]; then
    echo "Este script precisa ser executado como root"
    exit 1
fi

chmod +x def-usbauto.sh # Da permissão para a execução do script de automação.

chmod +x def-usbremove.sh

# Verifica se o pacote usbguard está instalado
if ! command -v usbguard &> /dev/null; then
    echo "O pacote usbguard não está instalado. prosseguindo para a instalação do mesmo."
    apt install usbguard -y
fi

# Declarando variáveis que irão receber os IDS dos dispositivos
teclado=$(lsusb | grep Keyboard | awk '{print $6}') # Variável que irá receber todos os IDs dos dispositivos identificados como "Keyboard".

mouse=$(lsusb | grep Mouse | awk '{print $6}') # Variável que irá receber todos os IDs dos dispositivos identificados como "Mouse".

headset=$(lsusb | grep Headset | awk '{print $6}') # Variável que irá receber todos os IDs dos dispositivos identificados como "Headset".

audio=$(lsusb | grep Audio | awk '{print $6}') # Variável que irá receber todos os IDs dos dispositivos identificados como "Audio".

voip=$(lsusb | grep Voip | awk '{print $6}') # Variável que irá receber todos os IDs dos dispositivos identificados como "Voip".

idusb=$(echo $teclado $mouse $headset $audio $voip) # Variável que irá receber todas as outras variáveis.

rulespath="/etc/usbguard/rules.conf" # Variável que recebe o caminho para o arquivo a ser editado.

green='\033[1;32m'

blue='\033[1;34m'

NC='\033[0m'

echo -n > /etc/usbguard/rules.conf # Apagando todo o conteúdo da regra pois o pacote usbguard cria uma regra com os dispositivos conectados na máquina automaticamente assim que é instalado.

# Transforma as strings em uma lista.
read -ra lista <<< "$idusb"

# Escreve os valores da lista na regra de dispositivos permitidos.
if [ -s "$rulespath" ]; then # Verifica se o arquivo rules.conf está vazio.
    for item in "${lista[@]}"; do # Itera entre cada dispositivo da lista para realizar as ações a seguir.
        if grep -q "allow id $item" "$rulespath"; then # Verifica os IDs dentro da lista procurando se há algum que já está gravado dentro do arquivo rules.conf
            echo "O dispositivo com ID $item já está cadastrado na regra."
        else
            echo "allow id $item" >> /etc/usbguard/rules.conf # Grava o ID do dispositivo dentro do arquivo rules.conf caso ele já não esteja lá.
        fi
    done
else
    for item in "${lista[@]}"; do # Itera entre cada dispositivo da lista para realizar as ações a seguir.
        echo "allow id $item" >> /etc/usbguard/rules.conf # Grava o ID do dispositivo dentro do arquivo rules.conf caso ele já não esteja lá.
    done
fi

echo "Lista de dispositivos conectados no momento:"
echo -e "${blue}$(lsusb)${NC}"

echo "Lista de dispositivos registrados na regra:"
echo -e "${green}$(cat /etc/usbguard/rules.conf | cut -d " " -f -9)${NC}"

# Habilita o serviço do usbguard.
systemctl enable --now usbguard.service

# Reinicia o serviço do usbguard.
systemctl restart usbguard.service

autorulespath="/etc/udev/rules.d/99-custom.rules" # Variável que recebe o caminho para o arquivo a ser editado.

autorulescontent='ACTION=="add", SUBSYSTEMS=="usb", RUN+="/opt/mintjati/scripts-usb/def-usbauto.sh"' # Variável que recebe o conteúdo a ser inserido dentro do arquivo /etc/udev/rules.d/99-custom.rules

# Verifica o conteúdo do arquivo /etc/udev/rules.d/99-custom.rules e valida qual ação o usuário que está executando o script irá realizar. 
if [ -s "$autorulespath" ]; then # Verifica se o arquivo está vazio.
    if cmp -s "$autorulespath" <(echo "$autorulescontent"); then # Verifica se o conteúdo de dentro do arquivo já é o esperado.
        echo "O conteúdo do arquivo é igual ao conteúdo predefinido."
    else
        echo "O conteúdo do arquivo é diferente do conteúdo predefinido, segue o conteúdo atual:"
        cat "$autorulespath" # Mostra o conteúdo atual do arquivo na tela. 
        read -p "Deseja excluir o conteúdo do arquivo? (Y/N): " respostaexclusao # Valida se o usuário quer excluir o conteúdo do arquivo.
        if [[ "$respostaexclusao" == [Yy] ]]; then
            echo "Excluíndo conteúdo do arquivo"
            echo -n > "$autorulespath" # Apaga o conteúdo atual do arquivo.
            read -p "Deseja inserir o novo conteúdo no arquivo? (Y/N): " respostainsercao # Valida se o usuário quer inserir o novo conteúdo no arquivo.
            if [[ "$respostainsercao" == [Yy] ]]; then
                echo "$autorulescontent" > "$autorulespath" # Grava o conteúdo predefinido dentro do arquivo.
                echo "O conteúdo predefinido foi gravado no arquivo."
            else
                echo "O arquivo será mantido vazio."
            fi
            service udev restart # Reinicia o serviço do udev.
        else
            echo "O conteúdo atual do arquivo será mantido."
        fi
    fi
else
    read -p "O arquivo está vazio, deseja inserir o novo conteúdo no arquivo? (Y/N): " respostainsercao2 # Valida se o usuário quer inserir o novo conteúdo no arquivo.
    if [[ "$respostainsercao2" == [Yy] ]]; then
        echo "$autorulescontent" > "$autorulespath" # Grava o conteúdo predefinido dentro do arquivo.
        echo "O conteúdo predefinido foi inserido no arquivo"
        service udev restart # Reinicia o serviço do udev.
    fi
fi

if [ ! -d "/opt/reg" ]; then
    sudo mkdir -p "/opt/reg"
fi

if [ ! -d "/opt/reg_old" ]; then
    sudo mkdir -p "/opt/reg_old"
fi

usb_ver="4"

data_atual=$(date +%d-%m-%Y)

dir_ver=/opt/reg/usb_ver

reg_ver="O script de bloqueio de dispositivos usb foi configurado na versão $usb_ver na data $data_atual pelo técnico $domain_usr."

if [ -e $dir_ver ]; then
    if cmp -s "$dir_ver" <(echo "$reg_ver"); then
        echo "O conteúdo do registro da versão do sistema é o mesmo que está tentando registrar"
    else
        echo "Já há um registro de versão do sistema, segue a versão atual: $(cat $dir_ver)"
        echo $(cat "$dir_ver") | sudo tee -a /opt/reg_old/usb_ver_old >/dev/null
        echo $reg_ver | sudo tee "$dir_ver" >/dev/null
    fi
else
    echo $reg_ver | sudo tee "$dir_ver" >/dev/null
fi