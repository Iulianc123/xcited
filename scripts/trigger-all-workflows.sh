#!/bin/bash
# Script pentru a declanșa toate workflow-urile necesare pentru xcited

set -e

echo "🚀 Declanșare workflow-uri pentru xcited..."
echo ""

# 1. Trigger Setup Server workflow
echo "🔧 1. Declanșare: Setup xcited Server (CWP7pro)..."
touch .github/TRIGGER_SETUP_SERVER
git add .github/TRIGGER_SETUP_SERVER
git commit -m "chore: trigger server setup workflow" || echo "No changes to commit"

echo "   ✅ Trigger file created"
echo ""

# 2. Push to trigger workflow
echo "📤 Push to GitHub pentru a declanșa workflow-urile..."
git push origin main

echo ""
echo "✅ Workflow-uri declanșate!"
echo ""
echo "📊 Vezi progresul la: https://github.com/Iulianc123/xcited/actions"
echo ""
echo "⏳ Workflow-urile vor rula automat:"
echo "   1. Setup xcited Server (CWP7pro) - configurează serverul"
echo "   2. După setup, rulează manual: Deploy xcited to Production"
echo ""
echo "💡 După ce setup-ul se termină, rulează manual:"
echo "   https://github.com/Iulianc123/xcited/actions/workflows/deploy-prod.yml"
echo ""

