#!/bin/bash
# Script de recuperare rapidă pentru a restabili toate site-urile după un deploy problematic
# Rulează pe server: bash scripts/restore-all-sites.sh

set -e

echo "🔧 Restoring all websites on server..."

# 1. Restart PM2 pentru toate procesele
echo "📋 Restarting all PM2 processes..."
pm2 restart all || pm2 resurrect || {
    echo "⚠️  PM2 restart failed, trying to restore saved processes..."
    pm2 save
    pm2 resurrect
}

# 2. Reload Apache (nu restart - pentru a nu opri site-urile)
echo "🌐 Reloading Apache gracefully..."
if command -v httpd >/dev/null 2>&1; then
    httpd -k graceful 2>/dev/null || systemctl reload httpd 2>/dev/null || {
        echo "⚠️  Graceful reload failed, trying systemctl reload..."
        systemctl reload httpd || systemctl reload apache2 || true
    }
elif command -v apache2ctl >/dev/null 2>&1; then
    apache2ctl graceful 2>/dev/null || systemctl reload apache2 2>/dev/null || true
else
    echo "⚠️  Apache command not found"
fi

# 3. Verifică statusul PM2
echo "📊 PM2 Status:"
pm2 list

# 4. Verifică Apache
echo "🌐 Apache Status:"
systemctl status httpd 2>/dev/null || systemctl status apache2 2>/dev/null || echo "⚠️  Cannot check Apache status"

echo "✅ Recovery complete!"
