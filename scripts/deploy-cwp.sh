#!/bin/bash
# Quick deploy script for xcited to CWP7pro

set -e

echo "🚀 Deploying xcited to CWP7pro..."
echo ""

# Build locally first
echo "📦 Building application..."
npm ci
npx prisma generate
npm run build

echo "✅ Build completed!"
echo ""
echo "📋 Next steps:"
echo "   1. Push to GitHub to trigger automatic deployment"
echo "   2. Or run GitHub Actions workflow manually:"
echo "      https://github.com/YOUR_REPO/xcited/actions/workflows/deploy-prod.yml"
echo ""

