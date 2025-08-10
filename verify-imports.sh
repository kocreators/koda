#!/bin/bash

echo "🔍 Verifying import fixes..."

# Check for any remaining versioned imports
echo "Checking for remaining versioned imports..."
versioned_imports=$(find components -name "*.tsx" -o -name "*.ts" | xargs grep -l "@[0-9]\+\.[0-9]\+\.[0-9]\+" 2>/dev/null || true)

if [ -n "$versioned_imports" ]; then
    echo "❌ Still found versioned imports in:"
    echo "$versioned_imports"
    echo ""
    echo "Files with versioned imports:"
    find components -name "*.tsx" -o -name "*.ts" | xargs grep "@[0-9]\+\.[0-9]\+\.[0-9]\+" 2>/dev/null || true
    exit 1
else
    echo "✅ No versioned imports found!"
fi

# Check TypeScript compilation
echo ""
echo "🔍 Checking TypeScript compilation..."
if command -v npx >/dev/null 2>&1; then
    npx tsc --noEmit
    if [ $? -eq 0 ]; then
        echo "✅ TypeScript compilation successful!"
    else
        echo "❌ TypeScript compilation failed."
        exit 1
    fi
else
    echo "⚠️  TypeScript compiler not available. Skipping check."
fi

echo ""
echo "🎉 All verifications passed!"