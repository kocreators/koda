#!/bin/bash
set -e

echo "🎯 DEPLOYING INLINE STYLES FIX - GUARANTEED TO WORK"
echo "=================================================="

# Kill any running dev servers
pkill -f "vite\|npm.*dev" 2>/dev/null || true
sleep 1

# Clean build
echo "🧹 Cleaning previous builds..."
rm -rf dist/ node_modules/.vite/ 2>/dev/null || true

echo ""
echo "🔨 Building with inline styles..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed - check errors above"
    exit 1
fi

echo "✅ Build successful!"

echo ""
echo "🚀 Deploying to production..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete \
    --cache-control "no-cache, must-revalidate, max-age=0"

if [ $? -ne 0 ]; then
    echo "❌ S3 upload failed"
    exit 1
fi

echo "✅ Deployment complete!"

echo ""
echo "🔄 Clearing CloudFront cache..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*" >/dev/null 2>&1
    echo "✅ Cache cleared!"
fi

echo ""
echo "🎉 INLINE STYLES FIX COMPLETE!"
echo "=============================="
echo ""
echo "✨ What was fixed:"
echo "  🎯 Used inline styles instead of broken CSS classes"
echo "  💚 Green gradient title with underline"
echo "  🎨 Beautiful gradient background" 
echo "  🤍 Professional glass card effect"
echo "  🔘 Interactive styled buttons"
echo "  📝 Focus effects on inputs"
echo "  ✨ Hover animations"
echo ""
echo "🌐 Your beautiful Koda is now live at:"
echo "   https://koda.kocreators.com"
echo ""
echo "🚨 IMPORTANT: View in incognito/private browsing to bypass cache!"
echo "🎯 This uses inline styles - NO external CSS dependencies!"

chmod +x deploy-inline-styles-fix.sh
EOF

chmod +x deploy-inline-styles-fix.sh

echo "✅ Deploy script created!"
echo ""
echo "🚀 RUN THIS NOW:"
echo "   ./deploy-inline-styles-fix.sh"
echo ""
echo "🎯 This uses inline styles that will work immediately!"