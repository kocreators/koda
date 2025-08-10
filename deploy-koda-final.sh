#!/bin/bash

echo "🚀 FINAL KODA DEPLOYMENT - GET IT WORKING!"
echo "=========================================="

# Check if we're in the right directory
if [ ! -f "App.tsx" ]; then
    echo "❌ App.tsx not found. Please navigate to your koda project directory first."
    echo "Run: cd ~/koda-project"
    exit 1
fi

echo "✅ Found App.tsx - in correct directory"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf node_modules dist package-lock.json

# Install dependencies
echo "📦 Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ npm install failed. Trying with legacy peer deps..."
    npm install --legacy-peer-deps
    if [ $? -ne 0 ]; then
        echo "❌ Installation failed completely"
        exit 1
    fi
fi

# Update vite.config.ts for custom domain (root path)
echo "⚙️ Configuring for custom domain..."
cp vite.config.ts vite.config.ts.backup
sed -i 's|base: "/koda/"|base: "/"|' vite.config.ts

# Build the application
echo "🏗️ Building Koda app..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    # Restore backup
    mv vite.config.ts.backup vite.config.ts
    exit 1
fi

# Verify build output
if [ ! -f "dist/index.html" ]; then
    echo "❌ Build failed - no dist/index.html found"
    mv vite.config.ts.backup vite.config.ts
    exit 1
fi

echo "✅ Build successful!"

# Deploy to S3 root (for custom domain)
echo "☁️ Deploying to S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/ --delete --exclude "AWSLogs/*"

if [ $? -ne 0 ]; then
    echo "❌ S3 deployment failed!"
    mv vite.config.ts.backup vite.config.ts
    exit 1
fi

echo "✅ Deployed to S3!"

# Test the deployment
echo "🧪 Testing deployment..."
sleep 5

# Test custom domain
echo "Testing koda.kocreators.com..."
CUSTOM_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://koda.kocreators.com")
echo "Custom domain status: $CUSTOM_STATUS"

# Test CloudFront fallback
echo "Testing CloudFront fallback..."
CLOUDFRONT_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://d3d8ucpm7p01n7.cloudfront.net")
echo "CloudFront status: $CLOUDFRONT_STATUS"

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================"
echo ""

if [ "$CUSTOM_STATUS" = "200" ]; then
    echo "🌟 SUCCESS! Your Koda app is live at:"
    echo "🌐 https://koda.kocreators.com"
    echo ""
    echo "✅ What you should see:"
    echo "   • KODA title in teal color"
    echo "   • CREATE YOUR DESIGN subtitle"
    echo "   • Style selection buttons"
    echo "   • Text, colors, icons inputs"
    echo "   • Generate button"
    echo "   • Complete three-step workflow"
    echo ""
    echo "🎊 Your app is ready for users!"
else
    echo "⚠️ Custom domain not responding (Status: $CUSTOM_STATUS)"
    echo "🔧 Check CloudFront configuration:"
    echo "   • Origin should point to S3 bucket root"
    echo "   • Origin Path should be empty (not /koda/)"
    echo "   • Default Root Object: index.html"
    echo ""
    if [ "$CLOUDFRONT_STATUS" = "200" ]; then
        echo "✅ Files deployed successfully to CloudFront"
        echo "🌐 Fallback URL: https://d3d8ucpm7p01n7.cloudfront.net"
    fi
fi

echo ""
echo "📋 Next steps if needed:"
echo "• Clear CloudFront cache if changes don't appear"
echo "• Check DNS settings for koda.kocreators.com"
echo "• Verify SSL certificate for custom domain"

# Restore backup config
if [ -f "vite.config.ts.backup" ]; then
    echo ""
    echo "🔄 Restored original vite.config.ts"
    mv vite.config.ts.backup vite.config.ts
fi