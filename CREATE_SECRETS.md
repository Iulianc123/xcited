# 🔐 Creare Secrete GitHub Actions pentru xcited

## Problema

Nu pot citi valorile secretelor din `1dream` pentru că sunt criptate în GitHub. Trebuie să le creez manual sau să folosesc GitHub CLI/API.

## ⚠️ Limitare GitHub

GitHub **nu permite citirea valorilor secretelor** criptate din API. Prin urmare, nu pot copia automat valorile secretelor din `1dream` în `xcited` fără a avea acces la valorile originale.

## Soluție 1: Script interactiv cu GitHub CLI (Recomandat)

Acest script verifică dacă secretele există în `1dream` și te ajută să le copiezi în `xcited`:

```bash
cd "/Users/iuliancraciun/Desktop/CURSURI SI HOT TO's/CURSOR/xcited"
gh auth login  # Dacă nu ești autentificat
./scripts/copy-secrets-api.sh
```

Scriptul va:
1. Verifica dacă secretele există în `1dream`
2. Te va întreba să introduci valoarea pentru fiecare secret
3. Va crea secretul în `xcited` folosind GitHub CLI

## Soluție 2: Folosind GitHub CLI direct

### Pasul 1: Autentifică GitHub CLI

```bash
gh auth login
```

### Pasul 2: Rulează scriptul interactiv

```bash
cd "/Users/iuliancraciun/Desktop/CURSURI SI HOT TO's/CURSOR/xcited"
./scripts/create-secrets-gh.sh
```

Scriptul va cere valorile pentru fiecare secret:
- `CWP_HOST` - aceeași valoare ca în `1dream`
- `CWP_USER` - aceeași valoare ca în `1dream`
- `CWP_SSH_KEY` - aceeași valoare ca în `1dream`
- `CWP_PORT` - aceeași valoare ca în `1dream`

## Soluție 3: Manual prin GitHub Web UI

1. Mergi la: **https://github.com/Iulianc123/xcited/settings/secrets/actions**
2. Click **"New repository secret"** pentru fiecare secret
3. Adaugă valorile (aceleași ca în `1dream`):
   - `CWP_HOST`
   - `CWP_USER`
   - `CWP_SSH_KEY`
   - `CWP_PORT`

## Soluție 4: Folosind GitHub CLI direct (dacă ai valorile)

```bash
# Autentifică-te
gh auth login

# Creează fiecare secret
echo "VALOARE_CWP_HOST" | gh secret set CWP_HOST --repo Iulianc123/xcited
echo "VALOARE_CWP_USER" | gh secret set CWP_USER --repo Iulianc123/xcited
echo "VALOARE_CWP_SSH_KEY" | gh secret set CWP_SSH_KEY --repo Iulianc123/xcited
echo "VALOARE_CWP_PORT" | gh secret set CWP_PORT --repo Iulianc123/xcited
```

## Verificare

După crearea secretelor, verifică:

```bash
gh secret list --repo Iulianc123/xcited
```

Sau mergi la: **https://github.com/Iulianc123/xcited/settings/secrets/actions**

Ar trebui să vezi toate cele 4 secrete:
- ✅ CWP_HOST
- ✅ CWP_USER
- ✅ CWP_SSH_KEY
- ✅ CWP_PORT

## Notă Importantă

Valorile secretelor trebuie să fie **identice** cu cele din `1dream` pentru că folosesc același server CWP7pro.

