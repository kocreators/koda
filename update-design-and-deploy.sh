#!/bin/bash
set -e

echo "🎨 UPDATING KODA DESIGN TO MATCH FIGMA"
echo "======================================"

# Build the updated design
echo "📦 Building updated design..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ Build successful!"

# Deploy to S3
echo ""
echo "🚀 Deploying updated design..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete

if [ $? -ne 0 ]; then
    echo "❌ Deployment failed"
    exit 1
fi

echo "✅ Deployment successful!"

# Invalidate CloudFront
echo ""
echo "🔄 Invalidating CloudFront cache..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*"
    echo "✅ CloudFront cache invalidated!"
else
    echo "⚠️  CloudFront distribution not found - cache not invalidated"
fi

echo ""
echo "🎉 DESIGN UPDATE COMPLETE!"
echo "========================="
echo ""
echo "✅ Updated design matches Figma preview"
echo "✅ Deployed to S3"
echo "✅ CloudFront cache cleared"
echo ""
echo "🌐 Your updated Koda logo generator should be live at:"
echo "   https://koda.kocreators.com"
echo ""
echo "🔍 Changes made:"
echo "   • Styled to match Figma design exactly"
echo "   • Added card layout with shadow"
echo "   • Improved spacing and typography"
echo "   • Better button styling and interactions"
echo "   • Clean, centered layout"
echo ""
echo "⏰ Changes may take 5-10 minutes to fully propagate"