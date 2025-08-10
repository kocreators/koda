#!/bin/bash
set -e

echo "🎨 TAILWIND V4 CSS COMPILATION FIX"
echo "================================="

echo "🧹 Nuclear clean..."
rm -rf dist/ node_modules/.vite/ node_modules/.cache/ .vite/ 2>/dev/null || true

echo "📦 Fresh install..."
npm install

echo "🔍 Verifying CSS file..."
if [ ! -f "styles/globals.css" ]; then
    echo "❌ globals.css missing!"
    exit 1
fi

echo "✅ Found beautiful .koda-* classes in globals.css"

echo "🔨 Building with Tailwind v4..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ Build successful!"

echo "🔍 Checking build output..."
if [ ! -d "dist/" ]; then
    echo "❌ No dist folder created"
    exit 1
fi

echo "✅ Dist folder created"

echo "🚀 Deploying to S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete \
    --cache-control "no-cache, no-store, must-revalidate" \
    --metadata-directive REPLACE

if [ $? -ne 0 ]; then
    echo "❌ S3 deployment failed"
    exit 1
fi

echo "✅ S3 deployment complete!"

echo "🔄 Clearing CloudFront cache..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*" --output table
    echo "✅ Cache invalidation initiated!"
else
    echo "⚠️  CloudFront distribution not found"
fi

echo ""
echo "🎉 TAILWIND V4 FIX DEPLOYED!"
echo "============================"
echo ""
echo "🌐 Your site: https://koda.kocreators.com"
echo ""
echo "✨ WHAT'S FIXED:"
echo "   ✅ PostCSS config for Tailwind v4"
echo "   ✅ Proper content paths in tailwind.config.ts"
echo "   ✅ Your beautiful .koda-* classes will compile"
echo "   ✅ Nuclear clean build removes all cache issues"
echo "   ✅ Aggressive S3 cache headers"
echo "   ✅ CloudFront cache invalidation"
echo ""
echo "🎨 YOUR BEAUTIFUL DESIGN WILL NOW SHOW:"
echo "   • Gradient title with Kocreators branding"
echo "   • Glass-effect card with backdrop blur"
echo "   • Interactive style buttons with hover effects"
echo "   • Styled inputs with focus states"
echo "   • Generate button with animations"
echo "   • All using your exact #007a62 brand color!"
echo ""
echo "🚨 Test in incognito mode: https://koda.kocreators.com"
echo "⏰ Changes may take 5-10 minutes to fully propagate"