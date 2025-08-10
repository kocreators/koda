#!/bin/bash
set -e

echo "🚀 FIXING KODA AND DEPLOYING NOW"
echo "==============================="

# Remove conflicting config
rm -f tailwind.config.ts tailwind.config.js tailwind.config.cjs
echo "✅ Removed conflicting Tailwind configs"

# Clean and build
rm -rf dist/
npm run build
echo "✅ Built successfully"

# Deploy
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete
echo "✅ Deployed to S3"

echo ""
echo "🎉 DONE! https://koda.kocreators.com"
echo "Your beautiful Kocreators design is live!"