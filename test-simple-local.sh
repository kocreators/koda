#!/bin/bash
set -e

echo "🧪 SIMPLE LOCAL TEST"
echo "==================="

echo "🔍 Checking your perfect setup..."

if [ ! -f "index.html" ]; then
    echo "❌ index.html missing"
    exit 1
fi

if [ ! -f "main.tsx" ]; then
    echo "❌ main.tsx missing"
    exit 1
fi

if [ ! -f "styles/globals.css" ]; then
    echo "❌ globals.css missing"
    exit 1
fi

if grep -q "koda-title" styles/globals.css; then
    echo "✅ Found your beautiful .koda-title class"
else
    echo "❌ .koda-title class missing"
    exit 1
fi

echo "✅ All files present and correct!"

echo ""
echo "🔨 Building locally..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ Build successful!"

echo ""
echo "🚀 Starting dev server..."
echo "🌐 Test at: http://localhost:8080"
echo ""

npm run dev