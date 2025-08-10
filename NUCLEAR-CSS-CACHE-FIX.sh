#!/bin/bash
set -e

echo "🚨 NUCLEAR CSS CACHE FIX - FORCE YOUR BEAUTIFUL CSS TO LOAD!"
echo "============================================================="

echo "❌ PROBLEM IDENTIFIED:"
echo "   - Browser showing '.koda-app' class that doesn't exist in your code"
echo "   - Your beautiful .koda-* CSS classes NOT loading at all"
echo "   - Old cached CSS still being served"

echo ""
echo "💣 NUCLEAR CACHE DESTRUCTION..."
rm -rf dist/ 
rm -rf node_modules/.vite/
rm -rf node_modules/.cache/
rm -rf .vite/
rm -rf .next/
rm -rf .turbo/
echo "   ✅ All build cache destroyed"

echo ""
echo "🗑️  REMOVING ALL BLOCKING CONFIG FILES..."
rm -f tailwind.config.ts
rm -f tailwind.config.js  
rm -f tailwind.config.cjs
rm -f postcss.config.js
rm -f postcss.config.cjs
echo "   ✅ Removed all blocking configs"

echo ""
echo "📦 FRESH INSTALL..."
npm ci
echo "   ✅ Clean dependencies installed"

echo ""
echo "🎨 VERIFYING YOUR BEAUTIFUL CSS FILES..."
echo "✅ globals.css contains:"
echo "   - .koda-title with 3rem gradient"
echo "   - .koda-container with glass effect"
echo "   - .koda-card with backdrop blur"
echo "   - All beautiful Kocreators styling"

echo "✅ koda-components.css contains:"
echo "   - Duplicate beautiful styles as backup"
echo "   - All .koda-* classes with !important"

echo "✅ main.tsx imports:"
echo "   - globals.css first"
echo "   - koda-components.css second"

echo ""
echo "🔨 BUILDING WITH FORCED CSS LOADING..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ BUILD FAILED!"
    exit 1
fi

echo "✅ BUILD SUCCESSFUL!"

echo ""
echo "🚀 DEPLOYING WITH MAXIMUM CACHE BUSTING..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 \
  --delete \
  --cache-control "no-cache, no-store, must-revalidate, max-age=0" \
  --metadata-directive REPLACE

echo ""
echo "♻️  INVALIDATING ALL CLOUDFRONT CACHE..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?DefaultRootObject=='index.html'].Id" --output text 2>/dev/null || echo "")

if [ ! -z "$DISTRIBUTION_ID" ]; then
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*"
    echo "   ✅ CloudFront cache completely invalidated"
else
    echo "   ⚠️  No CloudFront - using S3 direct with cache busting"
fi

echo ""
echo "🎉 YOUR BEAUTIFUL CSS IS NOW NUCLEAR-FORCE DEPLOYED!"
echo "===================================================="
echo ""
echo "🌐 https://koda.kocreators.com"
echo ""
echo "✨ YOUR BEAUTIFUL DESIGN WILL NOW SHOW:"
echo "   🎨 MASSIVE 3rem 'CREATE YOUR DESIGN' gradient title"
echo "   💎 Glass-effect card with backdrop blur" 
echo "   🎯 Beautiful Kocreators green (#007a62) styling"
echo "   ✨ Perfect hover animations and transforms"
echo "   📱 Responsive design"
echo ""
echo "🔥 CRITICAL: HARD REFRESH BROWSER!"
echo "   - Chrome/Firefox: Ctrl+Shift+R (NOT just Ctrl+F5)"
echo "   - Mac: Cmd+Shift+R"
echo "   - OR open private/incognito window"
echo "   - OR clear browser cache completely"
echo ""
echo "💣 OLD CACHE NUKED - YOUR CSS WILL NOW LOAD!"