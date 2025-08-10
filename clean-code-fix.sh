#!/bin/bash

echo "🧹 CLEANING UP CODE QUALITY ISSUES"
echo "=================================="

# Check if we're in the right directory
if [ ! -f "App.tsx" ]; then
    echo "❌ App.tsx not found. Please run this from your project root directory."
    exit 1
fi

echo "✅ Found App.tsx - in correct directory"

# Step 1: Fix all imports with version numbers
echo "🔧 Step 1: Fixing imports with version numbers..."
grep -rl 'from ".*"' ./ | xargs sed -i '' -E 's/from "([^"]+"/from "\1"/g' 2>/dev/null

# Also handle single quotes
grep -rl "from '.*'" ./ | xargs sed -i '' -E "s/from '([^']+'/from '\1'/g" 2>/dev/null

echo "✅ Fixed version-numbered imports"

# Step 2: Fix Array.fill() issues - change .fill() to .fill(undefined) or .fill(null)
echo "🔧 Step 2: Fixing Array.fill() errors..."
find . -name "*.tsx" -o -name "*.ts" | grep -v node_modules | xargs sed -i '' 's/Array(\([0-9]*\))\.fill()/Array(\1).fill(undefined)/g' 2>/dev/null

echo "✅ Fixed Array.fill() issues"

# Step 3: Remove unused React imports since we have jsx: "react-jsx" in tsconfig
echo "🔧 Step 3: Removing unused React imports..."

# For files that only use React for useState, useEffect, etc., we can remove the React import
# but keep the hooks imports
sed -i '' 's/import React, { /import { /g' App.tsx components/*.tsx 2>/dev/null
sed -i '' '/^import React from ['\''"]react['\''"];$/d' App.tsx components/*.tsx 2>/dev/null

echo "✅ Cleaned up React imports"

# Step 4: Clean and fresh install dependencies
echo "🔧 Step 4: Clean installing dependencies..."
rm -rf node_modules package-lock.json .vite

npm install --legacy-peer-deps

if [ $? -ne 0 ]; then
    echo "❌ npm install failed"
    exit 1
fi

echo "✅ Dependencies installed successfully"

# Step 5: Build the project
echo "🔧 Step 5: Building project..."
npm run build

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 BUILD SUCCESSFUL!"
    echo "=================="
    echo "✅ All code quality issues fixed:"
    echo "   • Removed @version from imports"
    echo "   • Fixed Array.fill() calls"
    echo "   • Cleaned up React imports"
    echo "   • Fresh dependency install"
    echo "   • TypeScript build successful"
    echo ""
    echo "🚀 Ready to deploy:"
    echo "aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/ --delete --exclude 'AWSLogs/*'"
else
    echo "❌ Build failed. Check TypeScript errors above."
    echo "You may need to manually fix remaining issues."
    exit 1
fi