#!/bin/bash

echo "🔧 FIXING VERSIONED IMPORTS IN UI COMPONENTS"
echo "============================================"

# Fix all versioned imports in components/ui directory
echo "📁 Fixing imports in components/ui/*.tsx files..."

# List of all the problematic imports from the error output
declare -a imports=(
    "@radix-ui/react-alert-dialog"
    "@radix-ui/react-aspect-ratio" 
    "@radix-ui/react-avatar"
    "@radix-ui/react-slot"
    "@radix-ui/react-checkbox"
    "@radix-ui/react-collapsible"
    "@radix-ui/react-context-menu"
    "@radix-ui/react-dropdown-menu"
    "@radix-ui/react-label"
    "@radix-ui/react-hover-card"
    "@radix-ui/react-menubar"
    "@radix-ui/react-navigation-menu"
    "@radix-ui/react-popover"
    "@radix-ui/react-radio-group"
    "@radix-ui/react-scroll-area"
    "@radix-ui/react-select"
    "@radix-ui/react-separator"
    "@radix-ui/react-dialog"
    "@radix-ui/react-slider"
    "@radix-ui/react-switch"
    "@radix-ui/react-tabs"
    "@radix-ui/react-toggle-group"
    "@radix-ui/react-toggle"
    "@radix-ui/react-tooltip"
)

# Fix each import by removing version numbers
for import in "${imports[@]}"; do
    echo "  🔧 Fixing ${import}..."
    # Use sed to replace versioned imports with unversioned ones
    find components/ui -name "*.tsx" -exec sed -i.bak "s|${import}@[0-9][0-9.]*|${import}|g" {} \;
done

# Also fix input-otp import
echo "  🔧 Fixing input-otp import..."
find components/ui -name "*.tsx" -exec sed -i.bak 's|"input-otp"|"input-otp"|g' {} \;

# Clean up backup files
find components/ui -name "*.bak" -delete

echo "✅ All versioned imports fixed!"

# Verify the fixes worked
echo ""
echo "🔍 Verifying fixes..."
if grep -r "@[0-9]" components/ui/; then
    echo "❌ Still found versioned imports - manual check needed"
else
    echo "✅ No versioned imports found - fixes successful!"
fi

echo ""
echo "🏗️ Now building the project..."
npm run build

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 BUILD SUCCESSFUL!"
    echo "==================="
    echo "✅ All versioned imports fixed"
    echo "✅ TypeScript compilation successful"
    echo "✅ Build completed"
    echo ""
    echo "📁 Build output ready in dist/ directory"
    echo ""
    echo "🚀 Ready to deploy:"
    echo "aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/ --delete --exclude 'AWSLogs/*'"
    echo ""
    echo "🌐 Your app will be live at: https://koda.kocreators.com"
else
    echo ""
    echo "❌ BUILD STILL FAILED"
    echo "===================="
    echo "Check the error output above for remaining issues."
    
    # Show which files still have problems
    echo ""
    echo "🔍 Files that might still have issues:"
    grep -r "Cannot find module" . 2>/dev/null | head -10
fi