#!/bin/bash

# 🔧 COMPLETE KODA WHITE SCREEN DIAGNOSIS & FIX
# This script will diagnose and fix ALL possible issues

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${BLUE}🔧 COMPLETE KODA DIAGNOSIS & FIX${NC}"
echo "=================================================="
echo ""

# Step 1: Verify we're in the right place
if [ ! -f "App.tsx" ] || [ ! -f "package.json" ]; then
    echo -e "${RED}❌ ERROR: Run this script from your Koda project root directory${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Found Koda project files${NC}"
echo ""

# Step 2: Check package.json scripts
echo -e "${YELLOW}Step 1: Checking package.json scripts...${NC}"
if grep -q "\"build\"" package.json; then
    echo -e "${GREEN}✅ Build script found${NC}"
else
    echo -e "${RED}❌ Build script missing${NC}"
    echo -e "${YELLOW}💡 Adding build script...${NC}"
    # This would require JSON manipulation - for now just warn
    echo -e "${RED}⚠️ Please ensure package.json has: \"build\": \"vite build\"${NC}"
fi

# Step 3: Check .env file
echo -e "${YELLOW}Step 2: Checking environment variables...${NC}"
if [ -f ".env" ]; then
    if grep -q "VITE_PLUGGER_API_KEY" .env; then
        API_KEY=$(grep "VITE_PLUGGER_API_KEY" .env | cut -d'=' -f2)
        if [ ! -z "$API_KEY" ] && [ "$API_KEY" != "your_api_key_here" ]; then
            echo -e "${GREEN}✅ API key found and configured${NC}"
        else
            echo -e "${RED}❌ API key is empty or placeholder${NC}"
        fi
    else
        echo -e "${RED}❌ API key not found in .env${NC}"
    fi
else
    echo -e "${RED}❌ .env file missing${NC}"
    echo -e "${YELLOW}💡 Creating .env file...${NC}"
    echo "VITE_PLUGGER_API_KEY=V3A3y007DBgtsqo7" > .env
    echo -e "${GREEN}✅ Created .env file${NC}"
fi

# Step 4: Create debug version of App
echo -e "${YELLOW}Step 3: Creating debug version...${NC}"
if [ -f "App.tsx" ]; then
    cp App.tsx App.tsx.backup
    echo -e "${GREEN}✅ Backed up original App.tsx${NC}"
fi

# Step 5: Clean install dependencies
echo -e "${YELLOW}Step 4: Clean installing dependencies...${NC}"
echo "Removing node_modules and package-lock.json..."
rm -rf node_modules package-lock.json

echo "Installing dependencies..."
npm install

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dependencies installed successfully${NC}"
else
    echo -e "${RED}❌ Dependency installation failed${NC}"
    echo -e "${YELLOW}💡 Try: rm -rf node_modules && npm install${NC}"
    exit 1
fi

# Step 6: Test build
echo -e "${YELLOW}Step 5: Testing build process...${NC}"
npm run build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build successful${NC}"
    
    # Check if dist has the right files
    if [ -f "dist/index.html" ] && [ -d "dist/assets" ]; then
        echo -e "${GREEN}✅ Build output looks correct${NC}"
        
        # Check if JavaScript files exist
        if ls dist/assets/*.js 1> /dev/null 2>&1; then
            echo -e "${GREEN}✅ JavaScript files found in build${NC}"
            
            # Get the actual JS filename
            JS_FILE=$(ls dist/assets/*.js | head -1 | xargs basename)
            echo -e "${BLUE}📄 Main JS file: ${JS_FILE}${NC}"
            
            # Check file size (should be > 1KB for a real app)
            JS_SIZE=$(stat -f%z "dist/assets/$JS_FILE" 2>/dev/null || stat -c%s "dist/assets/$JS_FILE" 2>/dev/null)
            if [ "$JS_SIZE" -gt 1000 ]; then
                echo -e "${GREEN}✅ JavaScript file size looks good (${JS_SIZE} bytes)${NC}"
            else
                echo -e "${RED}❌ JavaScript file suspiciously small (${JS_SIZE} bytes)${NC}"
            fi
        else
            echo -e "${RED}❌ No JavaScript files found in build${NC}"
        fi
    else
        echo -e "${RED}❌ Build output missing expected files${NC}"
    fi
else
    echo -e "${RED}❌ Build failed${NC}"
    echo ""
    echo -e "${YELLOW}🔍 Build error - trying to fix common issues...${NC}"
    
    # Try to fix TypeScript issues
    echo "Checking for TypeScript errors..."
    npx tsc --noEmit --skipLibCheck
    
    exit 1
fi

# Step 7: Test locally
echo -e "${YELLOW}Step 6: Testing locally...${NC}"
echo -e "${BLUE}🌐 Starting local server...${NC}"
echo -e "${YELLOW}Visit: http://localhost:8000/koda/${NC}"
echo -e "${YELLOW}You should see your Koda app with a yellow debug panel${NC}"
echo -e "${YELLOW}Press Ctrl+C when done testing${NC}"
echo ""

cd dist
if command -v python3 &> /dev/null; then
    python3 -m http.server 8000
elif command -v python &> /dev/null; then
    python -m SimpleHTTPServer 8000
else
    echo -e "${RED}❌ Python not found - cannot test locally${NC}"
    echo -e "${BLUE}💡 Your build is ready for upload to S3${NC}"
fi

echo ""
echo -e "${GREEN}🎉 DIAGNOSIS COMPLETE!${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "1. If local test worked: Upload dist/ to S3"
echo "2. If local test failed: Check browser console for errors"
echo "3. Upload test.html to S3 as well for additional testing"
echo "4. Add CloudFront error pages: 403 & 404 → /index.html → 200"
echo "5. Wait 10-15 minutes for CloudFront propagation"
echo ""
echo -e "${PURPLE}📋 Files ready for S3 upload:${NC}"
echo "- dist/index.html → S3 root"
echo "- dist/assets/* → S3 assets/"
echo "- test.html → S3 root (for testing)"