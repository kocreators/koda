#!/bin/bash
set -e

echo "🎨 DEPLOYING CSS CLASSES FIX"
echo "============================"

# Clean everything
echo "🧹 Cleaning build..."
rm -rf dist/ node_modules/.vite/ 2>/dev/null || true

echo "🔨 Building with CSS classes..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed - installing dependencies..."
    npm install
    npm run build
    if [ $? -ne 0 ]; then
        echo "❌ Build still failed"
        exit 1
    fi
fi

echo "✅ Build successful!"

# Deploy to S3
echo "🚀 Deploying to S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete \
    --cache-control "no-cache, must-revalidate, max-age=0"

if [ $? -ne 0 ]; then
    echo "❌ S3 deployment failed"
    exit 1
fi

echo "✅ Deployment complete!"

# Clear CloudFront cache
echo "🔄 Clearing CloudFront cache..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*" >/dev/null 2>&1
    echo "✅ Cache cleared!"
fi

echo ""
echo "🎉 CSS CLASSES FIX DEPLOYED!"
echo "============================"
echo ""
echo "🌐 Your site: https://koda.kocreators.com"
echo ""
echo "✨ NOW USING YOUR BEAUTIFUL CSS CLASSES:"
echo "   🎨 .koda-title - Your perfect gradient title"
echo "   📘 .koda-container - Beautiful background gradient"
echo "   🔘 .koda-style-button - Interactive selection buttons"
echo "   📝 .koda-input - Input fields with brand focus states"
echo "   ✨ .koda-generate-button - Generate button with animations"
echo "   🎯 All with your exact Kocreators #007a62 brand color!"
echo ""
echo "🚨 Use incognito browsing to see changes!"
echo "💯 Your CSS classes from globals.css will work perfectly!"