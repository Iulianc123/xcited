# Debug 403 Forbidden Error

## Verificări necesare pe server:

### 1. Verifică dacă aplicația rulează pe 3002:
```bash
ss -ltnp | grep :3002
curl -v http://127.0.0.1:3002
pm2 list
```

### 2. Verifică configurația VirtualHost:
```bash
cat /usr/local/apache/conf.d/vhosts/xcited.ro.conf | head -50
grep -A 10 "ServerName xcited.ro" /usr/local/apache/conf.d/vhosts/xcited.ro.conf | head -20
```

### 3. Verifică dacă ProxyPass este înainte de Directory:
```bash
# ProxyPass trebuie să fie ÎNAINTE de <Directory>
grep -B 5 -A 10 "ProxyPass" /usr/local/apache/conf.d/vhosts/xcited.ro.conf
```

### 4. Verifică log-urile Apache:
```bash
tail -50 /usr/local/apache/logs/error_log
tail -50 /usr/local/apache/logs/access_log
```

### 5. Verifică dacă modulul proxy este activat:
```bash
/usr/local/apache/bin/httpd -M | grep proxy
```

### 6. Testează ca user Apache:
```bash
sudo -u nobody curl -v http://127.0.0.1:3002
```

### 7. Verifică dacă există Directory directive care blochează:
```bash
grep -A 5 "<Directory" /usr/local/apache/conf.d/vhosts/xcited.ro.conf
```

## Soluție rapidă - Reordonează VirtualHost:

Dacă ProxyPass este după Directory, trebuie să-l mutăm înainte:

```bash
# Backup
cp /usr/local/apache/conf.d/vhosts/xcited.ro.conf /usr/local/apache/conf.d/vhosts/xcited.ro.conf.backup

# Editează manual
nano /usr/local/apache/conf.d/vhosts/xcited.ro.conf
```

În primul VirtualHost (pentru xcited.ro), asigură-te că structura este:

```apache
<VirtualHost *:80>
    ServerName xcited.ro
    ServerAlias www.xcited.ro
    
    # ProxyPass TREBUIE să fie ÎNAINTE de Directory
    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:3002/
    ProxyPassReverse / http://127.0.0.1:3002/
    ProxyRequests Off
    
    DocumentRoot /home/xcited/public_html
    
    <Directory /home/xcited/public_html>
        Options -Indexes +FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
    
    # ... rest of config
</VirtualHost>
```

### Sau folosește sed pentru a reordona automat:

```bash
# Creează un script temporar
cat > /tmp/fix_vhost.sh << 'EOF'
#!/bin/bash
VHOST="/usr/local/apache/conf.d/vhosts/xcited.ro.conf"
BACKUP="${VHOST}.backup.$(date +%s)"
cp "$VHOST" "$BACKUP"

# Extrage primul VirtualHost
awk '/^<VirtualHost \*:80>/,/^<\/VirtualHost>/ {
    if (/^<VirtualHost/) { in_vhost=1; vhost_lines="" }
    if (in_vhost) {
        vhost_lines = vhost_lines $0 "\n"
        if (/^<\/VirtualHost>/) {
            # Verifică dacă ProxyPass este după Directory
            if (vhost_lines ~ /<Directory/ && vhost_lines ~ /ProxyPass/ && index(vhost_lines, "<Directory") < index(vhost_lines, "ProxyPass")) {
                # Reordonează: mută ProxyPass înainte de Directory
                gsub(/ProxyPreserveHost On[^\n]*\nProxyPass[^\n]*\nProxyPassReverse[^\n]*\n/, "", vhost_lines)
                gsub(/<Directory[^>]*>[\s\S]*?<\/Directory>/, "PROXY_BLOCK_HERE\n&", vhost_lines)
                gsub(/PROXY_BLOCK_HERE/, "    ProxyPreserveHost On\n    ProxyPass / http://127.0.0.1:3002/\n    ProxyPassReverse / http://127.0.0.1:3002/\n    ProxyRequests Off\n", vhost_lines)
            }
            print vhost_lines
            in_vhost=0
        }
    } else {
        print
    }
}' "$VHOST" > "${VHOST}.new" && mv "${VHOST}.new" "$VHOST"
EOF

chmod +x /tmp/fix_vhost.sh
/tmp/fix_vhost.sh
```

### Verifică și reload:
```bash
/usr/local/apache/bin/httpd -t
/usr/local/apache/bin/httpd -k graceful
curl -v http://xcited.ro/
```
