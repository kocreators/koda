#!/bin/bash

# Ultimate fix for Koda Logo Generator
echo "🔧 Ultimate fix for Koda Logo Generator..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Step 1: Cleaning up files...${NC}"

# Backup current package.json
cp package.json package.json.backup

# Use the clean package.json
cp package-clean.json package.json

# Clean up node_modules and locks
rm -rf node_modules package-lock.json

# Remove all the problematic UI components (keep only the ones we use)
cd components/ui/

# List of files to keep
KEEP_FILES=("button.tsx" "card.tsx" "dialog.tsx" "textarea.tsx" "progress.tsx" "utils.ts" "index.ts")

# Remove all other files
for file in *.tsx *.ts; do
  if [[ -f "$file" ]] && [[ ! " ${KEEP_FILES[@]} " =~ " ${file} " ]]; then
    echo "Removing unused component: $file"
    rm -f "$file"
  fi
done

cd ../../

echo -e "${GREEN}✅ Cleanup complete!${NC}"

echo -e "${BLUE}Step 2: Installing dependencies...${NC}"

# Install with legacy peer deps (most likely to work)
npm install --legacy-peer-deps

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dependencies installed!${NC}"
    
    echo -e "${BLUE}Step 3: Testing TypeScript...${NC}"
    
    # Test TypeScript
    npx tsc --noEmit
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ TypeScript compilation successful!${NC}"
        
        echo -e "${BLUE}Step 4: Testing build...${NC}"
        
        # Test build
        npm run build
        
        if [ $? -eq 0 ]; then
            echo ""
            echo -e "${GREEN}🎉 SUCCESS! Everything works!${NC}"
            echo ""
            echo -e "${YELLOW}🚀 Your Koda Logo Generator is ready to deploy!${NC}"
            echo ""
            echo -e "Next steps:"
            echo -e "   1. ${GREEN}npm run preview${NC} - Test the app locally"
            echo -e "   2. ${GREEN}./deploy-koda-subdirectory.sh${NC} - Deploy to AWS"
            echo ""
            
            # Ask if they want to preview
            read -p "$(echo -e ${YELLOW}Would you like to preview the app now? [y/N]:${NC} )" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "${BLUE}🌐 Starting preview server...${NC}"
                echo -e "${YELLOW}Visit: http://localhost:4173/koda/${NC}"
                npm run preview
            fi
        else
            echo -e "${RED}❌ Build failed${NC}"
            echo "Check error messages above"
        fi
    else
        echo -e "${RED}❌ TypeScript errors remain${NC}"
        echo "Check error messages above"
    fi
else
    echo -e "${RED}❌ Dependency installation failed${NC}"
    echo "Try running: npm install --force"
fi