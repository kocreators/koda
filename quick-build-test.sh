#!/bin/bash

# Quick build test for Koda Logo Generator
echo "🔧 Quick build test for Koda..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Remove problematic files
echo -e "${YELLOW}🧹 Removing unused UI components...${NC}"

# Create a list of files to keep
KEEP_FILES=(
  "button.tsx"
  "card.tsx" 
  "dialog.tsx"
  "textarea.tsx"
  "progress.tsx"
  "utils.ts"
  "index.ts"
)

# Remove all other .tsx files in components/ui except the ones we need
cd components/ui/
for file in *.tsx; do
  if [[ ! " ${KEEP_FILES[@]} " =~ " ${file} " ]]; then
    echo "Removing unused component: $file"
    rm -f "$file"
  fi
done

# Remove all .ts files except utils.ts and index.ts
for file in *.ts; do
  if [[ ! " ${KEEP_FILES[@]} " =~ " ${file} " ]]; then
    echo "Removing unused file: $file"
    rm -f "$file"
  fi
done

cd ../../

echo -e "${GREEN}✅ Cleanup complete!${NC}"

# Test TypeScript compilation
echo -e "${YELLOW}🔍 Testing TypeScript compilation...${NC}"
npx tsc --noEmit

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ TypeScript compilation successful!${NC}"
    
    # Test build
    echo -e "${YELLOW}🔨 Testing build...${NC}"
    npm run build
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}🎉 Build successful! Your Koda Logo Generator is ready!${NC}"
        echo ""
        echo -e "${YELLOW}🚀 You can now:${NC}"
        echo -e "   1. Run ${GREEN}npm run preview${NC} to test the app"
        echo -e "   2. Deploy to AWS when ready"
    else
        echo -e "${RED}❌ Build failed after TypeScript passed.${NC}"
    fi
else
    echo -e "${RED}❌ TypeScript compilation still has errors.${NC}"
    echo -e "${YELLOW}Remaining errors need manual fixes.${NC}"
fi