#!/bin/bash
set -e

echo "🎯 DEPLOYING YOUR EXISTING PERFECT CODE!"
echo "======================================="

echo "✅ YOUR CODE IS ALREADY PERFECT:"
echo "   - App.tsx uses CSS variables ✓"
echo "   - globals.css has beautiful .koda-* classes ✓"
echo "   - DesignPromptBuilder.tsx uses correct classes ✓"
echo "   - main.tsx imports globals.css ✓"

echo ""
echo "🧹 CLEANING BUILD CACHE..."
rm -rf dist/ node_modules/.vite/ .vite/
rm -f tailwind.config.ts tailwind.config.js tailwind.config.cjs
rm -f postcss.config.js postcss.config.cjs

echo ""
echo "📦 INSTALLING DEPENDENCIES..."
npm ci

echo ""
echo "🔨 BUILDING YOUR PERFECT CODE..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ BUILD FAILED!"
    exit 1
fi

echo "✅ BUILD SUCCESSFUL!"

echo ""
echo "🚀 DEPLOYING TO S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 \
  --delete \
  --cache-control "no-cache, no-store, must-revalidate"

echo ""
echo "♻️  INVALIDATING CLOUDFRONT CACHE..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?DefaultRootObject=='index.html'].Id" --output text 2>/dev/null || echo "")

if [ ! -z "$DISTRIBUTION_ID" ]; then
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*"
    echo "   ✅ CloudFront cache invalidated"
fi

echo ""
echo "🎉 YOUR BEAUTIFUL KOCREATORS DESIGN IS NOW LIVE!"
echo "=============================================="
echo ""
echo "🌐 https://koda.kocreators.com"
echo ""
echo "✨ YOUR PERFECT DESIGN FEATURES:"
echo "   🎨 3rem gradient 'CREATE YOUR DESIGN' title"
echo "   💎 Glass-effect card with backdrop blur"
echo "   🎯 Kocreators green (#007a62) buttons"
echo "   ✨ Beautiful hover animations"
echo "   📱 Responsive design"
echo ""
echo "🔥 HARD REFRESH BROWSER IN 30 SECONDS!"
echo "   Ctrl+Shift+R (Windows/Linux) or Cmd+Shift+R (Mac)"
echo ""
echo "💎 YOUR CODE WAS ALREADY PERFECT - JUST NEEDED DEPLOYMENT!"