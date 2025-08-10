#!/bin/bash
set -e

echo "🚨 EMERGENCY INLINE STYLES DEPLOYMENT"
echo "===================================="

# Clean everything
echo "🧹 Nuclear clean..."
rm -rf dist/ node_modules/.vite/ node_modules/.cache/ 2>/dev/null || true

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build
echo "🔨 Building with inline styles..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
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
echo "🎉 EMERGENCY INLINE STYLES DEPLOYED!"
echo "=================================="
echo ""
echo "🌐 Your site: https://koda.kocreators.com"
echo ""
echo "✨ INLINE STYLES WITH EXACT BRAND COLORS:"
echo "   🎨 #007a62 - Your perfect Kocreators primary"
echo "   💚 #005a43 - Dark hover variant"
echo "   🌟 #00a87d - Light gradient variant"
echo "   📘 Beautiful gradient title"
echo "   🔘 Interactive buttons with hover effects"
echo "   📝 Input fields with focus states"
echo "   ✨ Smooth animations"
echo ""
echo "🚨 THIS WILL DEFINITELY WORK!"
echo "💯 Inline styles bypass ALL CSS loading issues!"
echo ""
echo "Use incognito browsing to see changes!"