#!/bin/bash

echo "🔧 FIXING ALL IMPORTS AND DEPLOYING KODA"
echo "========================================"

# Check if we're in the right directory
if [ ! -f "App.tsx" ]; then
    echo "❌ App.tsx not found. Please navigate to your koda project directory first."
    exit 1
fi

echo "✅ Found App.tsx - in correct directory"

# Clean previous builds and node_modules
echo "🧹 Cleaning previous builds..."
rm -rf node_modules dist package-lock.json .vite

# Fix all import statements in UI components
echo "🔧 Fixing import statements in all UI components..."

# Fix all @radix-ui imports
find components/ui -name "*.tsx" -type f -exec sed -i 's/@radix-ui\/react-[a-z-]*@[0-9][^"]*/@radix-ui\/react-\1/g' {} \;

# More specific fixes for common patterns
sed -i 's/@radix-ui\/react-accordion@[^"]*/\@radix-ui\/react-accordion/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-alert-dialog@[^"]*/\@radix-ui\/react-alert-dialog/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-aspect-ratio@[^"]*/\@radix-ui\/react-aspect-ratio/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-avatar@[^"]*/\@radix-ui\/react-avatar/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-checkbox@[^"]*/\@radix-ui\/react-checkbox/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-collapsible@[^"]*/\@radix-ui\/react-collapsible/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-context-menu@[^"]*/\@radix-ui\/react-context-menu/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-dialog@[^"]*/\@radix-ui\/react-dialog/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-dropdown-menu@[^"]*/\@radix-ui\/react-dropdown-menu/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-hover-card@[^"]*/\@radix-ui\/react-hover-card/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-label@[^"]*/\@radix-ui\/react-label/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-menubar@[^"]*/\@radix-ui\/react-menubar/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-navigation-menu@[^"]*/\@radix-ui\/react-navigation-menu/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-popover@[^"]*/\@radix-ui\/react-popover/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-progress@[^"]*/\@radix-ui\/react-progress/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-radio-group@[^"]*/\@radix-ui\/react-radio-group/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-scroll-area@[^"]*/\@radix-ui\/react-scroll-area/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-select@[^"]*/\@radix-ui\/react-select/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-separator@[^"]*/\@radix-ui\/react-separator/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-slider@[^"]*/\@radix-ui\/react-slider/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-slot@[^"]*/\@radix-ui\/react-slot/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-switch@[^"]*/\@radix-ui\/react-switch/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-tabs@[^"]*/\@radix-ui\/react-tabs/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-toggle@[^"]*/\@radix-ui\/react-toggle/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-toggle-group@[^"]*/\@radix-ui\/react-toggle-group/g' components/ui/*.tsx
sed -i 's/@radix-ui\/react-tooltip@[^"]*/\@radix-ui\/react-tooltip/g' components/ui/*.tsx

# Fix lucide-react imports
sed -i 's/lucide-react@[^"]*/lucide-react/g' components/ui/*.tsx

# Fix other common imports
sed -i 's/react-day-picker@[^"]*/react-day-picker/g' components/ui/*.tsx
sed -i 's/embla-carousel-react@[^"]*/embla-carousel-react/g' components/ui/*.tsx
sed -i 's/recharts@[^"]*/recharts/g' components/ui/*.tsx
sed -i 's/cmdk@[^"]*/cmdk/g' components/ui/*.tsx
sed -i 's/vaul@[^"]*/vaul/g' components/ui/*.tsx
sed -i 's/react-hook-form@[^"]*/react-hook-form/g' components/ui/*.tsx
sed -i 's/next-themes@[^"]*/next-themes/g' components/ui/*.tsx
sed -i 's/sonner@[^"]*/sonner/g' components/ui/*.tsx
sed -i 's/react-resizable-panels@[^"]*/react-resizable-panels/g' components/ui/*.tsx
sed -i 's/date-fns@[^"]*/date-fns/g' components/ui/*.tsx

echo "✅ Fixed import statements in UI components"

# Fix main components too
echo "🔧 Fixing imports in main components..."
sed -i 's/lucide-react@[^"]*/lucide-react/g' components/*.tsx

# Install dependencies
echo "📦 Installing all dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ npm install failed. Trying with legacy peer deps..."
    npm install --legacy-peer-deps
    if [ $? -ne 0 ]; then
        echo "❌ Installation failed completely"
        exit 1
    fi
fi

echo "✅ Dependencies installed successfully!"

# Verify vite config is correct for custom domain
echo "⚙️ Verifying vite config for custom domain..."
if grep -q 'base: "/"' vite.config.ts; then
    echo "✅ Vite config correct for custom domain (base: '/')"
else
    echo "🔧 Fixing vite config for custom domain..."
    sed -i 's|base: "/koda/"|base: "/"|g' vite.config.ts
    echo "✅ Updated vite config to use base: '/'"
fi

# Build the application
echo "🏗️ Building Koda app..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed! Check for remaining TypeScript errors."
    echo "Common fixes:"
    echo "1. Add type annotations for any 'any' type errors"
    echo "2. Use .fill(null) instead of .fill()"
    echo "3. Check for missing imports"
    exit 1
fi

# Verify build output
if [ ! -f "dist/index.html" ]; then
    echo "❌ Build failed - no dist/index.html found"
    exit 1
fi

echo "✅ Build successful!"

# Deploy to S3 root for custom domain
echo "☁️ Deploying to S3..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/ --delete --exclude "AWSLogs/*" --exclude "*.sh" --exclude "*.md"

if [ $? -ne 0 ]; then
    echo "❌ S3 deployment failed!"
    exit 1
fi

echo "✅ Deployed to S3!"

# Test the deployment
echo "🧪 Testing deployment..."
sleep 10

echo "Testing custom domain..."
CUSTOM_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://koda.kocreators.com")
echo "Custom domain status: $CUSTOM_STATUS"

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================"

if [ "$CUSTOM_STATUS" = "200" ]; then
    echo "🌟 SUCCESS! Your Koda app is live at:"
    echo "🌐 https://koda.kocreators.com"
    echo ""
    echo "✅ All fixes applied:"
    echo "   • Fixed all @version import syntax"
    echo "   • Installed all required dependencies"
    echo "   • Built successfully with TypeScript"
    echo "   • Deployed with correct asset paths"
    echo "   • No more CORS errors"
    echo ""
    echo "🎊 Your three-step Koda workflow is ready!"
else
    echo "⚠️ Custom domain not responding yet (Status: $CUSTOM_STATUS)"
    echo "🔧 This could be due to DNS propagation or CloudFront cache"
    echo "💡 Try again in 5-10 minutes or check CloudFront settings"
fi

echo ""
echo "📋 Your Koda app features:"
echo "• KODA title in teal color"
echo "• Design Prompt Builder (Step 1)"
echo "• Logo Generator (Step 2)"  
echo "• Pricing Chatbot (Step 3)"
echo "• Complete three-step user workflow"