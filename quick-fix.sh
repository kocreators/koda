#!/bin/bash

# Quick dependency fix for Koda Logo Generator
echo "🔧 Quick fix for Koda dependencies..."

# Clean slate
rm -rf node_modules package-lock.json
npm cache clean --force

# Install with legacy peer deps (most likely to work)
echo "📦 Installing with legacy peer deps..."
npm install --legacy-peer-deps

if [ $? -eq 0 ]; then
    echo "✅ Installation successful!"
    
    # Test build
    echo "🔨 Testing build..."
    npm run build
    
    if [ $? -eq 0 ]; then
        echo "🎉 Everything works! You can now run:"
        echo "   npm run dev     (development server)"
        echo "   npm run preview (test built version)"
        echo "   npm run build   (build for production)"
    else
        echo "⚠️  Install worked but build failed. Check for TypeScript errors."
    fi
else
    echo "❌ Quick fix failed. Try running: ./fix-dependencies.sh"
fi