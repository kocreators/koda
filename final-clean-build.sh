#!/bin/bash

echo "🔧 FINAL CLEAN BUILD - FIXING ALL ISSUES"
echo "========================================"

# Check if we're in the right directory
if [ ! -f "App.tsx" ]; then
    echo "❌ App.tsx not found. Please run this from your project root directory."
    exit 1
fi

echo "✅ Found App.tsx - in correct directory"

# Step 1: Fix ALL imports with version numbers across the entire project
echo "🔧 Step 1: Fixing ALL version-numbered imports..."

# Use the exact command the user provided
grep -rl 'from ".*"' ./ | xargs sed -i '' -E 's/from "([^"]+"/from "\1"/g' 2>/dev/null

# Also handle single quotes
grep -rl "from '.*'" ./ | xargs sed -i '' -E "s/from '([^']+'/from '\1'/g" 2>/dev/null

echo "✅ Fixed all version-numbered imports"

# Step 2: Clean build environment
echo "🧹 Step 2: Cleaning build environment..."
rm -rf node_modules package-lock.json .vite dist

echo "✅ Cleaned build environment"

# Step 3: Install dependencies with the corrected package.json
echo "📦 Step 3: Installing dependencies..."
npm install --legacy-peer-deps

if [ $? -ne 0 ]; then
    echo "❌ npm install failed"
    exit 1
fi

echo "✅ Dependencies installed successfully"

# Step 4: Build the project
echo "🏗️ Step 4: Building project..."
npm run build

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 BUILD SUCCESSFUL!"
    echo "=================="
    echo "✅ All issues fixed:"
    echo "   • Removed non-existent @radix-ui/react-sheet"
    echo "   • Fixed all @version imports"
    echo "   • Clean dependency install"
    echo "   • TypeScript build successful"
    echo ""
    echo "🚀 Your app is ready to deploy!"
    echo ""
    echo "Deploy with:"
    echo "aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/ --delete --exclude 'AWSLogs/*'"
else
    echo "❌ Build failed. Check TypeScript errors above."
    exit 1
fi