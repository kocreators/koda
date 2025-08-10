#!/bin/bash

echo "🔍 Finding your Koda project..."

# Find the directory containing App.tsx
PROJECT_DIR=$(find ~ -name "App.tsx" -type f 2>/dev/null | head -1 | xargs dirname)

if [ -z "$PROJECT_DIR" ]; then
    echo "❌ Could not find App.tsx file. Let's search more broadly..."
    echo "Looking for any directory with package.json that might be your project:"
    find ~ -name "package.json" -type f 2>/dev/null
    exit 1
fi

echo "✅ Found your project at: $PROJECT_DIR"
echo "📁 Navigating to your project directory..."

cd "$PROJECT_DIR"

echo "🎯 You are now in: $(pwd)"
echo ""
echo "📋 Files in your project directory:"
ls -la

echo ""
echo "🚀 Ready to run deployment commands!"
echo ""
echo "Next steps:"
echo "1. npm install"
echo "2. npm run build" 
echo "3. aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/koda/ --delete"
echo ""
echo "💡 TIP: You can run this script again anytime by typing:"
echo "bash auto-navigate-to-project.sh"