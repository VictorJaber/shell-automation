#!/bin/bash

padronizacao() {
    echo "Padronizando completa iniciada. :) "
    sleep 3
    if [ ! -e "$(pwd)/mintinstall.sh" ]; then 
        sudo tar -zxvf driver_impressora_M4020.tar.gz
        sudo tar -zxvf fontes.tar.gz
        sudo tar -zxvf imagens.tar.gz
        sudo tar -zxvf macbuntu.tar.gz
        sudo tar -zxvf ocsinventory-Unix-Agent-2.10.0.tar.gz
        sudo tar -zxvf programas.tar.gz
        sudo tar -zxvf scripts.tar.gz
        sudo tar -zxvf skel.tar.gz
    fi
    cd scripts 
    sudo chmod +x mintinstall.sh && sudo -E ./mintinstall.sh
    cd ..
}

cid() {
    echo "Rodando o script para instalação do CID"
    if [ ! -e "$(pwd)/cid-install.sh" ]; then
        sudo tar -zxvf scripts.tar.gz
    fi
    mi=1
    export mi
    cd scripts
    sudo chmod +x cid-install.sh && sudo -E ./cid-install.sh
}

wine() {
    echo "Rodando o script para instalação do Wine"
    if [ ! -e "$(pwd)/wine-install.sh" ]; then
        sudo tar -zxvf scripts.tar.gz
    fi
    cd scripts
    sudo chmod +x wine-install.sh && sudo -E ./wine-install.sh
}

ocs() {
    echo "Rodando o script para instalação do OCS"
    if [ ! -e "$(pwd)/ocs-install.sh" ]; then
        sudo tar -zxvf scripts.tar.gz
    fi
    if [ ! -e "$(pwd)/Ocsinventory-Unix-Agent-2.10.0" ]; then
        sudo tar -zxvf ocsinventory-Unix-Agent-2.10.0.tar.gz
    fi
    cd scripts
    sudo chmod +x ocs-install.sh && sudo -E ./ocs-install.sh
}

fontes() {
    echo "Rodando o script para instalação de fontes"
    if [ ! -e "$(pwd)/Fontes" ]; then
        sudo tar -zxvf fontes.tar.gz
    fi
    sudo cp -r Fontes/ /usr/share/fonts/truetype/
}

usbguard() {
    echo "Rodando o script para instalação do USBguard"
    if [ ! -e "$(pwd)/scripts-usb" ]; then
        sudo tar -zxvf scripts-usb.tar.gz
    fi
    cd "$(pwd)/scripts-usb"
    sudo chmod +x def-usbwhitelist.sh && sudo -E ./def-usbwhitelist.sh
    cd ..
}

rmusbguard() {
    echo "Rodando o script para remoção do USBguard"
    if [ ! -e "$(pwd)/scripts-usb" ]; then
        sudo tar -zxvf scripts-usb.tar.gz
    fi
    cd "$(pwd)/scripts-usb"
    sudo chmod +x def-usbremove.sh && sudo -E ./def-usbremove.sh
    cd ..
}

skel() {
    echo "Aplicando Skel predefinido"
    if [ ! -e "$(pwd)/skel-att" ]; then
        sudo tar -zxvf skel.tar.gz
    fi
    sudo cp -r skel-att/. /etc/skel/
}

rmsoft() {
    echo "Removendo softwares antigos."
    if [ ! -e "$(pwd)/mintjati_new_att" ]; then
        sudo tar -zxvf mintjati_new_att.tar.gz
        sudo tar -zxvf Ocsinventory-Unix-Agent-2.10.0.tar.gz
        sudo tar -zxvf scripts.tar.gz
    fi
    if [ ! -e "$(pwd)/skel-att" ]; then
        sudo tar -zxvf skel-compact.tar.gz
    fi
    cd mintjati_new_att
    sudo chmod +x new_att.sh && sudo -E ./new_att.sh
    cd ..
}

driverprinter() {
    echo "Instalando driver para a impressora M4020"
    if [ ! -e "$(pwd)/Driver_impressora_M4020/" ]; then
        sudo tar -zxvf driverImpressoraM4020.tar.gz
    fi
    cd Driver_impressora_M4020
    sudo chmod +x noarch/package_install.sh
    sudo chmod +x install.sh && sudo -E ./install.sh
    cd ..
}

kerberos() {
    echo "Alterando parâmetros do Kerberos para autenticação de impressões via protocolo Samba"
    echo "        forwardable = true
        proxiable = true" >> /etc/krb5.conf
    sudo service smbd restart
}


descanso_tela() {
    echo "Retirando suspensão de tela e o modo de descanso"
    xset s off -dpms
    echo "Retirado com sucesso"
}


solicitar_proxima_funcao() {
    read -p "Deseja executar outra função? (S/N): " resposta
    if [[ "$resposta" == "S" || "$resposta" == "s" ]]; then
        return 0  
    else
        return 1  
    fi
}

read -p "Informe o seu usuário do AD: " domain_usr 
export domain_usr

echo "Preparando o ambiente..."

if [ -d "/opt/mintjati" ]; then
    diff_output=$(diff -r . /opt/mintjati)
    if [ "$diff_output" != "" ]; then
        sudo cp -r . /opt/mintjati
        echo "Conteúdo do diretório /opt/mintjati atualizado."
    else
        echo "O conteúdo do diretório /opt/mintjati é igual ao diretório atual. Nenhuma ação necessária."
    fi
else
    sudo cp -r "$(pwd)" /opt/
    echo "Conteúdo do diretório atual copiado para /opt."
fi


while true; do
    echo "O que você deseja fazer no sistema operacional?"
    echo "1 - Padronizar"
    echo "2 - CID"
    echo "3 - Wine"
    echo "4 - OCS"
    echo "5 - Fontes"
    echo "6 - Instalar USBguard"
    echo "7 - Remover USBguard"
    echo "8 - Aplicar o Skel"
    echo "9 - Remover softwares antigos"
    echo "10 - Instalar driver para a impressora M4020"
    echo "11 - Corrigir autenticação do Kerberos para impressão via Samba"
    echo "12 - Retirar o descanso de tela"
    echo "0 - Sair"

    read -p "Opção n°: " opcao

    case $opcao in
        0)
            echo "Encerrando o script."
            exit
            ;;
        1)
            echo "Opção 1 selecionada."
            padronizacao
            ;;
        2)
            echo "Opção 2 selecionada."
            cid
            ;;
        3)
            echo "Opção 3 selecionada."
            wine
            ;;
        4)
            echo "Opção 4 selecionada."
            ocs
            ;;
        5)
            echo "Opção 5 selecionada."
            fontes
            ;;
        6)
            echo "Opção 6 selecionada."
            usbguard
            ;;
        7)
            echo "Opção 7 selecionada."
            rmusbguard
            ;;
        8)
            echo "Opção 8 selecionada."
            skel
            ;;
        9)
            echo "Opção 9 selecionada."
            rmsoft
            ;;
        10)
            echo "Opção 10 selecionada."
            driverprinter
            ;;
        11)
            echo "Opção 11 selecionada."
            kerberos
            ;;
        12) 
            echo "Opção 12 selecionada"
            descanso_tela
            ;;
        *)
            echo "Opção inválida."
            ;;
    esac

    solicitar_proxima_funcao
    continuar=$?
    if [ $continuar -eq 1 ]; then
        break  
    fi
done
