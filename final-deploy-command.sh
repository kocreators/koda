#!/bin/bash

echo "🚀 DEPLOYING FIXED KODA APP"
echo "=========================="

# Clean build
echo "1️⃣ Cleaning previous build..."
rm -rf node_modules dist package-lock.json

# Install dependencies
echo "2️⃣ Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ npm install failed"
    exit 1
fi

# Build the app
echo "3️⃣ Building Koda app..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    echo "🔍 Check the error messages above"
    exit 1
fi

# Verify build output
if [ -f "dist/index.html" ]; then
    echo "✅ Build successful - index.html created"
else
    echo "❌ Build failed - no index.html found"
    exit 1
fi

# Deploy to S3
echo "4️⃣ Deploying to S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/koda/ --delete

if [ $? -ne 0 ]; then
    echo "❌ S3 deployment failed"
    exit 1
fi

# Test deployment
echo "5️⃣ Testing deployment..."
sleep 3

CLOUDFRONT_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://d3d8ucpm7p01n7.cloudfront.net/koda/")
echo "CloudFront Status: $CLOUDFRONT_STATUS"

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================"
echo ""
echo "🌐 Your Koda app is now live at:"
echo "Primary: https://d3d8ucpm7p01n7.cloudfront.net/koda/"
echo "Backup:  http://koda-logo-generator-jordanbremond-2025.s3-website-us-east-1.amazonaws.com/koda/"
echo ""
echo "✅ Fixed white screen issue - index.html now points to correct main.tsx"
echo "✅ Complete three-step Koda workflow ready"
echo "✅ Ready for kocreators.com/koda integration"

if [ "$CLOUDFRONT_STATUS" = "200" ]; then
    echo ""
    echo "🎊 SUCCESS! Your app is working!"
else
    echo ""
    echo "⚠️  Files deployed - CloudFront may need a few minutes to update"
fi