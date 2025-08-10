#!/bin/bash

echo "🔍 Finding your Koda project..."
echo ""

# Find the project directory that contains App.tsx and package.json
PROJECT_DIR=$(find ~ -name "App.tsx" -type f 2>/dev/null | while read file; do
    dir=$(dirname "$file")
    if [ -f "$dir/package.json" ]; then
        echo "$dir"
        break
    fi
done)

if [ -z "$PROJECT_DIR" ]; then
    echo "❌ Could not find your Koda project directory"
    echo ""
    echo "Please manually locate the directory that contains:"
    echo "- App.tsx"
    echo "- package.json"
    echo "- components/ folder"
    echo ""
    echo "Then run these commands:"
    echo "  cd /path/to/your/project"
    echo "  npm install"
    echo "  npm run dev"
    exit 1
fi

echo "✅ Found your project at: $PROJECT_DIR"
echo ""

# Navigate to project directory
cd "$PROJECT_DIR"

echo "📁 Current directory: $(pwd)"
echo ""

# Verify we have the right files
if [ ! -f "package.json" ]; then
    echo "❌ package.json not found in $PROJECT_DIR"
    exit 1
fi

if [ ! -f "App.tsx" ]; then
    echo "❌ App.tsx not found in $PROJECT_DIR"
    exit 1
fi

echo "✅ Verified project files:"
ls -la package.json App.tsx
echo ""

# Clean and install
echo "🧹 Cleaning previous installations..."
rm -rf node_modules package-lock.json dist .vite 2>/dev/null

echo ""
echo "📦 Installing dependencies..."
npm install

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Dependencies installed successfully!"
    echo ""
    echo "🚀 Starting development server..."
    echo "Your app will be available at: http://localhost:5173/koda/"
    echo ""
    echo "Press Ctrl+C to stop the server"
    echo "----------------------------------------"
    
    npm run dev
else
    echo ""
    echo "⚠️ Standard install failed, trying with legacy peer deps..."
    npm install --legacy-peer-deps
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Installed with legacy peer deps!"
        echo "🚀 Starting development server..."
        npm run dev
    else
        echo ""
        echo "❌ Installation failed. Manual troubleshooting needed."
        echo ""
        echo "You are now in your project directory: $(pwd)"
        echo "Try these commands manually:"
        echo "  npm cache clean --force"
        echo "  npm install --legacy-peer-deps"
        echo "  npm run dev"
    fi
fi