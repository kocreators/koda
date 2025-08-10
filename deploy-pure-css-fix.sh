#!/bin/bash
set -e

echo "🎨 DEPLOYING PURE CSS FIXED DESIGN"
echo "=================================="

# Clean build
echo "🧹 Clean build..."
rm -rf dist/ 2>/dev/null || true

# Build
echo "🔨 Building pure CSS version..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ Build successful!"

# Deploy with no caching
echo ""
echo "🚀 Deploying beautiful design..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete \
    --cache-control "no-cache, must-revalidate, max-age=0"

if [ $? -ne 0 ]; then
    echo "❌ Upload failed"
    exit 1
fi

echo "✅ Upload successful!"

# Clear CloudFront
echo ""
echo "🔄 Clearing CloudFront..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*" >/dev/null
    echo "✅ CloudFront cleared"
    
    CUSTOM_DOMAIN=$(aws cloudfront get-distribution --id "$DISTRIBUTION_ID" --query "Distribution.DistributionConfig.Aliases.Items[0]" --output text 2>/dev/null)
else
    echo "⚠️  CloudFront not found"
fi

echo ""
echo "🎉 BEAUTIFUL DESIGN DEPLOYED!"
echo "============================"
echo ""

if [ "$CUSTOM_DOMAIN" != "None" ] && [ "$CUSTOM_DOMAIN" != "null" ] && [ -n "$CUSTOM_DOMAIN" ]; then
    echo "🌐 Your stunning Koda is live at:"
    echo "   https://$CUSTOM_DOMAIN"
else
    echo "🌐 Check your CloudFront URL"
fi

echo ""
echo "✨ Fixed Features:"
echo "  🎨 Pure CSS styling (no broken Tailwind dependencies)"
echo "  💚 Beautiful Kocreators gradient branding"
echo "  🤍 Professional white card with backdrop blur"
echo "  🔘 Interactive buttons with hover animations"
echo "  📝 Styled form inputs with focus effects"
echo "  ✨ Smooth transitions and shadows"
echo ""
echo "🚨 Use incognito/private browsing for immediate results!"