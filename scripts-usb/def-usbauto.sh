#!/bin/bash
# Script complementar para o funcionamento automático do def-usbwhitelist.sh

# Declarando variáveis que irão receber os IDS dos dispositivos
teclado=$(lsusb | grep Keyboard | awk '{print $6}') # Variável que irá receber todos os IDs dos dispositivos identificados como "Keyboard".

mouse=$(lsusb | grep Mouse | awk '{print $6}') # Variável que irá receber todos os IDs dos dispositivos identificados como "Mouse".

headset=$(lsusb | grep Headset | awk '{print $6}') # Variável que irá receber todos os IDs dos dispositivos identificados como "Headset".

audio=$(lsusb | grep Audio | awk '{print $6}') # Variável que irá receber todos os IDs dos dispositivos identificados como "Audio".

voip=$(lsusb | grep Voip | awk '{print $6}') # Variável que irá receber todos os IDs dos dispositivos identificados como "Voip".

idusb=$(echo $teclado $mouse $headset $audio $voip) # Variável que irá receber todas as outras variáveis.

rulespath="/etc/usbguard/rules.conf" # Variável que recebe o caminho para o arquivo a ser editado.

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
lsusb

echo "Lista de dispositivos registrados na regra:"
cat /etc/usbguard/rules.conf | cut -d " " -f -9

# Reinicia o serviço do usbguard.
systemctl restart usbguard.service