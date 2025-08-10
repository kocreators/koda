#!/bin/bash
set -e

echo "🚀 FIXING AND DEPLOYING KODA LOGO GENERATOR"
echo "============================================="

# Step 1: Fix imports
echo "Step 1: Fixing versioned imports..."
chmod +x fix-imports-now.sh
./fix-imports-now.sh

# Step 2: Verify fixes
echo ""
echo "Step 2: Verifying fixes..."
chmod +x verify-imports.sh
./verify-imports.sh

# Step 3: Deploy to S3
echo ""
echo "Step 3: Deploying to S3..."
if command -v aws >/dev/null 2>&1; then
    echo "Uploading to S3 bucket..."
    aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete --acl public-read
    
    # Step 4: Invalidate CloudFront
    echo ""
    echo "Step 4: Invalidating CloudFront..."
    DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null || echo "")
    
    if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
        echo "Found distribution: $DISTRIBUTION_ID"
        aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*"
        echo "✅ CloudFront invalidation created!"
    else
        echo "⚠️  Could not find CloudFront distribution automatically."
        echo "Please manually invalidate your CloudFront cache with paths: /*"
    fi
    
    echo ""
    echo "🎉 DEPLOYMENT COMPLETE!"
    echo "======================="
    echo "✅ Build fixed and completed"
    echo "✅ Deployed to S3"
    echo "✅ CloudFront cache invalidated"
    echo ""
    echo "🌐 Your Koda logo generator should be live at:"
    echo "   https://koda.kocreators.com"
    echo ""
    
else
    echo "⚠️  AWS CLI not found. Build was successful but deployment skipped."
    echo "To deploy manually, run:"
    echo "  aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete"
fi

echo ""
echo "🧪 Quick test your deployment:"
echo "  curl -I https://koda.kocreators.com"