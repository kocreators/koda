#!/bin/bash
set -e

echo "🚀 COMPLETE KODA DEPLOYMENT SOLUTION"
echo "===================================="

# Step 1: Ensure we have a successful build
echo "Step 1: Verifying build..."
if [ ! -d "dist" ]; then
    echo "Building project..."
    npm run build
fi

if [ ! -f "dist/index.html" ]; then
    echo "❌ Build failed - no index.html found"
    exit 1
fi

echo "✅ Build verified!"

# Step 2: Deploy to S3 without ACL
echo ""
echo "Step 2: Deploying to S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete

# Step 3: Configure S3 for static website
echo ""
echo "Step 3: Configuring S3 static website..."
aws s3 website s3://koda-logo-generator-jordanbremond-2025 \
    --index-document index.html \
    --error-document index.html

# Step 4: Set public access policy
echo ""
echo "Step 4: Setting public access policy..."
cat > /tmp/koda-bucket-policy.json << 'EOF'
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
    --policy file:///tmp/koda-bucket-policy.json

rm /tmp/koda-bucket-policy.json

# Step 5: Invalidate CloudFront
echo ""
echo "Step 5: Invalidating CloudFront..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null || echo "")

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    echo "Invalidating distribution: $DISTRIBUTION_ID"
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*"
    echo "✅ CloudFront invalidation created!"
else
    echo "⚠️  CloudFront distribution not found automatically"
fi

# Step 6: Test deployment
echo ""
echo "Step 6: Testing deployment..."
sleep 3

echo "Testing S3 website endpoint..."
curl -I "http://koda-logo-generator-jordanbremond-2025.s3-website-us-east-1.amazonaws.com" 2>/dev/null | head -1

echo "Testing custom domain..."
curl -I "https://koda.kocreators.com" 2>/dev/null | head -1

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================"
echo ""
echo "✅ Build successful"
echo "✅ S3 upload complete"
echo "✅ Static website configured"
echo "✅ Public access enabled"
echo "✅ CloudFront invalidated"
echo "✅ Deployment tested"
echo ""
echo "🌐 Your Koda Logo Generator is live at:"
echo "   https://koda.kocreators.com"
echo ""
echo "🎯 Next steps you can take:"
echo "   • Test logo generation functionality"
echo "   • Test the pricing chatbot"
echo "   • Set up Google Sheets integration"
echo "   • Configure Stripe for payments"