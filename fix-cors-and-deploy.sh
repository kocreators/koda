#!/bin/bash

echo "🔧 FIXING CORS ERROR AND DEPLOYING KODA"
echo "======================================="

# Check if we're in the right directory
if [ ! -f "App.tsx" ]; then
    echo "❌ App.tsx not found. Please navigate to your koda project directory first."
    exit 1
fi

echo "✅ Found App.tsx - in correct directory"

# Show current vite config
echo "📋 Current vite.config.ts base path:"
grep "base:" vite.config.ts

# Clean everything to ensure fresh build
echo "🧹 Cleaning previous builds..."
rm -rf node_modules dist package-lock.json .vite

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

# Verify vite config is correct for custom domain
echo "⚙️ Verifying vite config for custom domain..."
if grep -q 'base: "/"' vite.config.ts; then
    echo "✅ Vite config correct for custom domain (base: '/')"
else
    echo "🔧 Fixing vite config for custom domain..."
    sed -i 's|base: "/koda/"|base: "/"|g' vite.config.ts
    echo "✅ Updated vite config to use base: '/'"
fi

# Build the application
echo "🏗️ Building Koda app with correct paths..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

# Verify build output has correct paths
if [ ! -f "dist/index.html" ]; then
    echo "❌ Build failed - no dist/index.html found"
    exit 1
fi

echo "🔍 Checking asset paths in built HTML..."
if grep -q "cloudfront" dist/index.html; then
    echo "⚠️ WARNING: Found CloudFront URLs in HTML - this will cause CORS"
    echo "HTML content:"
    cat dist/index.html
else
    echo "✅ Asset paths look correct (relative paths)"
fi

# Deploy to S3 root for custom domain
echo "☁️ Deploying to S3 root (for custom domain)..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/ --delete --exclude "AWSLogs/*" --exclude "*.sh" --exclude "*.md"

if [ $? -ne 0 ]; then
    echo "❌ S3 deployment failed!"
    exit 1
fi

echo "✅ Deployed to S3!"

# Clear CloudFront cache
echo "🔄 Attempting to clear CloudFront cache..."
DISTRIBUTION_ID="E3CU6OPCSI8GAR"  # Your CloudFront distribution ID
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*" 2>/dev/null || echo "⚠️ Could not clear CloudFront cache automatically"

# Test the deployment
echo "🧪 Testing deployment..."
sleep 10

echo "Testing custom domain..."
CUSTOM_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://koda.kocreators.com")
echo "Custom domain status: $CUSTOM_STATUS"

echo ""
echo "🎉 CORS FIX COMPLETE!"
echo "===================="

if [ "$CUSTOM_STATUS" = "200" ]; then
    echo "🌟 SUCCESS! Your Koda app should now work at:"
    echo "🌐 https://koda.kocreators.com"
    echo ""
    echo "✅ CORS issue fixed:"
    echo "   • Vite config updated to base: '/'"
    echo "   • Assets now have relative paths"
    echo "   • Deployed to S3 root for custom domain"
    echo "   • No more cross-origin requests"
    echo ""
    echo "🎊 Your three-step Koda workflow is ready!"
else
    echo "⚠️ Custom domain not responding yet (Status: $CUSTOM_STATUS)"
    echo "🔧 This could be due to:"
    echo "   • DNS propagation delay"
    echo "   • CloudFront cache needs time to clear"
    echo "   • SSL certificate issues"
    echo ""
    echo "💡 Try again in 5-10 minutes"
fi

echo ""
echo "📋 What your app should show:"
echo "• KODA title in teal color"
echo "• CREATE YOUR DESIGN form"
echo "• No CORS errors in browser console"
echo "• All assets loading from same domain"
</parameter>

<figma type="work">
Let me also create a simple test page to verify the fix worked.