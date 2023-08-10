#!/bin/bash

# O objetivo desse script é configurar o Firefox para apagar o cache assim que fechar.

echo Configurando o Firefox para limpar o cache ao fechar.

PROFILE=$(find ~/.mozilla/firefox/ -type d -name "*.default-release" | head -1)

cat <<EOF >> "$PROFILE/prefs.js"
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.enable", false);
user_pref("browser.cache.offline.enable", false);
user_pref("network.http.use-cache", false);
EOF

echo "user_pref(\"browser.sessionstore.warnOnQuit\", false);" >> "$PROFILE/prefs.js"

echo "Firefox configurado para limpar o cache ao fechar."