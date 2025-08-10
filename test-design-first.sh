#!/bin/bash
set -e

echo "🧪 TESTING KODA DESIGN LOCALLY"
echo "==============================="

if [ ! -f "package.json" ]; then
    echo "❌ Not in project directory"
    exit 1
fi

echo "✅ Found project files"

# Quick build test
echo ""
echo "🔨 Testing build..."
npm run build >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Build successful"
else
    echo "❌ Build failed - check for errors"
    exit 1
fi

# Check for styling in component
echo ""
echo "🎨 Checking component styling..."
if grep -q "background: 'linear-gradient" components/DesignPromptBuilder.tsx; then
    echo "✅ Inline styles found (bulletproof)"
else
    echo "⚠️  No inline styles - relying on Tailwind only"
fi

if grep -q "bg-gradient-to-br" components/DesignPromptBuilder.tsx; then
    echo "✅ Tailwind classes found"
else
    echo "⚠️  No Tailwind classes"
fi

# Check CSS output
CSS_FILES=(dist/assets/*.css)
if [ ${#CSS_FILES[@]} -gt 0 ] && [ -f "${CSS_FILES[0]}" ]; then
    CSS_SIZE=$(wc -c < "${CSS_FILES[0]}")
    echo "✅ CSS generated: $CSS_SIZE bytes"
    
    if grep -q "koda-title" "${CSS_FILES[0]}"; then
        echo "✅ Custom CSS included"
    else
        echo "⚠️  Custom CSS missing"
    fi
else
    echo "❌ No CSS files generated!"
    exit 1
fi

echo ""
echo "🚀 Starting local test server..."
echo "📍 Open http://localhost:8080 in your browser"
echo ""
echo "🔍 You should see:"
echo "  ✅ Gradient background (light gray to darker gray)"
echo "  ✅ White card with shadow in the center"
echo "  ✅ Green 'CREATE YOUR DESIGN' title"
echo "  ✅ Professional form styling"
echo "  ✅ Styled buttons that respond to hover"
echo ""
echo "👀 If the design looks good, press Ctrl+C and run:"
echo "   ./final-bulletproof-deploy.sh"
echo ""
echo "🚨 If it looks basic/unstyled, there's still a config issue"

npm run dev