#!/bin/bash

echo "🔍 CHECKING YOUR KODA SOURCE FILES"
echo "================================="

# Check for essential source files
echo "📁 Essential Source Files:"
echo -n "App.tsx: "
if [ -f "App.tsx" ]; then echo "✅ Found"; else echo "❌ Missing"; fi

echo -n "package.json: "
if [ -f "package.json" ]; then echo "✅ Found"; else echo "❌ Missing"; fi

echo -n "main.tsx: "
if [ -f "main.tsx" ]; then echo "✅ Found"; else echo "❌ Missing"; fi

echo -n "vite.config.ts: "
if [ -f "vite.config.ts" ]; then echo "✅ Found"; else echo "❌ Missing"; fi

echo ""
echo "📁 Components:"
echo -n "components/ directory: "
if [ -d "components" ]; then echo "✅ Found"; else echo "❌ Missing"; fi

echo -n "DesignPromptBuilder.tsx: "
if [ -f "components/DesignPromptBuilder.tsx" ]; then echo "✅ Found"; else echo "❌ Missing"; fi

echo -n "LogoGenerator.tsx: "
if [ -f "components/LogoGenerator.tsx" ]; then echo "✅ Found"; else echo "❌ Missing"; fi

echo -n "PricingChatbot.tsx: "
if [ -f "components/PricingChatbot.tsx" ]; then echo "✅ Found"; else echo "❌ Missing"; fi

echo ""
echo "📁 Styles:"
echo -n "styles/globals.css: "
if [ -f "styles/globals.css" ]; then echo "✅ Found"; else echo "❌ Missing"; fi

echo ""
echo "📁 Types:"
echo -n "types/index.ts: "
if [ -f "types/index.ts" ]; then echo "✅ Found"; else echo "❌ Missing"; fi

echo ""
echo "🚀 BUILD AND DEPLOY COMMAND:"
echo "npm install && npm run build && aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/koda/ --delete"

echo ""
echo "🌐 TEST URL AFTER DEPLOYMENT:"
echo "https://d3d8ucpm7p01n7.cloudfront.net/koda/"