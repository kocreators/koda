#!/bin/bash

echo "🔧 Simple fix - removing unused UI components..."

# Remove all the problematic UI components except the ones we need
cd components/ui/

echo "Keeping only: button.tsx, card.tsx, dialog.tsx, textarea.tsx, progress.tsx, utils.ts, index.ts"

# Remove specific problematic files
rm -f accordion.tsx alert-dialog.tsx alert.tsx aspect-ratio.tsx avatar.tsx badge.tsx
rm -f breadcrumb.tsx calendar.tsx carousel.tsx chart.tsx checkbox.tsx collapsible.tsx
rm -f command.tsx context-menu.tsx drawer.tsx dropdown-menu.tsx form.tsx hover-card.tsx
rm -f input-otp.tsx input.tsx label.tsx menubar.tsx navigation-menu.tsx pagination.tsx
rm -f popover.tsx radio-group.tsx resizable.tsx scroll-area.tsx select.tsx separator.tsx
rm -f sheet.tsx sidebar.tsx skeleton.tsx slider.tsx sonner.tsx switch.tsx table.tsx
rm -f tabs.tsx toggle-group.tsx toggle.tsx tooltip.tsx use-mobile.ts

cd ../../

echo "✅ Removed unused components"

echo "🔍 Testing TypeScript..."
npx tsc --noEmit

if [ $? -eq 0 ]; then
    echo "✅ TypeScript OK!"
    
    echo "🔨 Testing build..."
    npm run build
    
    if [ $? -eq 0 ]; then
        echo "🎉 SUCCESS! Build works!"
        echo ""
        echo "You can now run:"
        echo "  npm run preview (test the app)"
        echo "  ./deploy-koda-subdirectory.sh (deploy)"
    else
        echo "❌ Build failed"
    fi
else
    echo "❌ TypeScript errors remain"
fi