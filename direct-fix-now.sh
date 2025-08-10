#!/bin/bash

echo "🎯 DIRECT KODA FIX - SIMPLE APPROACH"
echo "=================================="

# Step 1: Clean slate
echo "1️⃣ Cleaning previous builds..."
rm -rf node_modules dist package-lock.json
echo "✅ Clean slate ready"

# Step 2: Install fresh dependencies  
echo ""
echo "2️⃣ Installing dependencies..."
npm install
if [ $? -ne 0 ]; then
    echo "❌ npm install failed"
    echo "🔧 Trying with --legacy-peer-deps..."
    npm install --legacy-peer-deps
fi

# Step 3: Check if key files exist
echo ""
echo "3️⃣ Verifying project structure..."
echo "App.tsx: $([ -f App.tsx ] && echo "✅" || echo "❌")"
echo "main.tsx: $([ -f main.tsx ] && echo "✅" || echo "❌")"  
echo "index.html: $([ -f index.html ] && echo "✅" || echo "❌")"
echo "vite.config.ts: $([ -f vite.config.ts ] && echo "✅" || echo "❌")"

# Step 4: Build the app
echo ""
echo "4️⃣ Building Koda app..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    echo "🔍 Checking for common issues..."
    
    # Show any TypeScript errors
    echo "Attempting build with verbose output..."
    npm run build -- --verbose
    
    exit 1
fi

# Step 5: Verify build output
echo ""
echo "5️⃣ Checking build output..."
if [ -d "dist" ] && [ -f "dist/index.html" ]; then
    echo "✅ Build successful!"
    echo "📁 Built files:"
    ls -la dist/
else
    echo "❌ Build output missing"
    exit 1
fi

# Step 6: Deploy to S3
echo ""
echo "6️⃣ Deploying to S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/koda/ --delete --cache-control "max-age=3600"

if [ $? -ne 0 ]; then
    echo "❌ S3 sync failed"
    exit 1
fi

echo "✅ Files uploaded to S3"

# Step 7: Configure S3 website (again, to be sure)
echo ""
echo "7️⃣ Configuring S3 website hosting..."
aws s3 website s3://koda-logo-generator-jordanbremond-2025 --index-document index.html --error-document index.html

# Step 8: Test the deployment
echo ""
echo "8️⃣ Testing deployment..."
sleep 3

echo "Testing CloudFront..."
CLOUDFRONT_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://d3d8ucpm7p01n7.cloudfront.net/koda/")
echo "CloudFront Status: $CLOUDFRONT_STATUS"

echo "Testing S3 direct..."
S3_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://koda-logo-generator-jordanbremond-2025.s3-website-us-east-1.amazonaws.com/koda/")
echo "S3 Website Status: $S3_STATUS"

# Results
echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================"
echo ""
echo "🌐 Your Koda app URLs:"
echo "Primary: https://d3d8ucpm7p01n7.cloudfront.net/koda/"
echo "Backup:  http://koda-logo-generator-jordanbremond-2025.s3-website-us-east-1.amazonaws.com/koda/"
echo ""
echo "Expected to see:"
echo "✅ KODA title in teal"
echo "✅ AI LOGO GENERATOR subtitle"  
echo "✅ Business name input"
echo "✅ Dropdown menus"
echo "✅ Generate button"
echo ""

if [ "$CLOUDFRONT_STATUS" = "200" ] || [ "$S3_STATUS" = "200" ]; then
    echo "🎉 SUCCESS! Your app appears to be working!"
else
    echo "⚠️  Deployment complete but URLs may need time to propagate"
    echo "💡 Try again in 2-3 minutes if you see errors"
fi