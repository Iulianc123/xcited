#!/bin/bash
# Script pentru a crea secretele GitHub Actions în xcited folosind GitHub CLI
# Folosește aceleași valori ca în 1dream

set -e

REPO_XCITED="Iulianc123/xcited"
REPO_1DREAM="Iulianc123/1DREAM"

echo "🔐 Creare secrete în $REPO_XCITED"
echo "   (folosind aceleași valori ca în $REPO_1DREAM)"
echo ""

# Verifică dacă GitHub CLI este autentificat
if ! gh auth status &>/dev/null; then
    echo "❌ GitHub CLI nu este autentificat!"
    echo "Rulează: gh auth login"
    exit 1
fi

# Lista de secrete de creat
SECRETS=(
    "CWP_HOST"
    "CWP_USER"
    "CWP_SSH_KEY"
    "CWP_PORT"
)

echo "📋 Secrete de creat:"
for secret in "${SECRETS[@]}"; do
    echo "  - $secret"
done
echo ""

# Pentru fiecare secret, cere valoarea și o creează
for secret in "${SECRETS[@]}"; do
    echo "📝 Secret: $secret"
    echo "   Valoarea trebuie să fie aceeași ca în $REPO_1DREAM"
    echo -n "   Introdu valoarea pentru $secret (sau Enter pentru a sări): "
    read -r secret_value
    
    if [ -z "$secret_value" ]; then
        echo "   ⚠️  Sărit $secret (valoare goală)"
        echo ""
        continue
    fi
    
    # Creează secretul folosind GitHub CLI
    echo "$secret_value" | gh secret set "$secret" --repo "$REPO_XCITED"
    
    if [ $? -eq 0 ]; then
        echo "   ✅ Secret $secret creat cu succes!"
    else
        echo "   ❌ Eroare la crearea secretului $secret"
    fi
    echo ""
done

echo "✅ Finalizat!"
echo ""
echo "🔍 Verificare:"
echo "   Mergi la: https://github.com/$REPO_XCITED/settings/secrets/actions"
echo "   Ar trebui să vezi toate secretele create mai sus"

