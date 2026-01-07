# 🔐 Configurare GitHub Secrets pentru xcited

## 📋 Secrets Necesare

Mergi la: **https://github.com/Iulianc123/xcited/settings/secrets/actions**

Click pe **"New repository secret"** pentru fiecare secret.

### 🗄️ Database
- **`DATABASE_URL`** - Connection string PostgreSQL
  - Format: `postgresql://user:password@host:5432/database_name`
  - Exemplu: `postgresql://xcited_user:password123@db.xcited.org:5432/xcited_db`

### 🔐 NextAuth
- **`NEXTAUTH_SECRET`** - Secret key pentru NextAuth (min 32 caractere)
  - Generează cu: `openssl rand -base64 32`
  - Sau: `node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"`
  
- **`NEXTAUTH_URL`** - URL-ul aplicației
  - Exemplu: `https://xcited.org` sau `https://www.xcited.org`

### 📧 Email (pentru NextAuth)
- **`EMAIL_SERVER_HOST`** - SMTP server
  - Exemplu: `smtp.gmail.com`, `smtp.sendgrid.net`, etc.
  
- **`EMAIL_SERVER_PORT`** - SMTP port
  - Exemplu: `587` (TLS) sau `465` (SSL)
  
- **`EMAIL_SERVER_USER`** - Email user pentru SMTP
  - Exemplu: `noreply@xcited.org`
  
- **`EMAIL_SERVER_PASSWORD`** - Parola pentru SMTP
  
- **`EMAIL_FROM`** - From address
  - Exemplu: `noreply@xcited.org`

### 🖥️ CWP7pro Server
**Folosește aceleași secrete ca în `1dream` pentru a putea folosi aceeași configurare:**

- **`CWP_HOST`** - IP sau hostname serverului
  - Exemplu: `xcited.org` sau `123.45.67.89`
  - **NOTĂ**: Folosește aceeași valoare ca în `1dream` (același server)
  
- **`CWP_USER`** - User SSH
  - Exemplu: `xcited` sau `root`
  - **NOTĂ**: Poate fi același user ca în `1dream` sau un user separat pentru `xcited`
  
- **`CWP_SSH_KEY`** - Cheia SSH privată
  - **NOTĂ**: Folosește aceeași cheie SSH ca în `1dream` (aceeași cheie pentru același server)
  - Sau generează una nouă pe server: `ssh-keygen -t rsa -b 4096 -C "github-actions-xcited"`
  - Copiază conținutul: `cat ~/.ssh/id_rsa`
  
- **`CWP_PORT`** - Port SSH (opțional, default: 22)
  - Exemplu: `22`
  - **NOTĂ**: Folosește aceeași valoare ca în `1dream` (același port SSH)

## 🚀 Pași de Setup

### 1. Setup Server (Prima Dată)

Pe serverul CWP7pro:

```bash
# Creează user xcited (dacă nu există)
useradd -m -s /bin/bash xcited

# Instalează Node.js 20
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
yum install -y nodejs

# Instalează PM2
npm install -g pm2

# Configurează PM2 să pornească la boot
pm2 startup
pm2 save

# Creează directorul
mkdir -p /home/xcited/public_html
chown -R xcited:xcited /home/xcited/public_html
```

### 2. Configurează Apache Reverse Proxy

În CWP7pro, pentru domeniul `xcited.org`, configurează reverse proxy:

```apache
<VirtualHost *:80>
    ServerName xcited.org
    ServerAlias www.xcited.org
    
    ProxyPreserveHost On
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/
</VirtualHost>
```

### 3. Adaugă Secrets în GitHub

Folosește lista de mai sus pentru a adăuga toate secrets-urile.

### 4. Rulează Setup Environment

1. Mergi la: **https://github.com/Iulianc123/xcited/actions**
2. Selectează **"Setup xcited Environment Variables"**
3. Click **"Run workflow"**

### 5. Deploy Aplicația

1. Mergi la: **https://github.com/Iulianc123/xcited/actions**
2. Selectează **"Deploy xcited to Production"**
3. Click **"Run workflow"**

SAU

```bash
git push origin main
```

## ✅ Verificare

După deploy, verifică:

1. **Aplicația rulează**: `https://xcited.org`
2. **PM2 status**: `pm2 list` (pe server)
3. **Logs**: `pm2 logs xcited-web` (pe server)

## 🔧 Troubleshooting

### Aplicația nu pornește
```bash
# Pe server
cd /home/xcited/public_html
pm2 logs xcited-web
pm2 restart xcited-web
```

### Eroare Prisma
```bash
# Pe server
cd /home/xcited/public_html
npx prisma generate
npx prisma migrate deploy
```

### Eroare Database Connection
- Verifică `DATABASE_URL` în `.env.production`
- Verifică că PostgreSQL acceptă conexiuni de la server

