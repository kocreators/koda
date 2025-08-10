#!/bin/bash

echo "🧪 TESTING KODA DEPLOYMENT"
echo "=========================="

echo "Testing S3 bucket access..."
aws s3 ls s3://koda-logo-generator-jordanbremond-2025/ | head -5

echo ""
echo "Testing website endpoints..."

# Test S3 website endpoint
echo "📍 Testing S3 website endpoint..."
S3_ENDPOINT="http://koda-logo-generator-jordanbremond-2025.s3-website-us-east-1.amazonaws.com"
curl -I "$S3_ENDPOINT" 2>/dev/null | head -3

echo ""
echo "📍 Testing CloudFront/Custom domain..."
CUSTOM_ENDPOINT="https://koda.kocreators.com"
curl -I "$CUSTOM_ENDPOINT" 2>/dev/null | head -3

echo ""
echo "🔍 Checking bucket policy..."
aws s3api get-bucket-policy --bucket koda-logo-generator-jordanbremond-2025 --query Policy --output text 2>/dev/null | jq . 2>/dev/null || echo "Bucket policy exists but couldn't format"

echo ""
echo "✅ Deployment test complete!"
echo ""
echo "If you see HTTP 200 responses above, your deployment is working!"
echo "Visit: https://koda.kocreators.com"