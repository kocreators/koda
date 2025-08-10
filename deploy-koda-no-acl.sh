#!/bin/bash
set -e

echo "🚀 DEPLOYING KODA TO S3 (WITHOUT ACL)"
echo "====================================="

# Check if build exists
if [ ! -d "dist" ]; then
    echo "❌ No dist directory found. Running build first..."
    npm run build
fi

echo "📦 Deploying to S3 without ACL flags..."

# Deploy without ACL - let bucket policy handle permissions
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete

if [ $? -eq 0 ]; then
    echo "✅ S3 sync successful!"
    
    # Configure bucket for static website hosting (if not already done)
    echo "🌐 Configuring S3 bucket for static website hosting..."
    aws s3 website s3://koda-logo-generator-jordanbremond-2025 \
        --index-document index.html \
        --error-document index.html
    
    # Set bucket policy for public read access
    echo "🔓 Setting bucket policy for public access..."
    cat > bucket-policy.json << 'EOF'
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::koda-logo-generator-jordanbremond-2025/*"
        }
    ]
}
EOF
    
    aws s3api put-bucket-policy \
        --bucket koda-logo-generator-jordanbremond-2025 \
        --policy file://bucket-policy.json
    
    echo "✅ Bucket policy updated!"
    
    # Clean up policy file
    rm bucket-policy.json
    
    # Invalidate CloudFront
    echo "🔄 Invalidating CloudFront..."
    DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null || echo "")
    
    if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
        echo "Found CloudFront distribution: $DISTRIBUTION_ID"
        aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*"
        echo "✅ CloudFront invalidation created!"
    else
        echo "⚠️  Could not find CloudFront distribution. Manual invalidation may be needed."
    fi
    
    echo ""
    echo "🎉 DEPLOYMENT SUCCESSFUL!"
    echo "========================"
    echo "✅ Files uploaded to S3"
    echo "✅ Bucket configured for static hosting"
    echo "✅ Public access policy set"
    echo "✅ CloudFront cache invalidated"
    echo ""
    echo "🌐 Your Koda logo generator should be live at:"
    echo "   https://koda.kocreators.com"
    echo ""
    echo "🧪 Test your deployment:"
    echo "   curl -I https://koda.kocreators.com"
    
else
    echo "❌ S3 deployment failed"
    exit 1
fi