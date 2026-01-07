#!/bin/bash
# Script pentru a rula workflow-urile GitHub Actions pentru xcited

set -e

REPO="Iulianc123/xcited"
WORKFLOW_SETUP="setup-server.yml"
WORKFLOW_DEPLOY="deploy-prod.yml"

echo "🚀 Rulare workflow-uri GitHub Actions pentru xcited"
echo ""

# Verifică dacă GitHub CLI este autentificat
if ! gh auth status &>/dev/null; then
    echo "❌ GitHub CLI nu este autentificat!"
    echo ""
    echo "📝 Opțiuni:"
    echo "   1. Autentifică GitHub CLI:"
    echo "      gh auth login"
    echo ""
    echo "   2. Sau setează token-ul:"
    echo "      export GH_TOKEN=your_token_here"
    echo ""
    echo "   3. Sau rulează manual workflow-urile:"
    echo "      https://github.com/$REPO/actions"
    exit 1
fi

echo "✅ GitHub CLI autentificat"
echo ""

# Rulează workflow-ul de setup server
echo "🔧 Rulare: Setup xcited Server (CWP7pro)..."
echo "   Workflow: $WORKFLOW_SETUP"
gh workflow run "$WORKFLOW_SETUP" --repo "$REPO"

if [ $? -eq 0 ]; then
    echo "   ✅ Workflow trimis pentru rulare"
    echo "   ⏳ Aștept 10 secunde pentru a începe..."
    sleep 10
    
    # Obține ID-ul ultimului run
    RUN_ID=$(gh run list --workflow="$WORKFLOW_SETUP" --repo "$REPO" --limit 1 --json databaseId --jq '.[0].databaseId')
    
    if [ -n "$RUN_ID" ]; then
        echo "   📊 Run ID: $RUN_ID"
        echo "   🔗 Vezi progresul: https://github.com/$REPO/actions/runs/$RUN_ID"
        echo ""
        echo "   ⏳ Aștept finalizarea workflow-ului..."
        gh run watch "$RUN_ID" --repo "$REPO" || echo "   ⚠️  Workflow încă rulează sau a eșuat"
    fi
else
    echo "   ❌ Eroare la rularea workflow-ului"
    exit 1
fi

echo ""
echo "✅ Setup server workflow finalizat"
echo ""

# Așteaptă confirmarea utilizatorului sau continuă automat după 5 secunde
echo "⏳ Aștept 5 secunde înainte de deploy..."
sleep 5

# Rulează workflow-ul de deploy
echo "🚀 Rulare: Deploy xcited to Production..."
echo "   Workflow: $WORKFLOW_DEPLOY"
gh workflow run "$WORKFLOW_DEPLOY" --repo "$REPO"

if [ $? -eq 0 ]; then
    echo "   ✅ Workflow trimis pentru rulare"
    echo "   ⏳ Aștept 10 secunde pentru a începe..."
    sleep 10
    
    # Obține ID-ul ultimului run
    RUN_ID=$(gh run list --workflow="$WORKFLOW_DEPLOY" --repo "$REPO" --limit 1 --json databaseId --jq '.[0].databaseId')
    
    if [ -n "$RUN_ID" ]; then
        echo "   📊 Run ID: $RUN_ID"
        echo "   🔗 Vezi progresul: https://github.com/$REPO/actions/runs/$RUN_ID"
        echo ""
        echo "   ⏳ Aștept finalizarea workflow-ului..."
        gh run watch "$RUN_ID" --repo "$REPO" || echo "   ⚠️  Workflow încă rulează sau a eșuat"
    fi
else
    echo "   ❌ Eroare la rularea workflow-ului"
    exit 1
fi

echo ""
echo "✅ Deploy workflow finalizat"
echo ""
echo "🎉 Toate workflow-urile au fost rulate!"
echo ""
echo "🔍 Verificare:"
echo "   - Site: https://xcited.ro"
echo "   - GitHub Actions: https://github.com/$REPO/actions"

