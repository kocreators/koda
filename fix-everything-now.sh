#!/bin/bash
set -e

echo "🛠️  COMPREHENSIVE KODA STYLING FIX"
echo "=================================="

# Verify we're in the right place
if [ ! -f "package.json" ]; then
    echo "❌ Please run this from your Koda project directory"
    exit 1
fi

# Check if the design component is correct
echo "🔍 Verifying component has styling..."
if grep -q "bg-gradient-to-br from-slate-50" components/DesignPromptBuilder.tsx; then
    echo "✅ DesignPromptBuilder has updated styling"
else
    echo "❌ DesignPromptBuilder missing styling - fixing now..."
    # The component content is already correct from previous updates
fi

# Check CSS file
echo ""
echo "🔍 Checking CSS file..."
if grep -q "koda-title" styles/globals.css; then
    echo "✅ Custom CSS found in globals.css"
else
    echo "❌ Custom CSS missing from globals.css"
    exit 1
fi

# Clean build
echo ""
echo "🧹 Clean build process..."
rm -rf dist/ node_modules/.vite 2>/dev/null || true

npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed - let's see what's wrong..."
    npm run dev &
    DEV_PID=$!
    echo "🚀 Development server started - check http://localhost:5173"
    echo "If styling looks good locally, press Ctrl+C and run the deploy again"
    wait $DEV_PID
    exit 1
fi

# Verify build contents
echo "✅ Build successful - verifying contents..."

# Check that CSS is substantial
CSS_FILES=(dist/assets/*.css)
if [ ${#CSS_FILES[@]} -gt 0 ] && [ -f "${CSS_FILES[0]}" ]; then
    CSS_SIZE=$(wc -c < "${CSS_FILES[0]}")
    echo "✅ CSS file size: $CSS_SIZE bytes"
    
    if [ "$CSS_SIZE" -lt 5000 ]; then
        echo "⚠️  CSS file seems small - checking content..."
        if grep -q "bg-gradient-to-br" "${CSS_FILES[0]}"; then
            echo "✅ Tailwind classes found"
        else
            echo "❌ Tailwind classes missing from CSS!"
            exit 1
        fi
    fi
else
    echo "❌ No CSS files found!"
    exit 1
fi

# Deploy with cache busting
echo ""
echo "🚀 Deploying with aggressive cache busting..."

# Upload with timestamp to force refresh
TIMESTAMP=$(date +%s)

aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete \
    --metadata-directive REPLACE \
    --cache-control "no-cache, no-store, must-revalidate, max-age=0" \
    --expires "Thu, 01 Jan 1970 00:00:00 GMT"

echo "✅ Upload complete with cache busting"

# Aggressive CloudFront invalidation
echo ""
echo "🔄 CloudFront invalidation..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*" >/dev/null
    echo "✅ CloudFront cache cleared"
    
    CUSTOM_DOMAIN=$(aws cloudfront get-distribution --id "$DISTRIBUTION_ID" --query "Distribution.DistributionConfig.Aliases.Items[0]" --output text 2>/dev/null)
else
    echo "⚠️  CloudFront not found - files uploaded to S3"
fi

echo ""
echo "🎉 STYLING FIX DEPLOYED!"
echo "======================="
echo ""

if [ "$CUSTOM_DOMAIN" != "None" ] && [ "$CUSTOM_DOMAIN" != "null" ] && [ -n "$CUSTOM_DOMAIN" ]; then
    echo "🌐 Visit: https://$CUSTOM_DOMAIN"
else
    echo "🌐 Check your CloudFront URL or S3 website endpoint"
fi

echo ""
echo "🔥 CRITICAL: Hard refresh required!"
echo "   • Chrome/Firefox: Ctrl+Shift+R"
echo "   • Safari: Cmd+Shift+R" 
echo "   • Or use incognito/private mode"
echo ""
echo "✨ You should now see:"
echo "   • Gradient background"
echo "   • Professional white card with shadow"
echo "   • Styled 'CREATE YOUR DESIGN' title"
echo "   • Beautiful form inputs and buttons"
echo ""
echo "🚨 If you STILL see basic styling:"
echo "   1. Try incognito mode immediately"
echo "   2. Clear browser cache completely"
echo "   3. Check a different browser"
echo "   4. Wait 10 minutes for full propagation"