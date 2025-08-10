#!/bin/bash

# 🚀 SETUP LOCAL DEVELOPMENT FOR EXISTING KODA PROJECT
# Run this in your existing Koda project directory

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Setting up Koda project for local development...${NC}"
echo ""

# Step 1: Check if we're in the right directory
if [ ! -f "App.tsx" ] || [ ! -f "package.json" ]; then
    echo -e "${RED}❌ ERROR: Please run this script from your Koda project directory${NC}"
    echo "Current directory: $(pwd)"
    echo "Expected files: App.tsx, package.json"
    exit 1
fi

echo -e "${GREEN}✅ Found Koda project files${NC}"

# Step 2: Clean any previous installs
echo -e "${YELLOW}Step 1: Cleaning previous installations...${NC}"
rm -rf node_modules package-lock.json dist .vite

# Step 3: Install dependencies
echo -e "${YELLOW}Step 2: Installing dependencies...${NC}"
npm install

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dependencies installed successfully${NC}"
else
    echo -e "${RED}❌ Dependency installation failed${NC}"
    echo -e "${YELLOW}💡 Trying with --legacy-peer-deps...${NC}"
    npm install --legacy-peer-deps
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Dependencies installed with legacy peer deps${NC}"
    else
        echo -e "${RED}❌ Installation still failed. Please check npm errors above.${NC}"
        exit 1
    fi
fi

# Step 4: Test TypeScript compilation
echo -e "${YELLOW}Step 3: Testing TypeScript compilation...${NC}"
npx tsc --noEmit --skipLibCheck

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ TypeScript compilation successful${NC}"
else
    echo -e "${RED}⚠️ TypeScript warnings found, but continuing...${NC}"
fi

# Step 5: Test build
echo -e "${YELLOW}Step 4: Testing production build...${NC}"
npm run build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Production build successful${NC}"
    
    # Check build output
    if [ -d "dist" ] && [ -f "dist/index.html" ]; then
        echo -e "${GREEN}✅ Build files created successfully${NC}"
        
        # List key build files
        echo -e "${BLUE}📁 Build output:${NC}"
        ls -la dist/
        echo ""
        ls -la dist/assets/ 2>/dev/null || echo "No assets directory found"
    else
        echo -e "${RED}❌ Build files not found${NC}"
    fi
else
    echo -e "${RED}❌ Production build failed${NC}"
    echo -e "${YELLOW}💡 You can still run development mode${NC}"
fi

echo ""
echo -e "${GREEN}🎉 LOCAL DEVELOPMENT SETUP COMPLETE!${NC}"
echo ""
echo -e "${BLUE}🚀 Next Steps:${NC}"
echo ""
echo -e "${YELLOW}1. Start Development Server:${NC}"
echo "   npm run dev"
echo "   Then visit: http://localhost:5173/koda/"
echo ""
echo -e "${YELLOW}2. Build for Production:${NC}"
echo "   npm run build"
echo ""
echo -e "${YELLOW}3. Preview Production Build:${NC}"
echo "   npm run preview"
echo ""
echo -e "${YELLOW}4. Test Locally:${NC}"
echo "   cd dist && python3 -m http.server 8000"
echo "   Then visit: http://localhost:8000/koda/"
echo ""
echo -e "${GREEN}📁 Current directory: $(pwd)${NC}"
echo -e "${GREEN}📝 All your files are ready for development!${NC}"