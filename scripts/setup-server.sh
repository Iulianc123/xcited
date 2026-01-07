#!/bin/bash
# Setup script for xcited on CWP7pro server

set -e

echo "🚀 Setting up xcited on CWP7pro server..."
echo ""

# Check if we're on the server
if [ ! -f "/usr/local/cwpsrv/htdocs/resources/scripts/root" ]; then
  echo "⚠️  This script should be run on the CWP7pro server"
  echo "   Or ensure CWP7pro is installed"
fi

# Install Node.js 20 if not present
if ! command -v node &> /dev/null; then
  echo "📦 Installing Node.js 20..."
  curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
  yum install -y nodejs
fi

# Install PM2 if not present
if ! command -v pm2 &> /dev/null; then
  echo "📦 Installing PM2..."
  npm install -g pm2
fi

# Create user if doesn't exist
XCITED_USER="xcited"
if ! id "$XCITED_USER" &>/dev/null; then
  echo "👤 Creating user: $XCITED_USER..."
  /usr/local/cwpsrv/htdocs/resources/scripts/createacct xcited.org $XCITED_USER $XCITED_USER@example.com default 1 || {
    useradd -m -d /home/$XCITED_USER -s /bin/bash $XCITED_USER
    mkdir -p /home/$XCITED_USER/public_html
    chown -R $XCITED_USER:$XCITED_USER /home/$XCITED_USER
  }
fi

# Create ecosystem.config.js
cat > /home/$XCITED_USER/public_html/ecosystem.config.js << 'EOF'
module.exports = {
  apps: [{
    name: 'xcited-web',
    script: 'node_modules/.bin/next',
    args: 'start',
    cwd: '/home/xcited/public_html',
    instances: 2,
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    error_file: '/var/log/pm2/xcited-web-error.log',
    out_file: '/var/log/pm2/xcited-web-out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    merge_logs: true,
    autorestart: true,
    max_memory_restart: '1G'
  }]
}
EOF

chown $XCITED_USER:$XCITED_USER /home/$XCITED_USER/public_html/ecosystem.config.js

echo "✅ Server setup completed!"
echo ""
echo "📝 Next steps:"
echo "   1. Configure .env.production with DATABASE_URL and NextAuth secrets"
echo "   2. Deploy application using GitHub Actions"
echo "   3. Configure Apache reverse proxy for xcited.org"

