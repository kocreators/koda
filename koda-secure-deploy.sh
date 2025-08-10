#!/bin/bash
set -e

echo "🔒 KODA SECURE DEPLOYMENT (No Bucket Policy Changes Needed)"
echo "=========================================================="

# Verify we have a build
if [ ! -d "dist" ]; then
    echo "No build found. Building now..."
    npm run build
fi

if [ ! -f "dist/index.html" ]; then
    echo "❌ Build failed or incomplete"
    exit 1
fi

echo "✅ Build verified"

# Deploy to S3 (keeping it private is fine)
echo ""
echo "📦 Uploading to S3 (private bucket)..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete

if [ $? -ne 0 ]; then
    echo "❌ S3 upload failed"
    exit 1
fi

echo "✅ Files uploaded successfully!"

# Handle CloudFront
echo ""
echo "🌐 Handling CloudFront distribution..."

# Find the distribution
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ] && [ "$DISTRIBUTION_ID" != "" ]; then
    echo "Found CloudFront distribution: $DISTRIBUTION_ID"
    
    # Invalidate cache
    echo "Invalidating CloudFront cache..."
    INVALIDATION_ID=$(aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*" --query "Invalidation.Id" --output text)
    
    if [ $? -eq 0 ]; then
        echo "✅ Cache invalidation created: $INVALIDATION_ID"
        
        # Get the custom domain
        CUSTOM_DOMAIN=$(aws cloudfront get-distribution --id "$DISTRIBUTION_ID" --query "Distribution.DistributionConfig.Aliases.Items[0]" --output text 2>/dev/null)
        CLOUDFRONT_DOMAIN=$(aws cloudfront get-distribution --id "$DISTRIBUTION_ID" --query "Distribution.DomainName" --output text)
        
        echo ""
        echo "🎉 DEPLOYMENT SUCCESSFUL!"
        echo "========================"
        echo ""
        echo "✅ Files uploaded to S3"
        echo "✅ CloudFront cache invalidated"
        echo ""
        echo "🌐 Your Koda Logo Generator is available at:"
        
        if [ "$CUSTOM_DOMAIN" != "None" ] && [ "$CUSTOM_DOMAIN" != "null" ] && [ -n "$CUSTOM_DOMAIN" ]; then
            echo "   🔗 https://$CUSTOM_DOMAIN"
        fi
        echo "   🔗 https://$CLOUDFRONT_DOMAIN"
        
        echo ""
        echo "⏰ Changes may take 5-15 minutes to propagate globally"
        echo ""
        echo "🔒 Security: Your S3 bucket remains private (recommended)"
        echo "📈 Performance: Content served via CloudFront CDN"
        
    else
        echo "⚠️  CloudFront invalidation failed, but files are uploaded"
    fi
    
else
    echo "⚠️  CloudFront distribution not found automatically"
    echo ""
    echo "Your files are uploaded to S3. If you have a CloudFront distribution,"
    echo "you may need to manually invalidate the cache or check the distribution setup."
fi

echo ""
echo "🧪 Quick test (may take a moment to propagate):"
if [ "$CUSTOM_DOMAIN" != "None" ] && [ "$CUSTOM_DOMAIN" != "null" ] && [ -n "$CUSTOM_DOMAIN" ]; then
    echo "curl -I https://$CUSTOM_DOMAIN"
else
    echo "curl -I https://$CLOUDFRONT_DOMAIN"
fi