#!/bin/bash
set -e

echo "🎨 DEPLOYING ENHANCED KODA DESIGN SYSTEM"
echo "========================================"

# Clean any previous builds
echo "🧹 Cleaning previous builds..."
rm -rf dist/ node_modules/.vite 2>/dev/null || true

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Build with the enhanced design
echo ""
echo "🔨 Building enhanced design..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ Build successful!"

# Test the build locally first
echo ""
echo "🧪 Testing build integrity..."
if [ ! -f "dist/index.html" ]; then
    echo "❌ Build incomplete - missing index.html"
    exit 1
fi

if [ ! -f "dist/assets/index-"*.css ]; then
    echo "❌ Build incomplete - missing CSS files"
    exit 1
fi

echo "✅ Build integrity verified"

# Deploy to S3 with proper cache settings
echo ""
echo "🚀 Deploying to S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete \
    --cache-control "public, max-age=31536000" \
    --exclude "*.html" \
    --exclude "*.json"

# Deploy HTML files with no-cache
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 \
    --cache-control "no-cache, must-revalidate" \
    --include "*.html" \
    --include "*.json"

if [ $? -ne 0 ]; then
    echo "❌ S3 deployment failed"
    exit 1
fi

echo "✅ S3 deployment successful!"

# Invalidate CloudFront
echo ""
echo "🔄 Invalidating CloudFront cache..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    INVALIDATION_ID=$(aws cloudfront create-invalidation \
        --distribution-id "$DISTRIBUTION_ID" \
        --paths "/*" \
        --query "Invalidation.Id" --output text)
    
    echo "✅ CloudFront invalidation created: $INVALIDATION_ID"
    
    # Get domain info
    CUSTOM_DOMAIN=$(aws cloudfront get-distribution --id "$DISTRIBUTION_ID" --query "Distribution.DistributionConfig.Aliases.Items[0]" --output text 2>/dev/null)
    CLOUDFRONT_DOMAIN=$(aws cloudfront get-distribution --id "$DISTRIBUTION_ID" --query "Distribution.DomainName" --output text)
    
else
    echo "⚠️  CloudFront distribution not found"
fi

echo ""
echo "🎉 ENHANCED DESIGN DEPLOYED!"
echo "============================"
echo ""
echo "✨ New Features:"
echo "  ✅ Professional card-based layout"
echo "  ✅ Kocreators brand color integration"
echo "  ✅ Enhanced typography and spacing"
echo "  ✅ Improved form components"
echo "  ✅ Gradient branding elements"
echo "  ✅ Better responsive design"
echo "  ✅ Smooth animations and transitions"
echo ""

if [ "$CUSTOM_DOMAIN" != "None" ] && [ "$CUSTOM_DOMAIN" != "null" ] && [ -n "$CUSTOM_DOMAIN" ]; then
    echo "🌐 Your enhanced Koda logo generator is live at:"
    echo "   https://$CUSTOM_DOMAIN"
else
    echo "🌐 Your enhanced Koda logo generator is live at:"
    echo "   https://$CLOUDFRONT_DOMAIN"
fi

echo ""
echo "🔥 Design System Highlights:"
echo "  • Uses proper CSS custom properties"
echo "  • Consistent Kocreators branding"
echo "  • Professional shadcn/ui components"
echo "  • Accessible form controls"
echo "  • Mobile-responsive design"
echo ""
echo "⏰ Changes should be visible in 2-5 minutes"
echo "💡 Hard refresh (Ctrl+Shift+R) to see immediately"