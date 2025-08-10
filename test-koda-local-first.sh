#!/bin/bash

echo "🧪 TESTING KODA LOCALLY FIRST"
echo "============================="

echo "🔍 Quick verification..."

# Check CSS import
if grep -q '@import "tailwindcss"' styles/globals.css; then
    echo "✅ Tailwind import found"
else
    echo "❌ Missing Tailwind import"
    exit 1
fi

# Check koda classes
if grep -q "\.koda-title" styles/globals.css; then
    echo "✅ Koda classes found"
else
    echo "❌ Missing Koda classes"
    exit 1
fi

# Check for conflicts
if [ -f "tailwind.config.ts" ]; then
    echo "⚠️ Tailwind config exists (will be removed on deploy)"
else
    echo "✅ No config conflicts"
fi

echo ""
echo "🔨 Building locally..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Local build successful!"
    echo ""
    echo "🚀 Ready to deploy:"
    echo "   chmod +x deploy-working-koda-now.sh"
    echo "   ./deploy-working-koda-now.sh"
else
    echo "❌ Local build failed"
    echo "Check the error above and fix before deploying"
    exit 1
fi