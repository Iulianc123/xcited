# Fix ProxyPass Port în CWP VirtualHost

## Problema:
Configurația CWP are ProxyPass pe portul 2095 (serviciu CWP), dar trebuie să pointeze la 3002 (aplicația Next.js).

## Soluție (rulează pe server ca root):

### 1. Verifică configurația completă:
```bash
cat /usr/local/apache/conf.d/vhosts/xcited.ro.conf | head -60
```

### 2. Găsește VirtualHost-ul principal pentru xcited.ro (nu subdomeniile):
```bash
# Găsește linia cu ServerName xcited.ro (primul, nu subdomeniile)
grep -n "ServerName xcited.ro" /usr/local/apache/conf.d/vhosts/xcited.ro.conf | head -1
```

### 3. Modifică ProxyPass pentru VirtualHost-ul principal:
```bash
# Backup
cp /usr/local/apache/conf.d/vhosts/xcited.ro.conf /usr/local/apache/conf.d/vhosts/xcited.ro.conf.backup2

# Găsește primul ProxyPass pentru VirtualHost-ul principal (nu subdomeniile)
# Modifică doar primul ProxyPass care este pentru xcited.ro (nu pentru webmail, mail, cpanel)
# Trebuie să modificăm ProxyPass-ul care este în primul VirtualHost (după ServerName xcited.ro)

# Soluție: înlocuiește ProxyPass pentru portul 2095 cu 3002 în primul VirtualHost
# Dar trebuie să fii atent să nu modifici subdomeniile (webmail, mail, cpanel)

# Verifică structura
sed -n '/^<VirtualHost/,/^<\/VirtualHost>/p' /usr/local/apache/conf.d/vhosts/xcited.ro.conf | head -40
```

### 4. Modificare manuală (RECOMANDAT):

Editează fișierul:
```bash
nano /usr/local/apache/conf.d/vhosts/xcited.ro.conf
```

Găsește primul VirtualHost (cel care începe cu `<VirtualHost *:80>` și are `ServerName xcited.ro`).

În acest VirtualHost, găsește:
```apache
ProxyPass / http://127.0.0.1:2095/
ProxyPassReverse / http://127.0.0.1:2095/
```

Și înlocuiește cu:
```apache
ProxyPass / http://127.0.0.1:3002/
ProxyPassReverse / http://127.0.0.1:3002/
```

**IMPORTANT:** Nu modifica ProxyPass-urile pentru subdomeniile (webmail, mail, cpanel) - acestea trebuie să rămână pe porturile lor (2031, 2083).

### 5. Verifică sintaxa:
```bash
/usr/local/apache/bin/httpd -t
```

### 6. Reload Apache:
```bash
/usr/local/apache/bin/httpd -k graceful
```

### 7. Testează:
```bash
curl -v http://xcited.ro/ 2>&1 | head -30
```

## Alternativă: Script automat (mai sigur)

```bash
# Backup
cp /usr/local/apache/conf.d/vhosts/xcited.ro.conf /usr/local/apache/conf.d/vhosts/xcited.ro.conf.backup3

# Găsește primul VirtualHost pentru xcited.ro (nu subdomeniile)
# Modifică doar ProxyPass-ul din primul VirtualHost
# Folosim awk pentru a modifica doar primul VirtualHost

awk '
/^<VirtualHost/ { vhost=1; in_first=1 }
/^<\/VirtualHost>/ { vhost=0; in_first=0 }
vhost && /ServerName xcited.ro/ && in_first { is_main=1 }
vhost && /ServerName/ && !/xcited.ro/ { is_main=0 }
is_main && /ProxyPass \/ http:\/\/127.0.0.1:2095\// { 
    gsub(/2095/, "3002")
}
is_main && /ProxyPassReverse \/ http:\/\/127.0.0.1:2095\// {
    gsub(/2095/, "3002")
}
{ print }
' /usr/local/apache/conf.d/vhosts/xcited.ro.conf > /tmp/xcited.ro.conf.new

# Verifică diferențele
diff /usr/local/apache/conf.d/vhosts/xcited.ro.conf /tmp/xcited.ro.conf.new | head -20

# Dacă arată bine, aplică modificările
mv /tmp/xcited.ro.conf.new /usr/local/apache/conf.d/vhosts/xcited.ro.conf
```

## Verificare finală:

```bash
# Verifică că doar primul ProxyPass a fost modificat
grep -B 5 -A 5 "ProxyPass.*3002" /usr/local/apache/conf.d/vhosts/xcited.ro.conf

# Verifică că subdomeniile nu au fost modificate
grep "ProxyPass.*2095\|2031\|2083" /usr/local/apache/conf.d/vhosts/xcited.ro.conf

# Testează
curl -v http://xcited.ro/ 2>&1 | head -20
```
