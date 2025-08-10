#!/bin/bash

echo "🔨 REBUILDING AND DEPLOYING KODA"
echo "================================"
echo ""

# Check if we have the required files
if [ ! -f "package.json" ]; then
    echo "❌ package.json not found. Are you in the project directory?"
    echo "Run: pwd"
    echo "Should show a directory containing App.tsx and package.json"
    exit 1
fi

echo "✅ Found package.json"

if [ ! -f "App.tsx" ]; then
    echo "❌ App.tsx not found. Are you in the project directory?"
    exit 1
fi

echo "✅ Found App.tsx"
echo ""

# Clean install dependencies
echo "1️⃣ Installing dependencies..."
rm -rf node_modules package-lock.json
npm install

if [ $? -ne 0 ]; then
    echo "❌ npm install failed"
    exit 1
fi

echo "✅ Dependencies installed"
echo ""

# Build the project
echo "2️⃣ Building your Koda app..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    echo "🔧 Checking for common issues..."
    
    # Check if dist folder exists
    if [ ! -d "dist" ]; then
        echo "   No dist folder created"
    fi
    
    # Show build errors
    echo "   Try running: npm run build"
    exit 1
fi

echo "✅ Build successful"
echo ""

# Check build output
echo "3️⃣ Checking build output..."
if [ -f "dist/index.html" ]; then
    echo "✅ index.html created"
    echo "📁 Build files:"
    ls -la dist/
else
    echo "❌ No index.html in dist folder"
    echo "📁 dist contents:"
    ls -la dist/ 2>/dev/null || echo "   dist folder doesn't exist"
    exit 1
fi

echo ""

# Deploy to S3
echo "4️⃣ Deploying to S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/koda/ --delete

if [ $? -ne 0 ]; then
    echo "❌ S3 upload failed"
    exit 1
fi

echo "✅ Files uploaded to S3"
echo ""

# Test the deployment
echo "5️⃣ Testing deployment..."
sleep 2  # Give S3 a moment

CLOUDFRONT_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://d3d8ucpm7p01n7.cloudfront.net/koda/")
echo "CloudFront Status: $CLOUDFRONT_STATUS"

if [ "$CLOUDFRONT_STATUS" = "200" ]; then
    echo ""
    echo "🎉 SUCCESS! Your Koda app is live!"
    echo "🌐 Visit: https://d3d8ucpm7p01n7.cloudfront.net/koda/"
    echo ""
    echo "You should see:"
    echo "✅ KODA title in teal"
    echo "✅ AI LOGO GENERATOR subtitle"
    echo "✅ Business name input field"
    echo "✅ Dropdown menus for customization"
    echo "✅ Generate Logo Design Prompt button"
else
    echo ""
    echo "⚠️  Files uploaded but CloudFront might need time to update"
    echo "🌐 Try: https://d3d8ucpm7p01n7.cloudfront.net/koda/"
    echo "🌐 Or S3 direct: http://koda-logo-generator-jordanbremond-2025.s3-website-us-east-1.amazonaws.com/koda/"
fi

echo ""
echo "🚀 Deployment complete!"