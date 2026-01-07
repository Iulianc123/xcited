# 📊 Status Deployment xcited.ro

## ✅ Ce am făcut

1. **Push cod pe GitHub** ✓
   - Toate workflow-urile sunt pe GitHub
   - Workflow-urile folosesc `CWP_*` secrets (aceleași ca în `1dream` - același server)

2. **Configurare workflow-uri** ✓
   - `deploy-prod.yml` - deployment automat
   - `setup-env.yml` - configurare environment variables
   - Workflow-urile rulează automat la push pe `main`

3. **Îmbunătățiri** ✓
   - Adăugat creare director `/home/xcited/public_html` dacă nu există
   - Adăugat error handling mai bun
   - Adăugat verificări înainte de deploy

## ❌ Probleme identificate

1. **Workflow-urile eșuează**
   - Verifică: https://github.com/Iulianc123/xcited/actions
   - Probabil: user `xcited` nu există pe server sau directorul nu există

2. **Site-ul xcited.ro arată WordPress**
   - Site-ul răspunde dar nu este aplicația Next.js
   - Probabil: deployment-ul nu a reușit sau Apache nu este configurat corect

## 🔧 Pași pentru rezolvare

### 1. Verifică workflow runs
Mergi la: https://github.com/Iulianc123/xcited/actions
- Vezi exact ce eroare apare în workflow runs
- Verifică dacă build-ul Next.js reușește
- Verifică dacă deployment-ul pe server reușește

### 2. Setup server (dacă user-ul nu există)
Pe serverul CWP7pro, rulează:
```bash
# Creează user xcited (dacă nu există)
/usr/local/cwpsrv/htdocs/resources/scripts/createacct xcited.ro xcited xcited@example.com default 1

# Sau manual:
useradd -m -s /bin/bash xcited
mkdir -p /home/xcited/public_html
chown -R xcited:xcited /home/xcited/public_html
```

### 3. Configurează Apache reverse proxy
Pentru domeniul `xcited.ro`, configurează reverse proxy către `localhost:3001` (port diferit de wishhub care folosește 3000):
```apache
<VirtualHost *:80>
    ServerName xcited.ro
    ServerAlias www.xcited.ro
    
    ProxyPreserveHost On
    ProxyPass / http://localhost:3001/
    ProxyPassReverse / http://localhost:3001/
</VirtualHost>
```

### 4. Verifică GitHub Secrets
Asigură-te că următoarele secrets există în GitHub:
- `CWP_HOST` - același ca în `1dream` (același server)
- `CWP_USER` - același ca în `1dream` sau user separat pentru `xcited`
- `CWP_SSH_KEY` - același ca în `1dream` (aceeași cheie SSH pentru același server)
- `CWP_PORT` - același ca în `1dream` (același port SSH)
- `DATABASE_URL` - connection string PostgreSQL pentru xcited
- `NEXTAUTH_SECRET` - secret pentru NextAuth (min 32 caractere)
- `NEXTAUTH_URL` - `https://xcited.ro`
- `EMAIL_SERVER_*` - configurare email pentru NextAuth

## 📊 Verificare finală

După ce workflow-urile reușesc:
1. Verifică că site-ul răspunde: `https://xcited.ro`
2. Verifică că este aplicația Next.js (nu WordPress)
3. Verifică PM2: `pm2 list` (pe server)
4. Verifică logs: `pm2 logs xcited-web` (pe server)

## 🔗 Links utile

- GitHub Actions: https://github.com/Iulianc123/xcited/actions
- GitHub Secrets: https://github.com/Iulianc123/xcited/settings/secrets/actions
- Site: https://xcited.ro

