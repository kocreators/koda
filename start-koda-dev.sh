#!/bin/bash

echo "🚀 Starting Koda Development Environment"
echo "========================================"
echo ""

# Check if we're in the right directory
if [ ! -f "App.tsx" ] || [ ! -f "package.json" ]; then
    echo "❌ ERROR: This script must be run from your Koda project directory"
    echo "Current directory: $(pwd)"
    echo ""
    echo "Expected files: App.tsx, package.json"
    echo ""
    echo "Please navigate to your Koda project directory and run:"
    echo "  cd /path/to/your/koda-project"
    echo "  ./start-koda-dev.sh"
    exit 1
fi

echo "✅ Found Koda project files in: $(pwd)"
echo ""

# Clean previous installations
echo "🧹 Cleaning previous installations..."
rm -rf node_modules package-lock.json dist .vite 2>/dev/null

# Install dependencies
echo "📦 Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo ""
    echo "⚠️  Standard install failed, trying with legacy peer deps..."
    npm install --legacy-peer-deps
    
    if [ $? -ne 0 ]; then
        echo ""
        echo "❌ Installation failed. Please check errors above."
        echo ""
        echo "💡 Try these manual fixes:"
        echo "1. Make sure Node.js is installed: node --version"
        echo "2. Clear npm cache: npm cache clean --force"  
        echo "3. Try: sudo npm install"
        exit 1
    fi
fi

echo ""
echo "✅ Dependencies installed successfully!"
echo ""

# Test build quickly
echo "🔨 Testing build configuration..."
npm run build --silent

if [ $? -eq 0 ]; then
    echo "✅ Build test passed!"
else
    echo "⚠️  Build test failed, but continuing with dev mode..."
fi

echo ""
echo "🎉 Setup complete! Starting development server..."
echo ""
echo "Your Koda app will be available at:"
echo "  🌐 http://localhost:5173/koda/"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""
echo "----------------------------------------"

# Start development server
npm run dev