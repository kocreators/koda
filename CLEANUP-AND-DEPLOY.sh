#!/bin/bash
set -e

echo "🎯 CLEANUP AND DEPLOY - USING ONLY GLOBALS.CSS"
echo "=============================================="

echo "✅ WHAT I'M DOING:"
echo "   - main.tsx now only imports globals.css (which has all your styles)"
echo "   - Removing unnecessary koda-components.css file"
echo "   - Clean deployment"

# Remove the unnecessary koda-components.css file
if [ -f "styles/koda-components.css" ]; then
    rm styles/koda-components.css
    echo "   ✅ Removed unnecessary koda-components.css"
fi

# Clean and deploy
rm -rf dist/ node_modules/.vite/ .vite/
rm -f tailwind.config.* postcss.config.*

npm ci
npm run build
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete --cache-control "no-cache, no-store, must-revalidate"

# Invalidate CloudFront
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?DefaultRootObject=='index.html'].Id" --output text 2>/dev/null || echo "")
if [ ! -z "$DISTRIBUTION_ID" ]; then
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*"
fi

echo ""
echo "🎉 CLEANUP COMPLETE - YOUR BEAUTIFUL CSS WILL NOW LOAD!"
echo "🌐 https://koda.kocreators.com"
echo ""
echo "🔥 Hard refresh browser: Ctrl+Shift+R"