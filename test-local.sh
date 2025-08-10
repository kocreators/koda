#!/bin/bash

# Quick local test script
echo "🧪 Testing Koda locally..."

# Build the project
echo "Building..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "🌐 Starting local server..."
    echo "Visit: http://localhost:8000/koda/"
    echo "Press Ctrl+C to stop"
    echo ""
    cd dist && python3 -m http.server 8000
else
    echo "❌ Build failed - check errors above"
fi