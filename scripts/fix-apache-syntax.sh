#!/bin/bash
# Script pentru a corecta eroarea de sintaxă Apache cauzată de workflow
# Rulează pe server: bash scripts/fix-apache-syntax.sh

set -e

CWP_VHOST="/usr/local/apache/conf.d/vhosts/xcited.ro.conf"

echo "🔧 Fixing Apache syntax error in $CWP_VHOST..."

if [ ! -f "$CWP_VHOST" ]; then
    echo "❌ VirtualHost file not found: $CWP_VHOST"
    exit 1
fi

# Backup
BACKUP="${CWP_VHOST}.backup.$(date +%s)"
cp "$CWP_VHOST" "$BACKUP"
echo "✅ Backup created: $BACKUP"

# Remove all incorrect IfModule blocks that might be malformed
echo "🧹 Cleaning up malformed IfModule blocks..."
sed -i '/<IfModule mod_security2.c>/d' "$CWP_VHOST"
sed -i '/SecRuleEngine Off/d' "$CWP_VHOST"
sed -i '/<\/IfModule>/d' "$CWP_VHOST"
sed -i '/ModSecurityEnabled/d' "$CWP_VHOST"

# Find first VirtualHost start
FIRST_VHOST_START=$(grep -n "^<VirtualHost" "$CWP_VHOST" | head -1 | cut -d: -f1)

if [ -z "$FIRST_VHOST_START" ]; then
    echo "❌ Could not find VirtualHost start"
    exit 1
fi

# Add correct IfModule block using a temporary file
TEMP_FILE=$(mktemp)
head -n $FIRST_VHOST_START "$CWP_VHOST" > "$TEMP_FILE"
echo -e "\t<IfModule mod_security2.c>" >> "$TEMP_FILE"
echo -e "\t\tSecRuleEngine Off" >> "$TEMP_FILE"
echo -e "\t</IfModule>" >> "$TEMP_FILE"
tail -n +$((FIRST_VHOST_START + 1)) "$CWP_VHOST" >> "$TEMP_FILE"

mv "$TEMP_FILE" "$CWP_VHOST"

echo "✅ Fixed IfModule block syntax"

# Test Apache configuration
echo "🔍 Testing Apache configuration..."
if /usr/local/apache/bin/httpd -t 2>&1; then
    echo "✅ Apache configuration is valid!"
    echo "🔄 Reloading Apache gracefully..."
    /usr/local/apache/bin/httpd -k graceful
    echo "✅ Apache reloaded successfully!"
else
    echo "❌ Apache configuration still has errors!"
    echo "📋 Showing last 20 lines of config:"
    tail -20 "$CWP_VHOST"
    exit 1
fi

echo "✅ Apache syntax fixed and reloaded!"
