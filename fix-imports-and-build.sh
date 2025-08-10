#!/bin/bash

echo "🔧 Fixing versioned imports in UI components..."

# Navigate to the project directory if not already there
if [ ! -f "package.json" ]; then
    echo "⚠️  Not in project directory. Looking for project..."
    if [ -d "~/koda-project" ]; then
        cd ~/koda-project
        echo "✅ Found project at ~/koda-project"
    else
        echo "❌ Could not find project directory"
        exit 1
    fi
fi

# Backup components directory
echo "📦 Creating backup of components directory..."
cp -r components components_backup_$(date +%Y%m%d_%H%M%S)

# Fix versioned imports in all UI components
echo "🔧 Removing version numbers from imports..."

# Create a function to fix imports in a file
fix_file_imports() {
    local file="$1"
    echo "  📝 Fixing imports in $file"
    
    # Remove version numbers from @radix-ui imports
    sed -i 's/@radix-ui\/react-[^@]*@[0-9]\+\.[0-9]\+\.[0-9]\+/@radix-ui\/react-\1/g' "$file" 2>/dev/null || \
    sed -i.bak 's/@radix-ui\/react-\([^@]*\)@[0-9]\+\.[0-9]\+\.[0-9]\+/@radix-ui\/react-\1/g' "$file" && rm -f "$file.bak"
    
    # Remove version numbers from other versioned imports
    sed -i 's/@\([^/]*\)@[0-9]\+\.[0-9]\+\.[0-9]\+/@\1/g' "$file" 2>/dev/null || \
    sed -i.bak 's/@\([^/]*\)@[0-9]\+\.[0-9]\+\.[0-9]\+/@\1/g' "$file" && rm -f "$file.bak"
    
    # Fix specific common versioned imports
    sed -i 's/sonner@[0-9]\+\.[0-9]\+\.[0-9]\+/sonner/g' "$file" 2>/dev/null || \
    sed -i.bak 's/sonner@[0-9]\+\.[0-9]\+\.[0-9]\+/sonner/g' "$file" && rm -f "$file.bak"
    
    sed -i 's/react-hook-form@[0-9]\+\.[0-9]\+\.[0-9]\+/react-hook-form/g' "$file" 2>/dev/null || \
    sed -i.bak 's/react-hook-form@[0-9]\+\.[0-9]\+\.[0-9]\+/react-hook-form/g' "$file" && rm -f "$file.bak"
}

# Fix all TypeScript files in components directory
find components -name "*.tsx" -o -name "*.ts" | while read -r file; do
    fix_file_imports "$file"
done

# Also fix main component files
for file in App.tsx main.tsx; do
    if [ -f "$file" ]; then
        fix_file_imports "$file"
    fi
done

echo "✅ Import fixes completed!"

# Clean up any existing build artifacts
echo "🧹 Cleaning up build artifacts..."
rm -rf dist node_modules/.vite

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build the project
echo "🔨 Building project..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ BUILD SUCCESS! Your project built successfully!"
    echo ""
    echo "🚀 Next steps:"
    echo "1. Deploy to S3: aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete"
    echo "2. Invalidate CloudFront: aws cloudfront create-invalidation --distribution-id YOUR_DISTRIBUTION_ID --paths '/*'"
    echo ""
    echo "Your Koda logo generator is ready for deployment!"
else
    echo "❌ Build failed. Check the error messages above."
    echo "If you see any remaining versioned imports, run this script again."
    exit 1
fi