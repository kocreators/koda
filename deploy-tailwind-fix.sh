#!/bin/bash
set -e

echo "🎨 DEPLOYING KOCREATORS BRAND COLORS FIX"
echo "========================================"

# Clean and build
echo "🧹 Cleaning build..."
rm -rf dist/ node_modules/.vite/ 2>/dev/null || true

echo "🔨 Building with Kocreators brand colors (#007a62)..."
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
echo "🎉 KOCREATORS BRAND COLORS DEPLOYED!"
echo "==================================="
echo ""
echo "🌐 Your site: https://koda.kocreators.com"
echo ""
echo "✨ NOW USING YOUR PERFECT BRAND COLORS:"
echo "   🎨 --kocreators-primary: #007a62"
echo "   💚 --kocreators-primary-dark: #005a43"
echo "   🌟 --kocreators-primary-light: #00a87d"
echo "   📘 .koda-title (gradient title with underline)"
echo "   🔘 .koda-style-button (brand color selections)"
echo "   📝 .koda-input (focus states with brand color)"
echo "   ✨ .koda-generate-button (hover animations)"
echo ""
echo "🚨 Use incognito browsing to see changes!"
echo "🎯 Your exact Kocreators brand colors are perfect!"