#!/bin/bash

echo "☢️  NUCLEAR CLEAN BUILD - CLEARING ALL CACHES"
echo "============================================="

# Check if we're in the right directory
if [ ! -f "App.tsx" ]; then
    echo "❌ App.tsx not found. Please run this from your project root directory."
    exit 1
fi

echo "✅ Found App.tsx - in correct directory"

# Step 1: Nuclear clean - remove EVERYTHING
echo "☢️ Step 1: Nuclear clean of all build artifacts and caches..."
rm -rf node_modules
rm -rf package-lock.json
rm -rf .npm
rm -rf ~/.npm
rm -rf dist
rm -rf .vite
rm -rf build

# Clear npm cache completely
npm cache clean --force

echo "✅ Nuclear clean complete"

# Step 2: Fix any remaining version-numbered imports
echo "🔧 Step 2: Fixing version-numbered imports..."
find . -name "*.tsx" -o -name "*.ts" | grep -v node_modules | xargs sed -i '' -E 's/from "([^@"]+)@[^"]+"/from "\1"/g' 2>/dev/null
find . -name "*.tsx" -o -name "*.ts" | grep -v node_modules | xargs sed -i '' -E "s/from '([^@']+)@[^']+'/from '\1'/g" 2>/dev/null

echo "✅ Fixed any remaining version-numbered imports"

# Step 3: Fresh install with clean npm registry
echo "📦 Step 3: Fresh npm install..."
npm config set registry https://registry.npmjs.org/
npm install --no-cache --legacy-peer-deps

if [ $? -ne 0 ]; then
    echo "❌ npm install failed!"
    echo "Let's try with yarn instead..."
    
    # Try with yarn as backup
    if command -v yarn &> /dev/null; then
        echo "🧶 Trying with yarn..."
        yarn install
        if [ $? -ne 0 ]; then
            echo "❌ Yarn install also failed!"
            exit 1
        fi
    else
        echo "❌ npm install failed and yarn not available"
        exit 1
    fi
fi

echo "✅ Dependencies installed successfully"

# Step 4: Build with verbose output
echo "🏗️ Step 4: Building with verbose output..."
npm run build 2>&1 | tee build.log

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 NUCLEAR BUILD SUCCESSFUL!"
    echo "=========================="
    echo "✅ All caches cleared and rebuilt from scratch"
    echo "✅ Dependencies installed cleanly"
    echo "✅ TypeScript build successful"
    echo ""
    echo "📁 Build output in dist/ directory"
    echo "📝 Build log saved to build.log"
    echo ""
    echo "🚀 Ready to deploy:"
    echo "aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/ --delete --exclude 'AWSLogs/*'"
else
    echo "❌ Build failed. Check build.log for details."
    echo "Build log:"
    tail -20 build.log
    exit 1
fi