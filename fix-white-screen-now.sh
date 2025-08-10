#!/bin/bash

echo "🚨 FIXING WHITE SCREEN ISSUE..."

# Step 1: Clean previous build
echo "🧹 Cleaning previous build..."
rm -rf dist/ node_modules/.vite

# Step 2: Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Step 3: Build with correct config
echo "🔨 Building with correct subdirectory config..."
npm run build

# Step 4: Check if build was successful
if [ ! -d "dist" ]; then
    echo "❌ Build failed! Check for errors above."
    exit 1
fi

echo "✅ Build successful!"

# Step 5: Deploy to S3
echo "🚀 Deploying to S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/koda/ --delete

# Step 6: Clear CloudFront cache
echo "🔄 Clearing CloudFront cache..."
# Note: Replace with your actual distribution ID
# aws cloudfront create-invalidation --distribution-id EXXXXXXXXXXXXXXX --paths "/koda/*"

echo "🎉 Deployment complete!"
echo ""
echo "🌐 Test your app at:"
echo "https://d3d8ucpm7p01n7.cloudfront.net/koda/"
echo ""
echo "⏱️  Wait 2-3 minutes for CloudFront cache to clear, then refresh the page."
echo ""
echo "✅ You should see:"
echo "   - KODA title in teal color"
echo "   - AI LOGO GENERATOR subtitle"
echo "   - Design form with dropdowns"
echo "   - Professional styling"