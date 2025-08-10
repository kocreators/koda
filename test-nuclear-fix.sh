#!/bin/bash
set -e

echo "🧪 TESTING NUCLEAR STYLING FIX LOCALLY"
echo "======================================"
echo ""

# Kill existing dev servers
pkill -f "vite\|npm.*dev" 2>/dev/null || true
sleep 1

# Clean build
rm -rf dist/ node_modules/.vite/ 2>/dev/null || true

echo "🔨 Testing build..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed - check errors above"
    exit 1
fi

echo "✅ Build successful!"
echo ""
echo "🌐 Starting local test server..."
echo ""
echo "📍 Open http://localhost:8080"
echo ""
echo "✨ You should immediately see:"
echo "  🎨 Beautiful gradient background (light to dark gray)"
echo "  💚 Green gradient 'CREATE YOUR DESIGN' title with underline"
echo "  🤍 Professional white card with glass/blur effect"
echo "  🔘 Style buttons that turn green when selected"
echo "  📝 Clean input fields with green focus effects"
echo "  ✨ Button hover animations and transforms"
echo ""
echo "💣 This uses embedded styles - NO external CSS dependencies!"
echo "🎯 If this works locally, run: ./nuclear-styling-fix.sh to deploy"
echo ""
echo "🚨 Press Ctrl+C to stop testing"

npm run dev
EOF

chmod +x test-nuclear-fix.sh

echo ""
echo "🧪 TEST NUCLEAR FIX LOCALLY FIRST:"
echo "   ./test-nuclear-fix.sh"
echo ""
echo "🚀 IF LOCAL TEST LOOKS PERFECT, DEPLOY:"
echo "   ./nuclear-styling-fix.sh"