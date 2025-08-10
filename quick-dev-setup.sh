#!/bin/bash

echo "🚀 Quick Koda Development Setup"
echo "================================"
echo ""

# Check if we're in the right place
if [ ! -f "App.tsx" ]; then
    echo "❌ App.tsx not found. Are you in your Koda project directory?"
    echo "Current directory: $(pwd)"
    echo "Please navigate to your Koda project directory and try again."
    exit 1
fi

echo "✅ Found Koda project files"
echo ""

# Clean and install
echo "🧹 Cleaning previous installations..."
rm -rf node_modules package-lock.json dist .vite 2>/dev/null

echo "📦 Installing dependencies..."
npm install

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed!"
    
    echo "🔨 Testing build..."
    npm run build
    
    if [ $? -eq 0 ]; then
        echo "✅ Build successful!"
        echo ""
        echo "🎉 Setup complete! Starting development server..."
        echo ""
        echo "Your app will open at: http://localhost:5173/koda/"
        echo "Press Ctrl+C to stop the server"
        echo ""
        
        # Start dev server
        npm run dev
    else
        echo "⚠️ Build had issues, but trying dev mode anyway..."
        npm run dev
    fi
else
    echo "❌ Installation failed. Trying with legacy peer deps..."
    npm install --legacy-peer-deps
    
    if [ $? -eq 0 ]; then
        echo "✅ Installed with legacy peer deps!"
        npm run dev
    else
        echo "❌ Installation still failed. Please check the errors above."
        exit 1
    fi
fi