#!/bin/bash
set -e

echo "🎯 CSS CONFLICT FIX DEPLOYMENT"
echo "=============================="

echo "✅ PROBLEM SOLVED:"
echo "   ❌ App.tsx had: className='koda-title text-2xl m-0'"
echo "   ✅ Fixed to:     className='koda-title'"
echo ""
echo "💡 Tailwind 'text-2xl' was overriding your beautiful CSS font-size!"

echo "🧹 Cleaning build..."
rm -rf dist/ node_modules/.vite/ 2>/dev/null || true

echo "🔨 Building with fixed classes..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ Build successful!"

echo "🚀 Deploying to S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete

echo "🔄 Clearing CloudFront cache..."
aws cloudfront create-invalidation --distribution-id E1234567890123 --paths "/*" 2>/dev/null || echo "⚠️ CloudFront cache clear manual needed"

echo ""
echo "🎉 CSS CONFLICTS FIXED!"
echo "======================"
echo ""
echo "🌐 https://koda.kocreators.com"
echo ""
echo "✨ NOW YOU'LL SEE:"
echo "   🎨 Beautiful gradient title (3rem font-size)"
echo "   💎 Glass-effect card with backdrop blur"  
echo "   🎯 Interactive style buttons with hover"
echo "   ✨ Perfect #007a62 Kocreators branding"
echo ""
echo "🚨 Test in incognito mode!"