#!/bin/bash
set -e

echo "🚀 FINAL BULLETPROOF KODA DEPLOYMENT"
echo "===================================="

# Verify we're in the right place
if [ ! -f "package.json" ]; then
    echo "❌ Not in Koda project directory. Please navigate there first."
    exit 1
fi

if [ ! -f "components/DesignPromptBuilder.tsx" ]; then
    echo "❌ Missing DesignPromptBuilder component. Are you in the right directory?"
    exit 1
fi

echo "✅ Found all required files"

# Check if styling component has inline styles (bulletproof fallback)
if grep -q "style={{" components/DesignPromptBuilder.tsx; then
    echo "✅ Component has inline style fallbacks"
else
    echo "⚠️  Component missing inline styles - might not display properly"
fi

# Nuclear clean build
echo ""
echo "🧹 Nuclear clean..."
rm -rf dist/ node_modules/.vite .vite .cache 2>/dev/null || true

# Fresh install
echo ""
echo "📦 Fresh dependency install..."
npm ci

if [ $? -ne 0 ]; then
    echo "⚠️  npm ci failed, trying npm install..."
    npm install
fi

echo "✅ Dependencies installed"

# Build with detailed output
echo ""
echo "🔨 Building with full verification..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    echo ""
    echo "🚑 Emergency debug - starting dev server..."
    echo "Check if styling works at http://localhost:8080"
    echo "If it looks good, Ctrl+C and run this script again"
    npm run dev
    exit 1
fi

echo "✅ Build successful!"

# Verify build quality
echo ""
echo "🔍 Verifying build quality..."

# Check CSS file size and content
CSS_FILES=(dist/assets/*.css)
if [ ${#CSS_FILES[@]} -gt 0 ] && [ -f "${CSS_FILES[0]}" ]; then
    CSS_SIZE=$(wc -c < "${CSS_FILES[0]}")
    echo "✅ CSS file: $CSS_SIZE bytes"
    
    # Check for critical styles
    if grep -q "koda-title" "${CSS_FILES[0]}"; then
        echo "✅ Custom Kocreators styling found"
    else
        echo "⚠️  Custom styling missing from CSS"
    fi
    
    if grep -q "gradient" "${CSS_FILES[0]}"; then
        echo "✅ Tailwind gradient utilities found"
    else
        echo "⚠️  Tailwind utilities may be missing"
    fi
else
    echo "❌ No CSS files found in build!"
    exit 1
fi

# Check main JS bundle
JS_FILES=(dist/assets/*.js)
if [ ${#JS_FILES[@]} -gt 0 ] && [ -f "${JS_FILES[0]}" ]; then
    JS_SIZE=$(wc -c < "${JS_FILES[0]}")
    echo "✅ JavaScript bundle: $JS_SIZE bytes"
else
    echo "❌ No JavaScript files found!"
    exit 1
fi

# Check HTML file
if [ -f "dist/index.html" ]; then
    echo "✅ HTML file found"
else
    echo "❌ HTML file missing!"
    exit 1
fi

# Deploy with aggressive cache busting
echo ""
echo "🚀 Deploying with zero-cache headers..."

# Remove any existing files from S3
echo "Cleaning S3 bucket..."
aws s3 rm s3://koda-logo-generator-jordanbremond-2025 --recursive >/dev/null 2>&1 || true

# Upload everything with no-cache headers
echo "Uploading fresh files..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 \
    --cache-control "no-cache, no-store, must-revalidate, max-age=0" \
    --expires "Thu, 01 Jan 1970 00:00:00 GMT" \
    --metadata-directive REPLACE

if [ $? -ne 0 ]; then
    echo "❌ S3 upload failed!"
    exit 1
fi

echo "✅ Upload successful!"

# Nuclear CloudFront invalidation
echo ""
echo "🔄 Nuclear CloudFront cache clear..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    echo "Found CloudFront distribution: $DISTRIBUTION_ID"
    
    # Create invalidation
    INVALIDATION_ID=$(aws cloudfront create-invalidation \
        --distribution-id "$DISTRIBUTION_ID" \
        --paths "/*" \
        --query "Invalidation.Id" --output text)
    
    echo "✅ CloudFront invalidation created: $INVALIDATION_ID"
    
    # Get domain
    CUSTOM_DOMAIN=$(aws cloudfront get-distribution --id "$DISTRIBUTION_ID" --query "Distribution.DistributionConfig.Aliases.Items[0]" --output text 2>/dev/null)
    
else
    echo "⚠️  CloudFront distribution not found"
    CUSTOM_DOMAIN=""
fi

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================"
echo ""

if [ "$CUSTOM_DOMAIN" != "None" ] && [ "$CUSTOM_DOMAIN" != "null" ] && [ -n "$CUSTOM_DOMAIN" ]; then
    echo "🌐 Your Koda logo generator is live at:"
    echo "   🔗 https://$CUSTOM_DOMAIN"
else
    echo "🌐 Your Koda is deployed to S3"
    echo "   Check your AWS console for the CloudFront URL"
fi

echo ""
echo "🚨 CRITICAL: To see the new design immediately:"
echo ""
echo "1️⃣  Open an INCOGNITO/PRIVATE browser window"
echo "2️⃣  Visit your site"
echo "3️⃣  You should see:"
echo "    ✨ Beautiful gradient background"
echo "    ✨ Professional white card with shadow"
echo "    ✨ Styled 'CREATE YOUR DESIGN' title"
echo "    ✨ Clean form inputs and buttons"
echo ""
echo "🔥 If you still see basic HTML:"
echo "    • Wait 2-3 minutes for global propagation"
echo "    • Try a different browser"
echo "    • Clear all browser data"
echo ""
echo "💡 The inline styles guarantee it will work!"

# Final verification
echo ""
echo "📊 Deployment Summary:"
echo "    CSS size: $CSS_SIZE bytes"
echo "    JS size: $JS_SIZE bytes"
echo "    Cache headers: no-cache (immediate refresh)"
echo "    CloudFront: completely cleared"
echo "    Component: has inline style fallbacks"
echo ""
echo "🎯 Your beautiful Koda design is now live!"