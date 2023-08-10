#!/bin/bash

# O objetivo desse script é configurar o Google Chrome para apagar o cache assim que fechar.

echo Configurando o Google Chrome para limpar o cache ao fechar.

PROFILE=$(find ~/.config/google-chrome/ -type d -name "Default" | head -1)

echo '{ "settings": { "clear_data": { "on_exit": true } } }' > "$PROFILE/Preferences"

echo "Google Chrome configurado para limpar o cache ao fechar."