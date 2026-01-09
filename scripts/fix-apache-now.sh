#!/bin/bash
# Script URGENT pentru a corecta eroarea Apache și a reporni serverul
# Rulează pe server: bash scripts/fix-apache-now.sh

set -e

CWP_VHOST="/usr/local/apache/conf.d/vhosts/xcited.ro.conf"

echo "🚨 URGENT: Fixing Apache syntax error..."

if [ ! -f "$CWP_VHOST" ]; then
    echo "❌ VirtualHost file not found: $CWP_VHOST"
    exit 1
fi

# Backup
BACKUP="${CWP_VHOST}.backup.$(date +%s)"
cp "$CWP_VHOST" "$BACKUP"
echo "✅ Backup created: $BACKUP"

# Show current problematic lines around line 60
echo "📋 Showing lines around line 60 (where error occurs):"
sed -n '55,65p' "$CWP_VHOST" | cat -n

# Remove ALL IfModule blocks that might be malformed
echo "🧹 Removing all malformed IfModule blocks..."
sed -i '/<IfModule mod_security2.c>/d' "$CWP_VHOST"
sed -i '/<IfModule mod_security2>/d' "$CWP_VHOST"
sed -i '/SecRuleEngine Off/d' "$CWP_VHOST"
sed -i '/SecRuleEngine On/d' "$CWP_VHOST"
sed -i '/<\/IfModule>/d' "$CWP_VHOST"
sed -i '/ModSecurityEnabled/d' "$CWP_VHOST"

# Also remove any incomplete IfModule tags
sed -i '/IfModule.*mod_security/d' "$CWP_VHOST"

# Find first VirtualHost start
FIRST_VHOST_START=$(grep -n "^<VirtualHost" "$CWP_VHOST" | head -1 | cut -d: -f1)

if [ -z "$FIRST_VHOST_START" ]; then
    echo "❌ Could not find VirtualHost start"
    exit 1
fi

echo "✅ Found VirtualHost at line $FIRST_VHOST_START"

# Check if we need to add ModSecurity block (only if it doesn't exist)
if ! grep -q "SecRuleEngine Off" "$CWP_VHOST"; then
    echo "➕ Adding correct ModSecurity block..."
    
    # Use a safer method: create temp file with correct content
    TEMP_FILE=$(mktemp)
    
    # Copy everything before VirtualHost start
    head -n $FIRST_VHOST_START "$CWP_VHOST" > "$TEMP_FILE"
    
    # Add correct IfModule block with proper indentation
    echo -e "\t<IfModule mod_security2.c>" >> "$TEMP_FILE"
    echo -e "\t\tSecRuleEngine Off" >> "$TEMP_FILE"
    echo -e "\t</IfModule>" >> "$TEMP_FILE"
    
    # Copy everything after VirtualHost start
    tail -n +$((FIRST_VHOST_START + 1)) "$CWP_VHOST" >> "$TEMP_FILE"
    
    # Replace original file
    mv "$TEMP_FILE" "$CWP_VHOST"
    echo "✅ Added correct ModSecurity block"
else
    echo "✅ ModSecurity block already exists"
fi

# Verify the file structure
echo "📋 Verifying file structure around VirtualHost start:"
sed -n "$FIRST_VHOST_START,$((FIRST_VHOST_START + 10))p" "$CWP_VHOST"

# Test Apache configuration
echo ""
echo "🔍 Testing Apache configuration..."
if /usr/local/apache/bin/httpd -t 2>&1; then
    echo "✅ Apache configuration is VALID!"
    echo ""
    echo "🔄 Starting Apache..."
    systemctl start httpd || /usr/local/apache/bin/apachectl start
    sleep 2
    
    if systemctl is-active --quiet httpd; then
        echo "✅ Apache started successfully!"
        systemctl status httpd --no-pager -l | head -10
    else
        echo "❌ Apache failed to start"
        systemctl status httpd --no-pager -l
        exit 1
    fi
else
    echo "❌ Apache configuration still has errors!"
    echo ""
    echo "📋 Showing problematic area (lines 55-65):"
    sed -n '55,65p' "$CWP_VHOST" | cat -n
    echo ""
    echo "📋 Full file content:"
    cat "$CWP_VHOST"
    exit 1
fi

echo ""
echo "✅ Apache fixed and running!"
