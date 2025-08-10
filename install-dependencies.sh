#!/bin/bash

# Koda Logo Generator - Install Dependencies Script (Updated)
# This script installs all required dependencies with correct versions

echo "🚀 Installing Koda Logo Generator dependencies..."
echo ""

# Check Node.js version
echo "🔍 Checking Node.js version..."
node_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$node_version" -lt 18 ]; then
    echo "❌ Node.js 18+ is required. Current version: $(node -v)"
    echo "Please upgrade Node.js to version 18 or higher."
    exit 1
fi

echo "✅ Node.js version $(node -v) is compatible"
echo ""

# Clean up first
echo "🧹 Cleaning up old installations..."
rm -rf node_modules
rm -f package-lock.json
rm -f yarn.lock

# Clear npm cache
echo "🗑️  Clearing npm cache..."
npm cache clean --force

# Install all dependencies
echo "📦 Installing all dependencies..."
npm install

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ All dependencies installed successfully!"
    echo ""
    echo "🔧 Next steps:"
    echo "1. Run 'npm run build' to test TypeScript compilation"
    echo "2. Run 'npm run dev' to start development server"
    echo "3. Run './deploy-koda-subdirectory.sh' to deploy"
    echo ""
else
    echo ""
    echo "❌ Some dependencies failed to install. Trying alternative approaches..."
    echo ""
    
    echo "🔄 Trying with --legacy-peer-deps..."
    npm install --legacy-peer-deps
    
    if [ $? -eq 0 ]; then
        echo "✅ Dependencies installed with legacy peer deps!"
    else
        echo ""
        echo "🔄 Trying with --force..."
        npm install --force
        
        if [ $? -eq 0 ]; then
            echo "✅ Dependencies installed with force flag!"
        else
            echo ""
            echo "❌ Installation failed with all methods."
            echo "💡 Manual steps to try:"
            echo "   1. Update Node.js to the latest LTS version"
            echo "   2. Run: npm install --legacy-peer-deps"
            echo "   3. Or run: npm install --force"
            exit 1
        fi
    fi
fi

echo ""
echo "🎯 Testing build..."
npm run build

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Everything is working! Your Koda Logo Generator is ready to deploy."
else
    echo ""
    echo "⚠️  Build test failed. Check for any remaining TypeScript errors."
fi