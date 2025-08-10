#!/bin/bash
set -e

echo "🧪 TESTING LOCALLY"
echo "================="

# Kill any existing dev servers
pkill -f "vite\|npm.*dev" 2>/dev/null || true
sleep 1

# Clean build
rm -rf dist/ node_modules/.vite/ 2>/dev/null || true

echo "🔨 Building for test..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed - installing dependencies..."
    npm install
    npm run build
    if [ $? -ne 0 ]; then
        echo "❌ Build still failed"
        exit 1
    fi
fi

echo "✅ Build successful!"
echo ""
echo "🌐 Starting development server..."
echo "📍 Open http://localhost:8080"
echo ""
echo "✨ You should see beautiful Kocreators styling!"
echo "🚨 Press Ctrl+C to stop testing"

npm run dev