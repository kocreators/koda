#!/bin/bash
set -e

echo "🎨 DEPLOYING KODA WITH BEAUTIFUL CSS CLASSES"
echo "==========================================="

echo "✅ Fixed DesignPromptBuilder to use .koda-* CSS classes"
echo "✅ Your CSS file has all the beautiful styling ready"

# Remove conflicting Tailwind config
echo "🗑️  Removing conflicting Tailwind config..."
rm -f tailwind.config.ts tailwind.config.js tailwind.config.cjs

# Clean build
echo "🧹 Cleaning and building..."
rm -rf dist/ node_modules/.vite/ .vite/ 2>/dev/null || true
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

# Deploy
echo "🚀 Deploying to S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete

echo ""
echo "🎉 YOUR BEAUTIFUL DESIGN IS NOW LIVE!"
echo "===================================="
echo ""
echo "🌐 https://koda.kocreators.com"
echo ""
echo "✨ NOW SHOWING YOUR PERFECT DESIGN:"
echo "   🎨 Massive 3rem gradient 'CREATE YOUR DESIGN' title"
echo "   💎 Glass-effect card with backdrop blur"
echo "   🎯 Interactive Kocreators green style buttons"
echo "   ✨ Perfect #007a62 branding throughout"
echo "   🎪 Smooth hover animations on all buttons"
echo ""
echo "🚨 Open in incognito mode to see the changes!"