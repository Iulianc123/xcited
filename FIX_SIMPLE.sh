#!/bin/bash
# Fix simplu - șterge blocul ModSecurity și restaurează backup

VHOST="/usr/local/apache/conf.d/vhosts/xcited.ro.conf"

echo "Restaurează ultimul backup funcțional..."
# Găsește ultimul backup
BACKUP=$(ls -t "${VHOST}".backup* 2>/dev/null | head -1)

if [ -n "$BACKUP" ]; then
    echo "Folosind backup: $BACKUP"
    cp "$BACKUP" "$VHOST"
else
    echo "Nu există backup - șterge toate blocurile ModSecurity..."
    sed -i '/mod_security/d' "$VHOST"
    sed -i '/SecRuleEngine/d' "$VHOST"
    sed -i '/SecFilterEngine/d' "$VHOST"
fi

# Șterge orice bloc IfModule mod_security rămas
sed -i '/<IfModule mod_security/d' "$VHOST"
sed -i '/<\/IfModule>/d' "$VHOST"

echo ""
echo "Verifică sintaxa:"
/usr/local/apache/bin/httpd -t

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Sintaxa OK"
    echo ""
    echo "ModSecurity nu este încărcat ca modul Apache."
    echo "Trebuie dezactivat prin CWP7pro panel:"
    echo "  1. WebServer Settings > ModSecurity"
    echo "  2. Găsește xcited.ro"
    echo "  3. Dezactivează ModSecurity pentru acest domeniu"
    echo ""
    echo "SAU adaugă excepție în:"
    echo "  /usr/local/apache/modsecurity-cwaf/rules/userdata_wl_domain"
    echo ""
    echo "Reload Apache:"
    /usr/local/apache/bin/httpd -k graceful
else
    echo ""
    echo "❌ Încă există erori - verifică manual cu:"
    echo "  vi $VHOST"
fi
