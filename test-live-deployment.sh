#!/bin/bash

echo "🔍 TESTING YOUR LIVE KODA DEPLOYMENT"
echo "=================================="
echo ""

# Test CloudFront URL
echo "1️⃣ Testing CloudFront URL..."
CLOUDFRONT_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://d3d8ucpm7p01n7.cloudfront.net/koda/")
echo "   Status: $CLOUDFRONT_STATUS"

if [ "$CLOUDFRONT_STATUS" = "200" ]; then
    echo "   ✅ CloudFront is working!"
    echo "   🌐 Your app should be live at: https://d3d8ucpm7p01n7.cloudfront.net/koda/"
else
    echo "   ❌ CloudFront issue - Status: $CLOUDFRONT_STATUS"
fi

echo ""

# Test S3 direct URL
echo "2️⃣ Testing S3 Website URL..."
S3_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://koda-logo-generator-jordanbremond-2025.s3-website-us-east-1.amazonaws.com/koda/")
echo "   Status: $S3_STATUS"

if [ "$S3_STATUS" = "200" ]; then
    echo "   ✅ S3 website is working!"
    echo "   🌐 Direct S3 URL: http://koda-logo-generator-jordanbremond-2025.s3-website-us-east-1.amazonaws.com/koda/"
else
    echo "   ❌ S3 website issue - Status: $S3_STATUS"
fi

echo ""

# Check files in S3
echo "3️⃣ Checking files in your S3 bucket..."
aws s3 ls s3://koda-logo-generator-jordanbremond-2025/koda/ --recursive

echo ""

# Get sample of index.html
echo "4️⃣ Checking your index.html content..."
aws s3 cp s3://koda-logo-generator-jordanbremond-2025/koda/index.html - | head -20

echo ""
echo "🎯 DIAGNOSIS COMPLETE"
echo "===================="

if [ "$CLOUDFRONT_STATUS" = "200" ] || [ "$S3_STATUS" = "200" ]; then
    echo "✅ Your Koda app appears to be working!"
    echo "🎉 Try visiting: https://d3d8ucpm7p01n7.cloudfront.net/koda/"
else
    echo "❌ Both CloudFront and S3 are failing"
    echo "🔧 Need to rebuild and redeploy your app"
fi