#!/bin/bash
# Script pentru a copia secretele din 1dream în xcited folosind GitHub API
# NOTĂ: GitHub nu permite citirea valorilor secretelor criptate
# Acest script încearcă să le copieze folosind GitHub API, dar necesită valorile

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

# Obține token-ul GitHub
GITHUB_TOKEN=$(gh auth token)
if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Nu am putut obține token-ul GitHub!"
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

# Pentru fiecare secret, încearcă să-l copieze
for secret in "${SECRETS[@]}"; do
    echo "🔄 Procesare $secret..."
    
    # Verifică dacă secretul există în 1dream
    if gh secret list --repo "$REPO_1DREAM" | grep -q "^$secret"; then
        echo "   ✅ Secret $secret există în $REPO_1DREAM"
        
        # Încearcă să obțină valoarea secretului
        # NOTĂ: GitHub API nu permite citirea valorilor secretelor criptate
        # Trebuie să folosim o altă metodă
        
        echo "   ⚠️  Nu pot citi valoarea secretului (secretele sunt criptate în GitHub)"
        echo "   💡 Soluție: Trebuie să introduci manual valoarea pentru $secret"
        echo ""
        
        # Cere valoarea de la utilizator
        echo -n "   Introdu valoarea pentru $secret (sau Enter pentru a sări): "
        read -r secret_value
        
        if [ -z "$secret_value" ]; then
            echo "   ⚠️  Sărit $secret (valoare goală)"
            echo ""
            continue
        fi
        
        # Creează secretul în xcited folosind GitHub CLI
        echo "$secret_value" | gh secret set "$secret" --repo "$REPO_XCITED"
        
        if [ $? -eq 0 ]; then
            echo "   ✅ Secret $secret copiat cu succes în $REPO_XCITED!"
        else
            echo "   ❌ Eroare la copierea secretului $secret"
        fi
    else
        echo "   ⚠️  Secret $secret nu există în $REPO_1DREAM"
    fi
    echo ""
done

echo "✅ Finalizat!"
echo ""
echo "🔍 Verificare:"
gh secret list --repo "$REPO_XCITED"

