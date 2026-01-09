# 🔐 Creare User Admin pentru xcited

## Credențiale Admin

**Email:** `admin@xcited.ro`  
**Parolă:** `AdminXcited2026!`  
**Nume:** `Admin User`

## Pași pentru crearea user-ului admin

### 1. Asigură-te că ai DATABASE_URL configurat

Creează un fișier `.env.local` în root-ul proiectului cu:

```env
DATABASE_URL="postgresql://user:password@host:5432/database_name"
```

### 2. Generează Prisma Client și aplică migrațiile

```bash
cd "/Users/iuliancraciun/Desktop/CURSURI SI HOT TO's/CURSOR/xcited"
npx prisma generate
npx prisma db push
```

Sau dacă preferi migrații:

```bash
npx prisma migrate dev --name add_admin_and_password_fields
```

### 3. Creează user-ul admin

**Opțiunea A: Cu DATABASE_URL în .env.local**
```bash
npm run create-admin admin@xcited.ro AdminXcited2026! "Admin User"
```

**Opțiunea B: Cu DATABASE_URL ca parametru**
```bash
DATABASE_URL="postgresql://..." npx tsx scripts/create-admin-user.ts admin@xcited.ro AdminXcited2026! "Admin User"
```

**Opțiunea C: Cu DATABASE_URL ca ultim parametru**
```bash
npx tsx scripts/create-admin-user.ts admin@xcited.ro AdminXcited2026! "Admin User" "postgresql://user:pass@host:5432/db"
```

### 4. Verifică că user-ul a fost creat

Poți verifica în baza de date sau să te conectezi la `/auth` cu credențialele de mai sus.

## Funcționalități adăugate

✅ **Înregistrare cu parolă** - Utilizatorii pot crea conturi cu email și parolă  
✅ **Autentificare cu parolă** - Login cu email/parolă în loc de doar magic link  
✅ **User admin** - Câmp `isAdmin` în baza de date pentru a identifica administratorii  
✅ **Script automat** - Script pentru crearea rapidă a user-ului admin

## Securitate

⚠️ **IMPORTANT:** După prima autentificare, schimbă parola admin-ului!

## Structura bazei de date

Schema Prisma a fost actualizată cu:
- `isAdmin: Boolean @default(false)` - Identifică dacă user-ul este admin
- `password: String?` - Parola hash-uită (doar pentru users cu credentials)

## Note

- User-ii pot folosi fie magic link (email), fie parolă pentru autentificare
- Admin-ul poate fi creat doar prin script sau direct în baza de date
- Parola este hash-uită cu bcrypt (10 rounds)
