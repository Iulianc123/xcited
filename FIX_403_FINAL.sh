#!/bin/bash
# Fix 403 Forbidden - Mută ProxyPass înainte de Directory

VHOST="/usr/local/apache/conf.d/vhosts/xcited.ro.conf"
BACKUP="${VHOST}.backup.$(date +%s)"
cp "$VHOST" "$BACKUP"
echo "Backup: $BACKUP"

# Verifică configurația actuală
echo "=== Configurația actuală (primele 60 linii) ==="
head -60 "$VHOST"

# Găsește primul VirtualHost pentru xcited.ro
FIRST_VHOST_START=$(grep -n "^<VirtualHost" "$VHOST" | head -1 | cut -d: -f1)
echo ""
echo "Primul VirtualHost începe la linia: $FIRST_VHOST_START"

# Extrage primul VirtualHost
sed -n "${FIRST_VHOST_START},/^<\/VirtualHost>/p" "$VHOST" > /tmp/vhost_content.txt

# Verifică ordinea
DIRECTORY_LINE=$(grep -n "<Directory" /tmp/vhost_content.txt | head -1 | cut -d: -f1)
PROXYPASS_LINE=$(grep -n "ProxyPass /" /tmp/vhost_content.txt | head -1 | cut -d: -f1)

echo "Directory la linia: $DIRECTORY_LINE"
echo "ProxyPass la linia: $PROXYPASS_LINE"

if [ -n "$DIRECTORY_LINE" ] && [ -n "$PROXYPASS_LINE" ] && [ "$DIRECTORY_LINE" -lt "$PROXYPASS_LINE" ]; then
  echo ""
  echo "❌ PROBLEMĂ: Directory este ÎNAINTE de ProxyPass!"
  echo "   Trebuie să mutăm ProxyPass înainte de Directory"
  
  # Extrage blocul ProxyPass
  PROXY_START=$(grep -n "ProxyPreserveHost\|ProxyPass" /tmp/vhost_content.txt | head -1 | cut -d: -f1)
  PROXY_END=$(grep -n "ProxyPassReverse\|ProxyRequests" /tmp/vhost_content.txt | tail -1 | cut -d: -f1)
  
  # Creează versiunea fixată
  awk -v dir_line="$DIRECTORY_LINE" -v proxy_start="$PROXY_START" -v proxy_end="$PROXY_END" '
    BEGIN { proxy_block=""; before_dir=""; after_dir=""; in_proxy=0 }
    {
      if (NR >= proxy_start && NR <= proxy_end) {
        proxy_block = proxy_block $0 "\n"
        in_proxy=1
      } else if (NR < dir_line) {
        before_dir = before_dir $0 "\n"
      } else {
        after_dir = after_dir $0 "\n"
      }
    }
    END {
      # Output: before_dir, proxy_block, after_dir
      printf "%s%s%s", before_dir, proxy_block, after_dir
    }
  ' /tmp/vhost_content.txt > /tmp/vhost_fixed.txt
  
  # Înlocuiește în fișierul original
  head -n $((FIRST_VHOST_START - 1)) "$VHOST" > /tmp/vhost_new.txt
  cat /tmp/vhost_fixed.txt >> /tmp/vhost_new.txt
  tail -n +$((FIRST_VHOST_START + $(wc -l < /tmp/vhost_content.txt))) "$VHOST" >> /tmp/vhost_new.txt 2>/dev/null || true
  
  mv /tmp/vhost_new.txt "$VHOST"
  echo "✅ ProxyPass mutat înainte de Directory"
else
  echo ""
  echo "✅ ProxyPass este deja înainte de Directory sau ordinea e OK"
fi

# Verifică dacă portul este 3002
if ! grep -q "ProxyPass / http://127.0.0.1:3002/" "$VHOST"; then
  echo ""
  echo "⚠️  Portul nu este 3002, actualizând..."
  sed -i 's|ProxyPass / http://127.0.0.1:[0-9]*/|ProxyPass / http://127.0.0.1:3002/|g' "$VHOST"
  sed -i 's|ProxyPassReverse / http://127.0.0.1:[0-9]*/|ProxyPassReverse / http://127.0.0.1:3002/|g' "$VHOST"
fi

echo ""
echo "=== Configurația după fix (primele 60 linii) ==="
head -60 "$VHOST"

echo ""
echo "=== Verificare sintaxă Apache ==="
/usr/local/apache/bin/httpd -t

echo ""
echo "=== Reload Apache ==="
/usr/local/apache/bin/httpd -k graceful

echo ""
echo "=== Test ==="
curl -I http://127.0.0.1:3002 2>/dev/null | head -3
echo ""
curl -I http://xcited.ro/ 2>/dev/null | head -5
