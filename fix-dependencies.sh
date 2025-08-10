#!/bin/bash

# Koda Logo Generator - Complete Dependency and TypeScript Fix Script

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Fixing Koda Logo Generator dependencies and TypeScript...${NC}"

# Check Node.js version
node_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$node_version" -lt 18 ]; then
    echo -e "${RED}❌ Node.js 18+ is required. Current version: $(node -v)${NC}"
    echo -e "${YELLOW}Please upgrade Node.js to version 18 or higher.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Node.js version $(node -v) is compatible${NC}"

# Remove existing lock files and node_modules
echo -e "${YELLOW}🧹 Cleaning up old dependencies and build files...${NC}"
rm -rf node_modules
rm -f package-lock.json
rm -f yarn.lock
rm -f pnpm-lock.yaml
rm -rf dist/
rm -f vite.config.d.ts
rm -f vitest.config.d.ts
rm -f tailwind.config.d.ts

# Clear npm cache
echo -e "${YELLOW}🗑️  Clearing npm cache...${NC}"
npm cache clean --force

# Install dependencies
echo -e "${YELLOW}📦 Installing dependencies...${NC}"
npm install --legacy-peer-deps

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Dependencies installed successfully!${NC}"
    
    # Check TypeScript compilation
    echo -e "${YELLOW}🔍 Checking TypeScript compilation...${NC}"
    npx tsc --noEmit
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ TypeScript compilation successful!${NC}"
        
        echo -e "${YELLOW}🔨 Testing full build...${NC}"
        npm run build
        
        if [ $? -eq 0 ]; then
            echo ""
            echo -e "${GREEN}🎉 Everything works perfectly!${NC}"
            echo ""
            echo -e "${BLUE}🚀 Your Koda Logo Generator is ready to deploy!${NC}"
            echo ""
            echo -e "${YELLOW}Next steps:${NC}"
            echo -e "   1. Run ${GREEN}npm run dev${NC} - Start development server"
            echo -e "   2. Run ${GREEN}npm run preview${NC} - Test the built version"  
            echo -e "   3. Run ${GREEN}./deploy-koda-subdirectory.sh${NC} - Deploy to AWS"
            echo ""
            
            # Ask if they want to preview
            read -p "$(echo -e ${YELLOW}Would you like to test the app now? [y/N]:${NC} )" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "${BLUE}🌐 Starting preview server at http://localhost:4173/koda/${NC}"
                echo -e "${YELLOW}Press Ctrl+C when done, then you can deploy to AWS.${NC}"
                npm run preview
            fi
            
        else
            echo ""
            echo -e "${RED}❌ Build failed after TypeScript check passed.${NC}"
            echo -e "${YELLOW}💡 Possible Vite configuration issue. Check error above.${NC}"
            exit 1
        fi
    else
        echo ""
        echo -e "${RED}❌ TypeScript compilation failed.${NC}"
        echo -e "${YELLOW}💡 The TypeScript configuration has been fixed, but there might be other issues.${NC}"
        echo -e "${YELLOW}Check the error messages above for details.${NC}"
        exit 1
    fi
else
    echo ""
    echo -e "${RED}❌ Dependency installation failed.${NC}"
    echo -e "${YELLOW}💡 Trying alternative approaches...${NC}"
    
    echo -e "${YELLOW}🔄 Trying with --force...${NC}"
    npm install --force
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Dependencies installed with --force!${NC}"
        
        # Test build
        npm run build
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Build successful!${NC}"
        fi
    else
        echo ""
        echo -e "${RED}❌ All installation methods failed.${NC}"
        echo -e "${YELLOW}💡 Manual steps:${NC}"
        echo -e "   1. Update Node.js: https://nodejs.org"
        echo -e "   2. Try: ${YELLOW}npm install --legacy-peer-deps${NC}"
        echo -e "   3. Or: ${YELLOW}npm install --force${NC}"
        exit 1
    fi
fi