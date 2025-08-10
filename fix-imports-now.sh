#!/bin/bash
set -e

echo "🔧 FIXING VERSIONED IMPORTS IN KODA PROJECT"
echo "============================================"

# Make sure we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ package.json not found. Are you in the project directory?"
    exit 1
fi

echo "✅ Found package.json. Starting import fixes..."

# Function to fix a single file
fix_file() {
    local file="$1"
    echo "  📝 Fixing: $file"
    
    # Use perl for more reliable regex replacement
    perl -i -pe '
        # Fix @radix-ui imports
        s/@radix-ui\/react-([^@\s"]+)@[0-9]+\.[0-9]+\.[0-9]+/@radix-ui\/react-$1/g;
        
        # Fix other versioned imports
        s/from\s+"([^@\s"]+)@[0-9]+\.[0-9]+\.[0-9]+"/from "$1"/g;
        s/import\s+([^"]+)\s+from\s+"([^@\s"]+)@[0-9]+\.[0-9]+\.[0-9]+"/import $1 from "$2"/g;
        
        # Fix input-otp specifically
        s/"input-otp@[0-9]+\.[0-9]+\.[0-9]+"/"input-otp"/g;
    ' "$file"
}

# Fix all TypeScript files in components/ui
echo "🔧 Fixing components/ui files..."
for file in components/ui/*.tsx components/ui/*.ts; do
    if [ -f "$file" ]; then
        fix_file "$file"
    fi
done

# Fix main app files
echo "🔧 Fixing main application files..."
for file in App.tsx main.tsx; do
    if [ -f "$file" ]; then
        fix_file "$file"
    fi
done

# Fix any other component files
echo "🔧 Fixing other component files..."
find components -name "*.tsx" -o -name "*.ts" | while read -r file; do
    if [[ "$file" != components/ui/* ]]; then
        fix_file "$file"
    fi
done

echo "✅ All imports fixed!"

# Install missing dependencies
echo "📦 Installing missing dependencies..."
npm install @radix-ui/react-alert-dialog \
           @radix-ui/react-aspect-ratio \
           @radix-ui/react-avatar \
           @radix-ui/react-checkbox \
           @radix-ui/react-collapsible \
           @radix-ui/react-context-menu \
           @radix-ui/react-dialog \
           @radix-ui/react-dropdown-menu \
           @radix-ui/react-hover-card \
           @radix-ui/react-label \
           @radix-ui/react-menubar \
           @radix-ui/react-navigation-menu \
           @radix-ui/react-popover \
           @radix-ui/react-radio-group \
           @radix-ui/react-scroll-area \
           @radix-ui/react-select \
           @radix-ui/react-separator \
           @radix-ui/react-slider \
           @radix-ui/react-slot \
           @radix-ui/react-switch \
           @radix-ui/react-tabs \
           @radix-ui/react-toggle \
           @radix-ui/react-toggle-group \
           @radix-ui/react-tooltip \
           input-otp \
           --save

echo "✅ Dependencies installed!"

# Clean and build
echo "🧹 Cleaning build artifacts..."
rm -rf dist node_modules/.vite

echo "🔨 Building project..."
npm run build

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS! Build completed successfully!"
    echo "========================================="
    echo ""
    echo "Your Koda logo generator is now ready for deployment."
    echo ""
    echo "To deploy to S3, run:"
    echo "  aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete"
    echo ""
else
    echo "❌ Build failed. Check the errors above."
    exit 1
fi