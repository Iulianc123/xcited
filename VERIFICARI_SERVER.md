# Verificări Server pentru Eroarea "Forbidden"

## 1. Verifică Configurația Apache

```bash
# Verifică dacă fișierul de configurare există
cat /etc/httpd/conf.d/xcited.conf

# Verifică sintaxa configurației Apache
/usr/sbin/httpd -t
# sau
/usr/local/apache/bin/httpd -t

# Verifică dacă modulul proxy este activat
/usr/sbin/httpd -M | grep proxy
# Trebuie să vezi: proxy_module, proxy_http_module
```

**Ce să cauți:**
- `ProxyPass / http://127.0.0.1:3002/` trebuie să fie **ÎNAINTE** de `<Directory>`
- `Require all granted` în `<Directory>`
- `ProxyPreserveHost On`

---

## 2. Verifică dacă Aplicația Rulează pe Portul 3002

```bash
# Verifică dacă portul 3002 ascultă
ss -ltnp | grep :3002
# sau
netstat -tlnp | grep :3002

# Testează dacă aplicația răspunde local
curl -v http://127.0.0.1:3002
curl -v http://localhost:3002

# Verifică PM2 status
pm2 list
pm2 describe xcited-web
pm2 logs xcited-web --lines 50
```

**Ce să cauți:**
- Portul 3002 trebuie să fie în `LISTEN`
- `curl` trebuie să returneze HTTP 200, nu "Connection refused"

---

## 3. Verifică Permisiunile Fișierelor

```bash
# Verifică ownership și permisiuni pentru directorul principal
ls -ld /home/xcited/public_html
ls -ld /home/xcited/public_html/deploy-package

# Verifică permisiuni pentru toate fișierele
ls -la /home/xcited/public_html/deploy-package | head -20

# Verifică dacă există fișiere cu ownership greșit
find /home/xcited/public_html -not -user xcited -o -not -group xcited | head -20

# Verifică permisiuni pentru server.js
ls -l /home/xcited/public_html/deploy-package/server.js
```

**Ce să cauți:**
- Ownership: `xcited:xcited` (sau userul corect)
- Directoare: `drwxr-xr-x` (755)
- Fișiere: `-rw-r--r--` (644)
- `server.js`: trebuie să fie executabil (`-rwxr-xr-x` sau 755)

---

## 4. Verifică Log-urile Apache

```bash
# Verifică log-urile de eroare
tail -50 /var/log/httpd/xcited_error.log
# sau
tail -50 /var/log/httpd/error_log

# Verifică log-urile de acces
tail -50 /var/log/httpd/xcited_access.log
# sau
tail -50 /var/log/httpd/access_log

# Caută erori specifice
grep -i "forbidden" /var/log/httpd/xcited_error.log
grep -i "permission denied" /var/log/httpd/xcited_error.log
grep -i "proxy" /var/log/httpd/xcited_error.log
```

**Ce să cauți:**
- Erori "Permission denied"
- Erori "Forbidden"
- Erori de proxy (connection refused, timeout)
- Mesaje despre modulul proxy

---

## 5. Verifică SELinux (dacă e activ)

```bash
# Verifică statusul SELinux
getenforce
# Dacă returnează "Enforcing", SELinux este activ

# Verifică contextul SELinux pentru fișiere
ls -Z /home/xcited/public_html/deploy-package | head -10

# Verifică dacă Apache poate face conexiuni de rețea
getsebool -a | grep httpd
# Caută: httpd_can_network_connect --> on
```

**Ce să cauți:**
- Dacă SELinux este "Enforcing", trebuie:
  - `httpd_can_network_connect` = `on` (pentru proxy)
  - Context: `httpd_sys_content_t` pentru fișiere

**Dacă SELinux e activ și `httpd_can_network_connect` e `off`:**
```bash
setsebool -P httpd_can_network_connect on
```

---

## 6. Verifică dacă Apache Poate Accesa Portul 3002

```bash
# Testează ca userul Apache
sudo -u apache curl -v http://127.0.0.1:3002
# sau
sudo -u www-data curl -v http://127.0.0.1:3002

# Verifică ce user rulează Apache
ps aux | grep httpd | head -5
```

**Ce să cauți:**
- Dacă `curl` ca user Apache funcționează, înseamnă că Apache poate accesa portul
- Dacă nu funcționează, poate fi o problemă de firewall sau permisiuni

---

## 7. Verifică Firewall (iptables/firewalld)

```bash
# Verifică iptables
iptables -L -n | grep 3002

# Verifică firewalld
firewall-cmd --list-all | grep 3002

# Verifică dacă localhost poate accesa portul 3002
telnet 127.0.0.1 3002
```

**Ce să cauți:**
- Nu ar trebui să fie reguli care blochează localhost:3002
- `telnet` ar trebui să se conecteze

---

## 8. Verifică Configurația VirtualHost

```bash
# Verifică dacă există alte VirtualHost-uri care ar putea intra în conflict
grep -r "xcited.ro" /etc/httpd/conf.d/
grep -r "ServerName xcited.ro" /etc/httpd/

# Verifică ordinea de încărcare a configurațiilor
ls -la /etc/httpd/conf.d/ | grep xcited
```

**Ce să cauți:**
- Doar un VirtualHost pentru `xcited.ro`
- Nu ar trebui să fie conflicte cu alte configurații

---

## 9. Test Direct Apache Proxy

```bash
# Testează configurația Apache cu verbose
/usr/sbin/httpd -S
# sau
/usr/local/apache/bin/httpd -S

# Verifică dacă Apache rulează
systemctl status httpd
# sau
ps aux | grep httpd
```

---

## 10. Verificări Rapide - Comandă Unică

```bash
# Rulează toate verificările de bază într-o singură comandă
echo "=== Apache Config ===" && \
cat /etc/httpd/conf.d/xcited.conf && \
echo -e "\n=== Apache Syntax ===" && \
/usr/sbin/httpd -t 2>&1 && \
echo -e "\n=== Port 3002 ===" && \
ss -ltnp | grep :3002 && \
echo -e "\n=== PM2 Status ===" && \
pm2 list && \
echo -e "\n=== Permissions ===" && \
ls -ld /home/xcited/public_html/deploy-package && \
echo -e "\n=== Test Local ===" && \
curl -I http://127.0.0.1:3002 2>&1 | head -5 && \
echo -e "\n=== Apache Error Log (last 10) ===" && \
tail -10 /var/log/httpd/xcited_error.log 2>&1
```

---

## Probleme Comune și Soluții

### Problema 1: Apache nu face proxy, servește fișiere statice
**Soluție:** Mută `ProxyPass` înainte de `<Directory>` în configurație

### Problema 2: Permission denied în log-uri
**Soluție:** 
```bash
chown -R xcited:xcited /home/xcited/public_html
find /home/xcited/public_html -type d -exec chmod 755 {} \;
find /home/xcited/public_html -type f -exec chmod 644 {} \;
```

### Problema 3: SELinux blochează proxy
**Soluție:**
```bash
setsebool -P httpd_can_network_connect on
chcon -R -t httpd_sys_content_t /home/xcited/public_html
```

### Problema 4: Aplicația nu rulează pe 3002
**Soluție:** Verifică PM2 și pornește aplicația:
```bash
pm2 restart xcited-web
pm2 logs xcited-web
```

### Problema 5: Modulul proxy nu e activat
**Soluție:**
```bash
# Verifică dacă modulul e încărcat
/usr/sbin/httpd -M | grep proxy

# Dacă nu e, activează-l (depinde de sistem)
# Pentru CWP7pro, de obicei e deja activat
```

---

## După Verificări

După ce rulezi aceste verificări, trimite rezultatele pentru:
1. `cat /etc/httpd/conf.d/xcited.conf`
2. `ss -ltnp | grep :3002`
3. `tail -20 /var/log/httpd/xcited_error.log`
4. `ls -ld /home/xcited/public_html/deploy-package`
5. `curl -v http://127.0.0.1:3002` (primele 10 linii)

Acestea vor ajuta la identificarea exactă a problemei.
