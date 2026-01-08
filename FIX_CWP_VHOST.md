# Fix CWP7pro VirtualHost pentru xcited.ro

## Problema:
CWP7pro generează automat un VirtualHost în `/usr/local/apache/conf.d/vhosts/xcited.ro.conf` care suprascrie configurația noastră. Trebuie să modificăm configurația CWP existentă.

## Soluție (rulează pe server ca root):

### 1. Verifică configurația CWP existentă:
```bash
cat /usr/local/apache/conf.d/vhosts/xcited.ro.conf | head -60
```

### 2. Backup configurația existentă:
```bash
cp /usr/local/apache/conf.d/vhosts/xcited.ro.conf /usr/local/apache/conf.d/vhosts/xcited.ro.conf.backup
```

### 3. Adaugă ProxyPass în configurația CWP:
```bash
# Găsește linia cu DocumentRoot și adaugă ProxyPass înainte de ea
sed -i '/DocumentRoot/a\
    # Reverse Proxy to Next.js application\
    ProxyPreserveHost On\
    ProxyPass / http://127.0.0.1:3002/\
    ProxyPassReverse / http://127.0.0.1:3002/\
    ProxyRequests Off\
    ProxyTimeout 300\
    RequestHeader set X-Forwarded-Proto "http"\
    RequestHeader set X-Forwarded-For "%{REMOTE_ADDR}e"\
    ProxyErrorOverride Off' /usr/local/apache/conf.d/vhosts/xcited.ro.conf
```

### SAU - Soluție manuală (mai sigură):

Editează manual fișierul:
```bash
nano /usr/local/apache/conf.d/vhosts/xcited.ro.conf
```

Găsește secțiunea pentru `xcited.ro` (primul VirtualHost) și adaugă **ÎNAINTE** de `<Directory>`:

```apache
    # Reverse Proxy to Next.js application
    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:3002/
    ProxyPassReverse / http://127.0.0.1:3002/
    ProxyRequests Off
    ProxyTimeout 300
    RequestHeader set X-Forwarded-Proto "http"
    RequestHeader set X-Forwarded-For "%{REMOTE_ADDR}e"
    ProxyErrorOverride Off
```

### 4. Verifică sintaxa:
```bash
/usr/local/apache/bin/httpd -t
```

### 5. Reload Apache:
```bash
/usr/local/apache/bin/httpd -k graceful
```

### 6. Testează:
```bash
curl -v -H "Host: xcited.ro" http://127.0.0.1/ 2>&1 | head -30
```

## Alternativă: Dezactivează VirtualHost-ul CWP și folosește configurația noastră

Dacă nu vrei să modifici configurația CWP (care poate fi regenerată), poți:

1. Rename configurația CWP:
```bash
mv /usr/local/apache/conf.d/vhosts/xcited.ro.conf /usr/local/apache/conf.d/vhosts/xcited.ro.conf.disabled
```

2. Asigură-te că configurația noastră are ServerName corect:
```bash
cat /usr/local/apache/conf/conf.d/xcited.conf
```

3. Reload Apache:
```bash
/usr/local/apache/bin/httpd -k graceful
```

**NOTĂ:** Dacă dezactivezi configurația CWP, poate fi regenerată la următoarea actualizare CWP sau când modifici setările domeniului în CWP panel.
