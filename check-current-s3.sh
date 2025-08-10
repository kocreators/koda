#!/bin/bash

echo "🔍 CHECKING YOUR CURRENT S3 DEPLOYMENT"
echo "====================================="

echo ""
echo "1️⃣ Files currently in S3 bucket:"
aws s3 ls s3://koda-logo-generator-jordanbremond-2025/koda/ --recursive --human-readable

echo ""
echo "2️⃣ S3 website configuration:"
aws s3api get-bucket-website --bucket koda-logo-generator-jordanbremond-2025 2>/dev/null || echo "❌ Website hosting not configured"

echo ""
echo "3️⃣ Testing current URLs:"
echo -n "CloudFront: "
curl -s -o /dev/null -w "%{http_code}" "https://d3d8ucpm7p01n7.cloudfront.net/koda/"
echo ""
echo -n "S3 Website: "  
curl -s -o /dev/null -w "%{http_code}" "http://koda-logo-generator-jordanbremond-2025.s3-website-us-east-1.amazonaws.com/koda/"

echo ""
echo ""
echo "4️⃣ Sample of your index.html:"
echo "============================"
aws s3 cp s3://koda-logo-generator-jordanbremond-2025/koda/index.html - 2>/dev/null | head -10 || echo "❌ No index.html found"

echo ""
echo "🎯 DIAGNOSIS:"
echo "============"
echo "If you see files but get 404 errors, run the direct-fix-now.sh script"
echo "If you see no files, you need to build and deploy first"
echo "If you see 200 status codes, your app should be working!"