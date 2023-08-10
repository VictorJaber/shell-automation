#!/bin/bash

echo "Atualizando repositórios, aguarde..."

sudo apt clean 

if [[ $(id -u) -ne 0 ]]; then
  echo "Este script requer permissões de superusuário. Execute-o com sudo."
  exit 1
fi


texto_a_sobrescrever="
deb [trusted=yes] http://repolinux.jati.com.br/archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse

deb [trusted=yes] http://repolinux.jati.com.br/archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse

deb [trusted=yes] http://repolinux.jati.com.br/archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse

deb [trusted=yes] http://repolinux.jati.com.br/packages.linuxmint.com/ una main upstream import backport

deb [trusted=yes] http://repolinux.jati.com.br/archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse

deb [trusted=yes] http://repolinux.jati.com.br/programas ./
"


if [ -f "/etc/apt/sources.list" ]; then

  echo "$texto_a_sobrescrever" > /etc/apt/sources.list
  echo "Texto sobrescrito com sucesso."
else
  echo "O arquivo /etc/apt/sources.list não existe ou é inválido."
  exit 1
fi
