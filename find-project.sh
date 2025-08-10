#!/bin/bash

# Simple script to help find the Koda project directory
echo "🔍 Looking for your Koda project..."
echo ""

# Check common locations for the project
POSSIBLE_LOCATIONS=(
    "$HOME/Desktop/koda"
    "$HOME/Desktop/koda-project" 
    "$HOME/Desktop/koda-logo-generator"
    "$HOME/Documents/koda"
    "$HOME/Documents/koda-project"
    "$HOME/Documents/koda-logo-generator"
    "$HOME/Projects/koda"
    "$HOME/Projects/koda-project"
    "$HOME/koda"
    "$HOME/koda-project"
    "./koda"
    "./koda-project"
)

echo "Checking common locations..."
echo ""

FOUND_PROJECTS=()

for location in "${POSSIBLE_LOCATIONS[@]}"; do
    if [ -d "$location" ]; then
        if [ -f "$location/App.tsx" ] && [ -f "$location/package.json" ]; then
            echo "✅ FOUND: $location"
            FOUND_PROJECTS+=("$location")
        fi
    fi
done

if [ ${#FOUND_PROJECTS[@]} -eq 0 ]; then
    echo "❌ Koda project not found in common locations."
    echo ""
    echo "💡 Try these commands to find it:"
    echo ""
    echo "# Search for App.tsx (your main Koda file)"
    echo "find ~ -name 'App.tsx' -type f 2>/dev/null | grep -v node_modules"
    echo ""
    echo "# OR search for package.json with 'koda' in the path"  
    echo "find ~ -name 'package.json' -type f 2>/dev/null | grep -i koda"
    echo ""
    echo "Then navigate to that directory with:"
    echo "cd /path/to/your/koda/project"
else
    echo ""
    echo "🎯 To navigate to your project, run:"
    echo ""
    for project in "${FOUND_PROJECTS[@]}"; do
        echo "cd '$project'"
        echo "chmod +x diagnose-aws-deployment.sh"
        echo "./diagnose-aws-deployment.sh"
        echo ""
    done
fi

echo "Current directory: $(pwd)"
echo "Files in current directory:"
ls -la | head -10