# 🚀 Deploy xcited pe CWP7pro

## Structură Proiect

xcited este o aplicație Next.js cu:
- **Next.js 16.1.1** + TypeScript
- **Prisma** + PostgreSQL
- **NextAuth** pentru autentificare
- **Tailwind CSS** pentru styling

## Pași pentru Deploy

### 1. Configurare GitHub Secrets

Mergi la: `https://github.com/YOUR_USERNAME/xcited/settings/secrets/actions`

Adaugă următoarele secrets:

**Database:**
- `DATABASE_URL` - Connection string PostgreSQL (ex: `postgresql://user:pass@host:5432/xcited_db`)

**NextAuth:**
- `NEXTAUTH_SECRET` - Secret key (min 32 caractere)
- `NEXTAUTH_URL` - URL-ul aplicației (ex: `https://xcited.org`)

**Email (pentru NextAuth):**
- `EMAIL_SERVER_HOST` - SMTP server (ex: `smtp.gmail.com`)
- `EMAIL_SERVER_PORT` - SMTP port (ex: `587`)
- `EMAIL_SERVER_USER` - Email user
- `EMAIL_SERVER_PASSWORD` - Email password
- `EMAIL_FROM` - From address (ex: `noreply@xcited.org`)

**CWP7pro Server:**
**Folosește aceleași secrete ca în `1dream` pentru a putea folosi aceeași configurare:**
- `CWP_HOST` - IP sau hostname server (același ca în `1dream`)
- `CWP_USER` - User SSH (același ca în `1dream` sau user separat pentru `xcited`)
- `CWP_SSH_KEY` - Cheie SSH privată (aceeași ca în `1dream`)
- `CWP_PORT` - Port SSH (opțional, default: 22, același ca în `1dream`)

### 2. Setup Server (Prima Dată)

Pe serverul CWP7pro, rulează:

```bash
# Sau folosește scriptul
cd /path/to/xcited
./scripts/setup-server.sh
```

Sau manual:
1. Creează user `xcited` în CWP7pro
2. Instalează Node.js 20
3. Instalează PM2
4. Configurează Apache reverse proxy pentru `xcited.org`

### 3. Deploy Automat

**Opțiunea A: Push pe main (automat)**
```bash
git push origin main
```

**Opțiunea B: Manual prin GitHub Actions**
1. Mergi la: `https://github.com/YOUR_USERNAME/xcited/actions`
2. Selectează "Deploy xcited to Production"
3. Click "Run workflow"

### 4. Configurare Environment Variables

După primul deploy, configurează variabilele de environment:

**Opțiunea A: Prin GitHub Actions**
1. Rulează workflow-ul "Setup xcited Environment Variables"
2. Sau editează manual `.env.production` pe server

**Opțiunea B: Manual pe server**
```bash
ssh user@xcited.org
cd /home/xcited/public_html
nano .env.production
# Adaugă toate variabilele necesare
pm2 restart xcited-web
```

### 5. Configurare Apache Reverse Proxy

Creează virtual host în Apache:

```apache
<VirtualHost *:80>
    ServerName xcited.org
    ServerAlias www.xcited.org
    
    ProxyPreserveHost On
    ProxyPass / http://localhost:3001/
    ProxyPassReverse / http://localhost:3001/
    
    ErrorLog /var/log/httpd/xcited_error.log
    CustomLog /var/log/httpd/xcited_access.log combined
</VirtualHost>
```

Apoi:
```bash
systemctl restart httpd
```

### 6. Setup Database

Pe server, rulează migrațiile Prisma:

```bash
cd /home/xcited/public_html
npx prisma migrate deploy
# sau
npx prisma db push
```

## Verificare

După deploy:
1. Verifică că aplicația rulează: `pm2 list`
2. Verifică log-uri: `pm2 logs xcited-web`
3. Accesează: `https://xcited.org`

## Troubleshooting

### Eroare: "DATABASE_URL is not set"
- Verifică că `.env.production` există pe server
- Verifică că variabilele sunt setate corect

### Eroare: "Prisma Client not generated"
- Rulează: `npx prisma generate` pe server
- Sau rebuild aplicația

### Aplicația nu pornește
- Verifică log-uri: `pm2 logs xcited-web`
- Verifică port: `netstat -tlnp | grep 3001`
- Verifică PM2: `pm2 list`

## Workflow-uri Disponibile

1. **deploy-prod.yml** - Deploy automat la push pe main
2. **setup-env.yml** - Configurare variabile de environment

## Structură Server

```
/home/xcited/public_html/
├── .next/              # Next.js build
├── public/             # Static files
├── prisma/             # Prisma schema
├── node_modules/       # Dependencies
├── .env.production     # Environment variables
├── ecosystem.config.js # PM2 config
└── package.json
```

