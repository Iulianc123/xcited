#!/bin/bash
# Script pentru a copia secretele din 1dream în xcited
# Folosește GitHub CLI pentru a crea secretele

set -e

REPO_1DREAM="Iulianc123/1DREAM"
REPO_XCITED="Iulianc123/xcited"

echo "🔐 Copiere secrete din $REPO_1DREAM în $REPO_XCITED"
echo ""

# Verifică dacă GitHub CLI este autentificat
if ! gh auth status &>/dev/null; then
    echo "❌ GitHub CLI nu este autentificat!"
    echo "Rulează: gh auth login"
    exit 1
fi

# Lista de secrete de copiat
SECRETS=(
    "CWP_HOST"
    "CWP_USER"
    "CWP_SSH_KEY"
    "CWP_PORT"
)

echo "📋 Secrete de copiat:"
for secret in "${SECRETS[@]}"; do
    echo "  - $secret"
done
echo ""

# Pentru fiecare secret, îl copiem din 1dream în xcited
for secret in "${SECRETS[@]}"; do
    echo "🔄 Copiere $secret..."
    
    # Obține valoarea secretului din 1dream (folosind GitHub API)
    # NOTĂ: GitHub API nu permite citirea valorilor secretelor criptate
    # Trebuie să folosim o altă metodă
    
    # Alternativă: folosim gh secret set cu valoarea directă
    # Dar nu putem citi valoarea din 1dream...
    
    echo "⚠️  Nu pot citi valoarea secretului $secret din $REPO_1DREAM (secretele sunt criptate)"
    echo "   Trebuie să adaugi manual secretul în $REPO_XCITED"
    echo ""
done

echo "✅ Script finalizat"
echo ""
echo "📝 Pentru a adăuga secretele manual:"
echo "1. Mergi la: https://github.com/$REPO_XCITED/settings/secrets/actions"
echo "2. Click 'New repository secret'"
echo "3. Adaugă fiecare secret:"
for secret in "${SECRETS[@]}"; do
    echo "   - $secret (folosește aceeași valoare ca în $REPO_1DREAM)"
done
echo ""
echo "SAU folosește GitHub CLI:"
echo "  gh secret set CWP_HOST --repo $REPO_XCITED"
echo "  gh secret set CWP_USER --repo $REPO_XCITED"
echo "  gh secret set CWP_SSH_KEY --repo $REPO_XCITED"
echo "  gh secret set CWP_PORT --repo $REPO_XCITED"

