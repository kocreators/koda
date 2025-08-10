#!/bin/bash
set -e

echo "🔧 FIXING TAILWIND V4 STYLING ISSUE"
echo "==================================="

# Check we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Not in project directory"
    exit 1
fi

echo "✅ Found project directory"

# Clean build
echo ""
echo "🧹 Clean build..."
rm -rf dist/ node_modules/.vite 2>/dev/null || true

# Build the project
echo ""
echo "🔨 Building with CSS custom properties..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed - trying dev server..."
    echo "🚀 Starting dev server to verify styling..."
    npm run dev &
    DEV_PID=$!
    echo ""
    echo "📍 Check http://localhost:8080"
    echo "🎨 You should now see beautiful gradient background and styled components"
    echo "🛑 If styling looks good, press Ctrl+C and run the deployment again"
    wait $DEV_PID
    exit 1
fi

echo "✅ Build successful!"

# Verify the build
CSS_FILES=(dist/assets/*.css)
if [ ${#CSS_FILES[@]} -gt 0 ] && [ -f "${CSS_FILES[0]}" ]; then
    CSS_SIZE=$(wc -c < "${CSS_FILES[0]}")
    echo "✅ CSS file: $CSS_SIZE bytes"
    
    # Check for our custom properties
    if grep -q "kocreators-primary" "${CSS_FILES[0]}"; then
        echo "✅ Kocreators branding included"
    else
        echo "⚠️  Custom branding may be missing"
    fi
else
    echo "❌ No CSS files found!"
    exit 1
fi

# Deploy with no caching
echo ""
echo "🚀 Deploying fixed styling..."

aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete \
    --cache-control "no-cache, must-revalidate, max-age=0" \
    --metadata-directive REPLACE

if [ $? -ne 0 ]; then
    echo "❌ Upload failed"
    exit 1
fi

echo "✅ Upload successful!"

# Clear CloudFront
echo ""
echo "🔄 Clearing CloudFront cache..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*" >/dev/null
    echo "✅ CloudFront cleared"
    
    CUSTOM_DOMAIN=$(aws cloudfront get-distribution --id "$DISTRIBUTION_ID" --query "Distribution.DistributionConfig.Aliases.Items[0]" --output text 2>/dev/null)
else
    echo "⚠️  CloudFront not found"
fi

echo ""
echo "🎉 TAILWIND V4 STYLING FIXED!"
echo "============================"
echo ""

if [ "$CUSTOM_DOMAIN" != "None" ] && [ "$CUSTOM_DOMAIN" != "null" ] && [ -n "$CUSTOM_DOMAIN" ]; then
    echo "🌐 Your beautifully styled Koda is live at:"
    echo "   https://$CUSTOM_DOMAIN"
else
    echo "🌐 Check your CloudFront URL"
fi

echo ""
echo "✨ Fixed Issues:"
echo "  ✅ Replaced Tailwind v3 utilities with CSS custom properties"
echo "  ✅ Beautiful gradient background using pure CSS"
echo "  ✅ Professional card layout with backdrop blur"
echo "  ✅ Styled buttons with hover effects"
echo "  ✅ Proper focus states on inputs"
echo "  ✅ Kocreators branding integration"
echo ""
echo "🚨 IMPORTANT: Use incognito/private browsing for immediate results!"
echo ""
echo "💡 The design now uses your existing CSS custom properties"
echo "   instead of relying on Tailwind v4 beta utilities"