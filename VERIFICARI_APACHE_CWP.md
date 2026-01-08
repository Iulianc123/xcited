# Verificări Apache CWP7pro - Problema "Forbidden"

## Problema Identificată:
Apache returnează pagina de test CWP în loc de aplicația Next.js, ceea ce înseamnă că configurația `/etc/httpd/conf.d/xcited.conf` nu este folosită sau este suprascrisă.

## Verificări Necesare (rulează pe server):

### 1. Găsește log-urile reale Apache (CWP7pro folosește altă locație):
```bash
# Găsește log-urile
find /usr/local/apache -name "*error*" -o -name "*access*" 2>/dev/null
ls -la /usr/local/apache/logs/
tail -50 /usr/local/apache/logs/error_log
tail -50 /usr/local/apache/logs/access_log
```

### 2. Verifică unde sunt configurațiile Apache reale:
```bash
# Verifică configurația principală Apache
cat /usr/local/apache/conf/httpd.conf | grep -E "Include|conf.d" | head -20

# Verifică dacă există un director conf.d în locația Apache
ls -la /usr/local/apache/conf/conf.d/ 2>/dev/null
ls -la /usr/local/apache/conf.d/ 2>/dev/null

# Verifică dacă configurația noastră este inclusă
grep -r "xcited" /usr/local/apache/conf/ 2>/dev/null
```

### 3. Verifică dacă modulul proxy este activat:
```bash
/usr/local/apache/bin/httpd -M | grep proxy
# Trebuie să vezi: proxy_module, proxy_http_module
```

### 4. Verifică configurația VirtualHost pentru xcited.ro:
```bash
# Caută toate configurațiile care menționează xcited.ro
grep -r "xcited.ro" /usr/local/apache/conf/ 2>/dev/null
grep -r "xcited.ro" /etc/httpd/ 2>/dev/null

# Verifică dacă există configurații CWP pentru xcited.ro
find /usr/local/cwpsrv -name "*xcited*" 2>/dev/null
```

### 5. Verifică configurația CWP pentru domeniu:
```bash
# CWP7pro poate avea configurații în altă locație
ls -la /usr/local/apache/conf/conf.d/ 2>/dev/null
cat /usr/local/apache/conf/conf.d/vhost.conf 2>/dev/null | grep -A 20 "xcited.ro"
```

### 6. Testează configurația Apache:
```bash
# Testează sintaxa configurației
/usr/local/apache/bin/httpd -t

# Verifică ce VirtualHost-uri sunt încărcate
/usr/local/apache/bin/httpd -S
```

### 7. Verifică dacă configurația noastră este inclusă:
```bash
# Copiază configurația în locația corectă Apache
cp /etc/httpd/conf.d/xcited.conf /usr/local/apache/conf/conf.d/xcited.conf

# Sau verifică dacă trebuie să fie în altă locație
ls -la /usr/local/apache/conf/conf.d/
```

### 8. Reload Apache după modificări:
```bash
# Reload Apache
/usr/local/apache/bin/httpd -k graceful
# sau
systemctl reload httpd
# sau prin CWP panel
```

## Soluție Probabilă:

CWP7pro folosește `/usr/local/apache/conf/` în loc de `/etc/httpd/conf.d/`.

**Pași:**
1. Copiază configurația în locația corectă:
```bash
cp /etc/httpd/conf.d/xcited.conf /usr/local/apache/conf/conf.d/xcited.conf
```

2. Verifică sintaxa:
```bash
/usr/local/apache/bin/httpd -t
```

3. Reload Apache:
```bash
/usr/local/apache/bin/httpd -k graceful
```

4. Testează din nou:
```bash
curl -v -H "Host: xcited.ro" http://127.0.0.1/ 2>&1 | head -30
```

## Verificare Finală:

După ce copiezi configurația, verifică:
```bash
# 1. Verifică dacă configurația este încărcată
/usr/local/apache/bin/httpd -S | grep xcited

# 2. Verifică log-urile pentru erori
tail -f /usr/local/apache/logs/error_log

# 3. Testează accesul
curl -v http://xcited.ro/ 2>&1 | head -20
```
