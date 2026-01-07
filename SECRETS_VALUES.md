# 🔐 Valori Secrete GitHub Actions pentru xcited

Acestea sunt valorile pe care trebuie să le folosești pentru secretele GitHub Actions în repository-ul `xcited`.

## 📋 Secrete CWP7pro Server

### 1. **CWP_HOST**
**Valoare:** `wishhub.org` (sau IP-ul serverului CWP7pro)

**Explicație:** 
- Același server ca pentru `1dream`
- Poate fi hostname-ul (`wishhub.org`) sau IP-ul direct al serverului
- Exemplu: `wishhub.org` sau `123.45.67.89`

**Cum să găsești:**
- Verifică în `1dream` → Settings → Secrets → `CWP_HOST` (sau `CWP_PROD_HOST`)
- Sau folosește hostname-ul serverului: `wishhub.org`

---

### 2. **CWP_USER**
**Valoare:** `root` (sau user-ul SSH configurat)

**Explicație:**
- User-ul SSH pentru conectare la server
- În `1dream` se folosește de obicei `root` sau `wishhub`
- Pentru `xcited`, poți folosi:
  - **Opțiunea A:** Același user ca în `1dream` (`root` sau `wishhub`)
  - **Opțiunea B:** User separat pentru `xcited` (dacă ai creat user `xcited` pe server)

**Recomandare:** Folosește același user ca în `1dream` pentru simplitate.

**Cum să găsești:**
- Verifică în `1dream` → Settings → Secrets → `CWP_USER` (sau `CWP_PROD_USER`)
- Sau folosește `root` dacă nu știi sigur

---

### 3. **CWP_SSH_KEY**
**Valoare:** Parola pentru autentificare SSH (NU cheia SSH privată)

**Explicație:**
- **IMPORTANT:** Acest secret conține **parola** pentru autentificare SSH, NU cheia SSH privată
- Parola pentru user-ul SSH specificat în `CWP_USER`
- Trebuie să fie aceeași parolă ca în `1dream` (același server, același user)

**Cum să obții:**
1. **Verifică în `1dream`:**
   - Mergi la: `1dream` → Settings → Secrets → `CWP_SSH_KEY` (sau `CWP_PROD_SSH_KEY`)
   - **NU** poți citi valoarea din GitHub (este criptată)
   - Trebuie să o obții de la persoana care a configurat `1dream`

2. **Dacă nu ai acces la parola din `1dream`:**
   - Contactează persoana care a configurat `1dream`
   - Sau resetează parola pentru user-ul SSH pe server

**IMPORTANT:** 
- Acesta este secretul pentru **parolă**, nu pentru cheie SSH
- Workflow-urile folosesc `password` în loc de `key` pentru autentificare
- Nu include spații sau caractere speciale care ar putea cauza probleme

---

### 4. **CWP_PORT**
**Valoare:** `22` (sau portul SSH customizat dacă există)

**Explicație:**
- Portul SSH pentru conectare
- Default: `22`
- Dacă serverul folosește un alt port SSH, folosește acela

**Cum să găsești:**
- Verifică în `1dream` → Settings → Secrets → `CWP_PORT` (sau `CWP_PROD_PORT`)
- Sau folosește `22` (default)

---

## 📝 Rezumat - Valori Recomandate

| Secret | Valoare Recomandată | Notă |
|--------|---------------------|------|
| `CWP_HOST` | `wishhub.org` | Același ca în `1dream` |
| `CWP_USER` | `root` | Sau același ca în `1dream` |
| `CWP_SSH_KEY` | Parola SSH | Aceeași parolă ca în `1dream` (NU cheia SSH) |
| `CWP_PORT` | `22` | Default SSH port |

---

## ✅ Verificare După Creare

După ce ai creat toate secretele în GitHub:

1. Mergi la: **https://github.com/Iulianc123/xcited/settings/secrets/actions**
2. Verifică că vezi toate cele 4 secrete:
   - ✅ `CWP_HOST`
   - ✅ `CWP_USER`
   - ✅ `CWP_SSH_KEY`
   - ✅ `CWP_PORT`

3. Testează workflow-ul:
   - Mergi la: **https://github.com/Iulianc123/xcited/actions**
   - Rulează manual workflow-ul "Deploy xcited to Production"
   - Verifică că nu apare eroarea "can't connect without a private SSH key"

---

## 🔍 Cum Să Găsești Valorile Din 1dream

Dacă nu știi valorile exacte, poți verifica în `1dream`:

1. Mergi la: **https://github.com/Iulianc123/1DREAM/settings/secrets/actions**
2. Vezi ce secrete există acolo
3. **IMPORTANT:** Nu poți citi valorile (sunt criptate), dar poți vedea numele secretelor
4. Dacă vezi `CWP_PROD_HOST`, `CWP_PROD_USER`, etc., acestea corespund cu:
   - `CWP_PROD_HOST` → `CWP_HOST` în `xcited`
   - `CWP_PROD_USER` → `CWP_USER` în `xcited`
   - `CWP_PROD_SSH_KEY` → `CWP_SSH_KEY` în `xcited`
   - `CWP_PROD_PORT` → `CWP_PORT` în `xcited`

---

## 🆘 Dacă Nu Ai Acces La Valorile Din 1dream

Dacă nu poți accesa valorile din `1dream`, ai două opțiuni:

### Opțiunea 1: Generează Cheie SSH Nouă
```bash
# Pe serverul CWP7pro
ssh root@wishhub.org
ssh-keygen -t rsa -b 4096 -C "github-actions-xcited"
cat ~/.ssh/id_rsa
# Copiază tot conținutul
```

Apoi folosește:
- `CWP_HOST`: `wishhub.org` (sau IP-ul serverului)
- `CWP_USER`: `root` (sau user-ul SSH)
- `CWP_SSH_KEY`: Cheia nou generată (copiată mai sus)
- `CWP_PORT`: `22`

### Opțiunea 2: Contactează Persoana Care A Configurat 1dream
Cere valorile pentru:
- Hostname/IP serverului
- User SSH
- Cheia SSH privată
- Port SSH (dacă nu e default 22)

