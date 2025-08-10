#!/bin/bash

echo "🔍 VERIFYING KODA IS READY TO DEPLOY"
echo "===================================="

echo "🎯 Checking CSS setup..."

if [ -f "styles/globals.css" ]; then
    echo "✅ CSS file found at styles/globals.css"
    
    if grep -q '@import "tailwindcss"' styles/globals.css; then
        echo "✅ Tailwind v4 import found"
    else
        echo "❌ Missing Tailwind import"
        exit 1
    fi
    
    if grep -q '\.koda-title' styles/globals.css; then
        echo "✅ Koda styling classes found"
    else
        echo "❌ Missing Koda classes"
        exit 1
    fi
    
    if grep -q 'var(--kocreators-primary)' styles/globals.css; then
        echo "✅ Kocreators branding found"
    else
        echo "❌ Missing branding"
        exit 1
    fi
else
    echo "❌ CSS file not found"
    exit 1
fi

echo ""
echo "🔍 Checking for conflicts..."

if [ -f "tailwind.config.ts" ]; then
    echo "⚠️  CONFLICT: tailwind.config.ts exists (will be removed on deploy)"
else
    echo "✅ No config conflicts"
fi

echo ""
echo "🔍 Checking components..."

if [ -f "App.tsx" ]; then
    echo "✅ App.tsx found"
else
    echo "❌ App.tsx missing"
    exit 1
fi

if [ -f "components/DesignPromptBuilder.tsx" ]; then
    echo "✅ DesignPromptBuilder component found"
else
    echo "❌ DesignPromptBuilder missing"
    exit 1
fi

echo ""
echo "🎉 KODA IS READY TO DEPLOY!"
echo "========================="
echo ""
echo "🚀 Run deployment:"
echo "   chmod +x deploy-koda-final-working.sh"
echo "   ./deploy-koda-final-working.sh"
echo ""
echo "💡 This will:"
echo "   • Remove conflicting tailwind.config.ts"
echo "   • Build with v4 zero-config"
echo "   • Deploy your beautiful design"
echo "   • Show massive gradient title"
echo "   • Display glass-effect cards"