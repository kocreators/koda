#!/bin/bash
set -e

echo "🧪 TESTING FIXED STYLING"
echo "========================"

if [ ! -f "package.json" ]; then
    echo "❌ Not in project directory"
    exit 1
fi

echo "✅ Found project directory"

# Check component has CSS styles instead of Tailwind utilities
echo ""
echo "🔍 Checking component styling approach..."
if grep -q "background: 'linear-gradient" components/DesignPromptBuilder.tsx; then
    echo "✅ Component uses CSS custom properties (will work!)"
else
    echo "❌ Component still uses Tailwind utilities (won't work with v4 beta)"
    exit 1
fi

if grep -q "var(--primary)" components/DesignPromptBuilder.tsx; then
    echo "✅ Component uses your CSS variables"
else
    echo "⚠️  Component not using CSS variables"
fi

# Test build
echo ""
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
echo "🎨 You should now see:"
echo "  ✨ Beautiful gradient background (light to dark gray)"
echo "  ✨ White card with shadow and backdrop blur"
echo "  ✨ Green 'CREATE YOUR DESIGN' title with gradient"
echo "  ✨ Professional styled buttons and inputs"
echo "  ✨ Smooth hover effects"
echo ""
echo "✅ If styling looks perfect, press Ctrl+C and deploy!"
echo "❌ If still basic, there's another issue to investigate"

npm run dev