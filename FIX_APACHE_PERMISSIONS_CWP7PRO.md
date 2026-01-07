# 🔧 Fix Apache Permissions în CWP7pro (Prin Interfață Web)

## ❌ Problema: "Forbidden" Error

Când vezi eroarea **"Forbidden - You don't have permission to access this resource"**, înseamnă că Apache nu poate accesa fișierele din cauza permisiunilor incorecte.

## ✅ Soluție: Fix Permisiuni Prin CWP7pro Panel

### Metoda 1: File Manager (CEL MAI UȘOR) 🎯

1. **Loghează-te în CWP7pro Panel**
   - Mergi la `https://your-server-ip:2030` (sau domeniul tău)
   - Loghează-te cu credențialele de admin

2. **Deschide File Manager**
   - Click pe **File Manager** din meniul principal
   - Sau mergi direct la: **Files** → **File Manager**

3. **Navighează la directorul utilizatorului**
   - În File Manager, mergi la: `/home/xcited/public_html`
   - Sau click pe **Home** → **xcited** → **public_html**

4. **Selectează tot directorul `public_html`**
   - Click pe checkbox-ul din fața directorului `public_html`
   - Sau selectează toate fișierele (Ctrl+A sau Cmd+A)

5. **Schimbă Permisiunile**
   - Click dreapta pe selecție → **Change Permissions**
   - Sau click pe butonul **Permissions** din toolbar
   - Setează:
     - **Directories (Folders)**: `755`
     - **Files**: `644`
   - Bifează **Recursive** (pentru a aplica la toate subdirectoarele)
   - Click **Change Permissions**

6. **Schimbă Ownership (Dacă E Necesar)**
   - Click dreapta pe `public_html` → **Change Ownership**
   - Setează:
     - **User**: `xcited`
     - **Group**: `xcited`
   - Bifează **Recursive**
   - Click **Change Ownership**

7. **Verifică**
   - Refresh pagina
   - Verifică că permisiunile au fost schimbate corect

### Metoda 2: Terminal Web (Dacă E Disponibil)

1. **Deschide Terminal Web**
   - Mergi la **Terminal** sau **Web Terminal** în CWP7pro

2. **Rulează Comenzi**
   ```bash
   # Navighează la directorul utilizatorului
   cd /home/xcited/public_html
   
   # Schimbă ownership-ul
   chown -R xcited:xcited /home/xcited/public_html
   
   # Schimbă permisiunile pentru directoare
   find /home/xcited/public_html -type d -exec chmod 755 {} \;
   
   # Schimbă permisiunile pentru fișiere
   find /home/xcited/public_html -type f -exec chmod 644 {} \;
   
   # Verifică permisiunile
   ls -la /home/xcited/public_html
   ```

### Metoda 3: SSH (Dacă Ai Acces)

```bash
# Conectează-te la server
ssh root@your-server-ip

# Schimbă ownership-ul
chown -R xcited:xcited /home/xcited/public_html

# Schimbă permisiunile pentru directoare
find /home/xcited/public_html -type d -exec chmod 755 {} \;

# Schimbă permisiunile pentru fișiere
find /home/xcited/public_html -type f -exec chmod 644 {} \;

# Verifică
ls -la /home/xcited/public_html | head -20
```

## 🔍 Verificare După Fix

1. **Verifică Permisiunile**
   - În File Manager, verifică că:
     - Directoarele au permisiunea `755` (drwxr-xr-x)
     - Fișierele au permisiunea `644` (-rw-r--r--)

2. **Verifică Ownership**
   - Verifică că owner-ul este `xcited:xcited`

3. **Testează Site-ul**
   - Deschide `https://xcited.ro` în browser
   - Ar trebui să funcționeze fără eroarea "Forbidden"

## ⚠️ Note Importante

- **Nu schimba permisiunile la 777** (prea permisiv, risc de securitate)
- **Asigură-te că owner-ul este user-ul corect** (`xcited:xcited`)
- **După schimbarea permisiunilor, restart Apache** (dacă e necesar):
  - În CWP7pro: **WebServer Settings** → **Apache Settings** → **Restart Apache**

## 🎯 Permisiuni Corecte

```
/home/xcited/public_html/          → 755 (drwxr-xr-x) - Owner: xcited:xcited
/home/xcited/public_html/*.js     → 644 (-rw-r--r--) - Owner: xcited:xcited
/home/xcited/public_html/*.html    → 644 (-rw-r--r--) - Owner: xcited:xcited
/home/xcited/public_html/.next/    → 755 (drwxr-xr-x) - Owner: xcited:xcited
```

## ✅ Checklist

- [ ] Logat în CWP7pro Panel
- [ ] Navigat la `/home/xcited/public_html` în File Manager
- [ ] Schimbat permisiunile directoarelor la `755` (recursive)
- [ ] Schimbat permisiunile fișierelor la `644` (recursive)
- [ ] Schimbat ownership-ul la `xcited:xcited` (recursive)
- [ ] Verificat permisiunile
- [ ] Testat site-ul în browser

## 🚀 După Fix

După ce ai făcut fix-ul, site-ul ar trebui să funcționeze la `https://xcited.ro` fără eroarea "Forbidden".

Dacă problema persistă, verifică:
- Apache error logs: `/var/log/httpd/xcited_error.log`
- PM2 status: `pm2 list`
- Dacă aplicația rulează pe portul 3001: `curl http://localhost:3001`

