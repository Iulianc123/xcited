#!/bin/bash
# Quick script to push xcited to GitHub

cd "/Users/iuliancraciun/Desktop/CURSURI SI HOT TO's/CURSOR/xcited"

echo "🚀 Pushing xcited to GitHub..."
echo ""

# Check if repo exists
if git ls-remote https://github.com/Iulianc123/xcited.git &>/dev/null; then
  echo "✅ Repository exists, pushing..."
  git push -u origin main
else
  echo "❌ Repository doesn't exist yet!"
  echo ""
  echo "📋 Create it first:"
  echo "   1. Go to: https://github.com/new"
  echo "   2. Repository name: xcited"
  echo "   3. Click 'Create repository'"
  echo "   4. Then run this script again"
  echo ""
  echo "   Or create via command line if you have GitHub CLI:"
  echo "   gh repo create Iulianc123/xcited --public --source=. --remote=origin --push"
fi

