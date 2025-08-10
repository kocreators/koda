#!/bin/bash

echo "⚡ QUICK KODA STATUS CHECK"
echo "========================"

# Where are we?
echo "📍 Current location: $(pwd)"

# Do we have the project files?
echo ""
echo "📂 Project files:"
[ -f "App.tsx" ] && echo "✅ App.tsx" || echo "❌ App.tsx missing"
[ -f "package.json" ] && echo "✅ package.json" || echo "❌ package.json missing"
[ -d "components" ] && echo "✅ components/" || echo "❌ components/ missing"
[ -d "dist" ] && echo "✅ dist/" || echo "❌ dist/ missing"

# Test live URLs
echo ""
echo "🌐 Live deployment test:"
echo "CloudFront: $(curl -s -o /dev/null -w "%{http_code}" "https://d3d8ucpm7p01n7.cloudfront.net/koda/")"
echo "S3 Website: $(curl -s -o /dev/null -w "%{http_code}" "http://koda-logo-generator-jordanbremond-2025.s3-website-us-east-1.amazonaws.com/koda/")"

echo ""
echo "🎯 NEXT STEPS:"
if [ -f "App.tsx" ] && [ -f "package.json" ]; then
    echo "✅ You're in the right place!"
    echo "🔨 Run: bash rebuild-and-deploy-koda.sh"
else
    echo "❌ Need to find your project directory"
    echo "🔍 Run: find ~ -name 'App.tsx' -type f 2>/dev/null"
fi