#!/bin/bash
# Fix 403 - Mută ProxyPass înainte de Directory

VHOST="/usr/local/apache/conf.d/vhosts/xcited.ro.conf"
BACKUP="${VHOST}.backup.$(date +%s)"
cp "$VHOST" "$BACKUP"
echo "Backup: $BACKUP"

# Găsește primul VirtualHost
FIRST_VHOST_START=$(grep -n "^<VirtualHost" "$VHOST" | head -1 | cut -d: -f1)
FIRST_VHOST_END=$(awk -v start="$FIRST_VHOST_START" 'NR > start && /^<\/VirtualHost>/ {print NR; exit}' "$VHOST")

echo "VirtualHost: linia $FIRST_VHOST_START - $FIRST_VHOST_END"

# Extrage primul VirtualHost
sed -n "${FIRST_VHOST_START},${FIRST_VHOST_END}p" "$VHOST" > /tmp/vhost.txt

# Găsește liniile Directory și ProxyPass
DIR_LINE=$(grep -n "<Directory" /tmp/vhost.txt | head -1 | cut -d: -f1)
PROXY_LINE=$(grep -n "ProxyPass /" /tmp/vhost.txt | head -1 | cut -d: -f1)

echo "Directory la linia: $DIR_LINE (relativ)"
echo "ProxyPass la linia: $PROXY_LINE (relativ)"

if [ -n "$DIR_LINE" ] && [ -n "$PROXY_LINE" ] && [ "$DIR_LINE" -lt "$PROXY_LINE" ]; then
  echo "❌ Directory este înainte de ProxyPass - FIXING..."
  
  # Extrage blocul ProxyPass (liniile 60-65 aproximativ)
  PROXY_START=$(grep -n "ProxyPreserveHost\|ProxyPass" /tmp/vhost.txt | head -1 | cut -d: -f1)
  PROXY_END=$(grep -n "ProxyPassReverse\|ProxyRequests" /tmp/vhost.txt | tail -1 | cut -d: -f1)
  
  echo "ProxyPass bloc: linia $PROXY_START - $PROXY_END"
  
  # Extrage blocul ProxyPass
  sed -n "${PROXY_START},${PROXY_END}p" /tmp/vhost.txt > /tmp/proxy_block.txt
  
  # Creează versiunea fixată: totul înainte de Directory, apoi ProxyPass, apoi Directory și restul
  head -n $((DIR_LINE - 1)) /tmp/vhost.txt > /tmp/vhost_fixed.txt
  cat /tmp/proxy_block.txt >> /tmp/vhost_fixed.txt
  echo "" >> /tmp/vhost_fixed.txt
  tail -n +$DIR_LINE /tmp/vhost.txt | head -n -$((PROXY_END - DIR_LINE + 1)) >> /tmp/vhost_fixed.txt
  tail -n +$((PROXY_END + 1)) /tmp/vhost.txt >> /tmp/vhost_fixed.txt
  
  # Înlocuiește în fișierul original
  head -n $((FIRST_VHOST_START - 1)) "$VHOST" > /tmp/vhost_new.txt
  cat /tmp/vhost_fixed.txt >> /tmp/vhost_new.txt
  tail -n +$((FIRST_VHOST_END + 1)) "$VHOST" >> /tmp/vhost_new.txt 2>/dev/null || true
  
  mv /tmp/vhost_new.txt "$VHOST"
  echo "✅ ProxyPass mutat înainte de Directory"
else
  echo "✅ Ordinea este OK"
fi

# Verifică sintaxa
echo ""
echo "=== Verificare sintaxă ==="
/usr/local/apache/bin/httpd -t

# Reload
echo ""
echo "=== Reload Apache ==="
/usr/local/apache/bin/httpd -k graceful

# Test
echo ""
echo "=== Test ==="
sleep 2
curl -I http://xcited.ro/ 2>&1 | head -10
