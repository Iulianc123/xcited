#!/bin/bash
# Fix ModSecurity pentru CWP7pro

VHOST="/usr/local/apache/conf.d/vhosts/xcited.ro.conf"
cp "$VHOST" "${VHOST}.backup7"

echo "Verifică modulele ModSecurity încărcate..."
/usr/local/apache/bin/httpd -M 2>/dev/null | grep -i security

echo ""
echo "Opțiuni pentru dezactivare ModSecurity în CWP7pro:"
echo "1. SecRuleEngine Off (dacă mod_security2.c este încărcat)"
echo "2. SecFilterEngine Off (pentru versiuni mai vechi)"
echo "3. Dezactivare prin CWP panel"

# Șterge toate blocurile ModSecurity existente
sed -i '/mod_security/d' "$VHOST"
sed -i '/SecRuleEngine/d' "$VHOST"
sed -i '/SecFilterEngine/d' "$VHOST"

# Găsește prima linie VirtualHost
FIRST_LINE=$(grep -n "^<VirtualHost" "$VHOST" | head -1 | cut -d: -f1)

# Încearcă ambele variante
cat > /tmp/modsec_fix.txt << 'EOF'
	# Disable ModSecurity for Next.js app
	<IfModule mod_security2.c>
		SecRuleEngine Off
	</IfModule>
	<IfModule mod_security.c>
		SecFilterEngine Off
	</IfModule>
EOF

# Inserează după prima linie VirtualHost
head -n "$FIRST_LINE" "$VHOST" > /tmp/vhost_new.txt
cat /tmp/modsec_fix.txt >> /tmp/vhost_new.txt
tail -n +$((FIRST_LINE + 1)) "$VHOST" >> /tmp/vhost_new.txt

mv /tmp/vhost_new.txt "$VHOST"

echo ""
echo "✅ ModSecurity disabled (ambele variante)"
echo ""
echo "Verifică sintaxa:"
/usr/local/apache/bin/httpd -t

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Sintaxa OK - reload Apache:"
    /usr/local/apache/bin/httpd -k graceful
    echo ""
    echo "Test:"
    curl -I http://xcited.ro/ 2>&1 | head -5
else
    echo ""
    echo "❌ Eroare de sintaxă - verifică manual"
    echo "Poate mod_security2 nu este încărcat în CWP7pro"
    echo ""
    echo "Alternativă: Dezactivează ModSecurity prin CWP panel:"
    echo "  WebServer Settings > ModSecurity > Disable pentru xcited.ro"
fi
