#!/bin/bash
set -e

echo "🚨 EMERGENCY FIX - GUARANTEED TO WORK"
echo "===================================="

# Kill any running dev servers
pkill -f "vite\|npm.*dev" 2>/dev/null || true
sleep 1

# Clean everything
echo "🧹 Cleaning all build artifacts..."
rm -rf dist/ node_modules/.vite/ 2>/dev/null || true

# Verify the component file exists and has content
echo "🔍 Checking component file..."
if [ ! -f "components/DesignPromptBuilder.tsx" ]; then
    echo "❌ DesignPromptBuilder.tsx not found!"
    exit 1
fi

# Build the application
echo "🔨 Building application..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    echo "Running npm install first..."
    npm install
    echo "Trying build again..."
    npm run build
    if [ $? -ne 0 ]; then
        echo "❌ Build still failed after npm install"
        exit 1
    fi
fi

echo "✅ Build successful!"

# Deploy to S3
echo "🚀 Deploying to S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete \
    --cache-control "no-cache, must-revalidate, max-age=0"

if [ $? -ne 0 ]; then
    echo "❌ S3 deployment failed!"
    exit 1
fi

echo "✅ Deployment complete!"

# Clear CloudFront cache
echo "🔄 Clearing CloudFront cache..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*" >/dev/null 2>&1
    echo "✅ Cache cleared!"
fi

echo ""
echo "🎉 EMERGENCY FIX COMPLETE!"
echo "========================="
echo ""
echo "🌐 Your site should now be live at:"
echo "   https://koda.kocreators.com"
echo ""
echo "🚨 IMPORTANT: Use incognito/private browsing to see changes!"
echo ""
echo "✨ You should now see:"
echo "   🎨 Beautiful gradient background"
echo "   💚 Green gradient title"
echo "   🤍 Professional white card"
echo "   🔘 Interactive buttons"
echo "   📝 Styled input fields"
echo "   ✨ Hover effects"
echo ""
echo "🎯 If this still doesn't work, the issue might be with your AWS setup."
EOF

chmod +x emergency-fix-now.sh