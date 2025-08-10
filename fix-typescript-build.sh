#!/bin/bash

# Koda Logo Generator - TypeScript Build Fix Script

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Fixing TypeScript build errors for Koda Logo Generator...${NC}"

# Remove any accidentally generated declaration files
echo -e "${YELLOW}🧹 Cleaning up generated declaration files...${NC}"
rm -f vite.config.d.ts
rm -f vitest.config.d.ts
rm -f tailwind.config.d.ts

# Clean up any previous builds
echo -e "${YELLOW}🗑️  Cleaning build directory...${NC}"
rm -rf dist/

# Check TypeScript compilation first
echo -e "${YELLOW}🔍 Checking TypeScript compilation...${NC}"
npx tsc --noEmit

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ TypeScript compilation successful!${NC}"
    
    # Now try the full build
    echo -e "${YELLOW}🔨 Running full build...${NC}"
    npm run build
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}🎉 Build successful! Your Koda Logo Generator is ready!${NC}"
        echo ""
        echo -e "${BLUE}🚀 Next steps:${NC}"
        echo -e "   1. Run ${YELLOW}npm run preview${NC} to test the built version"
        echo -e "   2. Run ${YELLOW}./deploy-koda-subdirectory.sh${NC} to deploy to AWS"
        echo ""
        
        # Ask if they want to preview
        read -p "$(echo -e ${YELLOW}Would you like to preview the app now? [y/N]:${NC} )" -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}🌐 Starting preview server...${NC}"
            echo -e "${YELLOW}Visit: http://localhost:4173/koda/${NC}"
            echo -e "${YELLOW}Press Ctrl+C to stop the preview server.${NC}"
            npm run preview
        fi
    else
        echo ""
        echo -e "${RED}❌ Build failed after TypeScript check passed.${NC}"
        echo -e "${YELLOW}💡 This might be a Vite configuration issue.${NC}"
        exit 1
    fi
else
    echo ""
    echo -e "${RED}❌ TypeScript compilation failed.${NC}"
    echo -e "${YELLOW}💡 Check the errors above for details.${NC}"
    echo -e "${YELLOW}Common issues:${NC}"
    echo -e "   1. Missing type declarations"
    echo -e "   2. Import path issues"
    echo -e "   3. Incorrect TypeScript configuration"
    exit 1
fi