#!/bin/bash
VHOST="/usr/local/apache/conf.d/vhosts/xcited.ro.conf"
cp "$VHOST" "${VHOST}.backup6"

# Șterge TOATE liniile care conțin ModSecurity sau IfModule mod_security
sed -i '/ModSecurity/d' "$VHOST"
sed -i '/mod_security/d' "$VHOST"
sed -i '/SecRuleEngine/d' "$VHOST"

# Găsește prima linie VirtualHost
FIRST_LINE=$(grep -n "^<VirtualHost" "$VHOST" | head -1 | cut -d: -f1)

# Creează fișier nou cu blocul ModSecurity corect inserat
head -n "$FIRST_LINE" "$VHOST" > /tmp/vhost_fixed.txt
echo -e "\t<IfModule mod_security2.c>" >> /tmp/vhost_fixed.txt
echo -e "\t\tSecRuleEngine Off" >> /tmp/vhost_fixed.txt
echo -e "\t</IfModule>" >> /tmp/vhost_fixed.txt
tail -n +$((FIRST_LINE + 1)) "$VHOST" >> /tmp/vhost_fixed.txt

mv /tmp/vhost_fixed.txt "$VHOST"

echo "✅ ModSecurity disabled"
echo "Verifică sintaxa:"
/usr/local/apache/bin/httpd -t
