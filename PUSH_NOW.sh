#!/bin/bash
# Script pentru push imediat după ce repo-ul este creat

cd "/Users/iuliancraciun/Desktop/CURSURI SI HOT TO's/CURSOR/xcited"

echo "🚀 Pushing xcited to GitHub..."
echo ""

# Try to push
if git push -u origin main 2>&1; then
  echo ""
  echo "✅ Successfully pushed to GitHub!"
  echo "📊 Repository: https://github.com/Iulianc123/xcited"
  echo "🔧 Workflows: https://github.com/Iulianc123/xcited/actions"
else
  echo ""
  echo "❌ Push failed. Repository might not exist yet."
  echo ""
  echo "📋 Create repository first:"
  echo "   1. Go to: https://github.com/new"
  echo "   2. Repository name: xcited"
  echo "   3. Description: xcited - Dating/Connection Platform"
  echo "   4. Public"
  echo "   5. DO NOT initialize with README, .gitignore, or license"
  echo "   6. Click 'Create repository'"
  echo ""
  echo "   7. Then run this script again: ./PUSH_NOW.sh"
fi

