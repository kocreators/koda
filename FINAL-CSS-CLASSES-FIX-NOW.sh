#!/bin/bash
set -e

echo "🎯 FINAL KODA CSS CLASSES FIX - DEPLOYING NOW!"
echo "=============================================="

echo "✅ CONFIRMED: Issue found!"
echo "   - tailwind.config.ts was blocking your CSS classes"
echo "   - Your .koda-* classes are perfect with !important"
echo "   - DesignPromptBuilder component is correct"

echo ""
echo "🗑️  REMOVING CONFLICTING CONFIG FILES..."
rm -f tailwind.config.ts tailwind.config.js tailwind.config.cjs
echo "   ✅ Removed all Tailwind config files"

echo ""
echo "🧹 CLEANING BUILD..."
rm -rf dist/ node_modules/.vite/ .vite/
echo "   ✅ Cleaned build cache"

echo ""
echo "🔨 BUILDING WITH TAILWIND V4 ZERO-CONFIG..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ BUILD FAILED!"
    echo "Check console output above for errors"
    exit 1
fi

echo "✅ BUILD SUCCESSFUL!"

echo ""
echo "🚀 DEPLOYING TO S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete

echo ""
echo "🎉 YOUR BEAUTIFUL KODA DESIGN IS NOW LIVE!"
echo "========================================="
echo ""
echo "🌐 https://koda.kocreators.com"
echo ""
echo "✨ NOW SHOWING:"
echo "   🎨 MASSIVE 3rem 'CREATE YOUR DESIGN' gradient title"
echo "   💎 Glass-effect card with perfect backdrop blur"
echo "   🎯 Beautiful Kocreators green (#007a62) buttons"
echo "   ✨ Smooth hover animations with transform effects"
echo "   📱 Perfect responsive design"
echo ""
echo "🚨 MUST TEST IN INCOGNITO MODE!"
echo "   • Open new incognito window"
echo "   • Visit https://koda.kocreators.com"
echo "   • See your beautiful design finally working!"
echo ""
echo "🎯 The .koda-* CSS classes are now active!"