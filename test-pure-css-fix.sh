#!/bin/bash
set -e

echo "🎨 TESTING PURE CSS COMPONENT"
echo "=============================="

# Quick build test
echo "🔨 Testing build..."
npm run build >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Build successful"
else
    echo "❌ Build failed"
    exit 1
fi

echo ""
echo "🚀 Starting test server..."
echo "📍 Open http://localhost:8080"
echo ""
echo "✨ You should now see BEAUTIFUL styling:"
echo "  🎨 Gradient background (light gray to darker gray)"
echo "  🤍 Professional white card with backdrop blur"
echo "  💚 Green gradient 'CREATE YOUR DESIGN' title"
echo "  🔘 Styled buttons that change on hover"
echo "  📝 Clean input fields with focus effects"
echo "  ✨ Smooth animations and shadows"
echo ""
echo "🔥 NO MORE BASIC HTML - PURE CSS BEAUTY!"

npm run dev