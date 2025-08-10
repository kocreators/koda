#!/bin/bash

# 🔍 LOCAL DIAGNOSTIC SCRIPT FOR KODA DEPLOYMENT
# Run this in your LOCAL terminal where your Koda project is located

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔍 KODA DEPLOYMENT DIAGNOSIS (Running from Local Machine)${NC}"
echo "=================================================================="
echo ""
echo -e "${YELLOW}📍 This script should be run from your LOCAL terminal${NC}"
echo -e "${YELLOW}📍 Make sure you're in your Koda project directory${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "App.tsx" ] || [ ! -f "package.json" ]; then
    echo -e "${RED}❌ ERROR: This doesn't look like your Koda project directory${NC}"
    echo ""
    echo -e "${YELLOW}Please navigate to your Koda project folder first:${NC}"
    echo "cd /path/to/your/koda-project"
    echo "chmod +x test-deployment-local.sh"
    echo "./test-deployment-local.sh"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Found Koda project files${NC}"
echo ""

# Step 1: Check local build
echo -e "${YELLOW}Step 1: Checking local build status...${NC}"
if [ -d "dist" ]; then
    echo -e "${GREEN}✅ dist folder exists${NC}"
    
    if [ -f "dist/index.html" ]; then
        echo -e "${GREEN}✅ index.html exists in dist${NC}"
        
        # Check if base path is correct
        if grep -q '/koda/' dist/index.html; then
            echo -e "${GREEN}✅ index.html contains correct /koda/ base path${NC}"
        else
            echo -e "${RED}❌ index.html missing /koda/ base path${NC}"
            echo -e "${YELLOW}💡 Run: npm run build to regenerate${NC}"
        fi
    else
        echo -e "${RED}❌ index.html missing from dist${NC}"
        echo -e "${YELLOW}💡 Run: npm run build${NC}"
    fi
else
    echo -e "${RED}❌ dist folder doesn't exist${NC}"
    echo -e "${YELLOW}💡 Run: npm run build first${NC}"
fi

echo ""

# Step 2: Check environment
echo -e "${YELLOW}Step 2: Checking environment configuration...${NC}"
if [ -f ".env" ]; then
    echo -e "${GREEN}✅ .env file exists${NC}"
    if grep -q "VITE_PLUGGER_API_KEY" .env 2>/dev/null; then
        echo -e "${GREEN}✅ API key found in .env${NC}"
    else
        echo -e "${RED}❌ API key missing from .env${NC}"
        echo -e "${YELLOW}💡 Add: VITE_PLUGGER_API_KEY=your_key_here${NC}"
    fi
else
    echo -e "${RED}❌ .env file missing${NC}"
    echo -e "${YELLOW}💡 Create .env file with your API key${NC}"
fi

echo ""

# Step 3: Test live website
echo -e "${YELLOW}Step 3: Testing live website...${NC}"
SITE_URL="https://koda.kocreators.com"

echo -e "${BLUE}Testing: $SITE_URL${NC}"

# Test main URL
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$SITE_URL/" 2>/dev/null)
if [ "$HTTP_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ Main site accessible (HTTP $HTTP_STATUS)${NC}"
    
    # Check if HTML content is served
    CONTENT=$(curl -s "$SITE_URL/" 2>/dev/null | head -5)
    if echo "$CONTENT" | grep -q "<!doctype html>" || echo "$CONTENT" | grep -q "<html"; then
        echo -e "${GREEN}✅ HTML content is being served${NC}"
        
        if echo "$CONTENT" | grep -q "root"; then
            echo -e "${GREEN}✅ React app structure detected${NC}"
        else
            echo -e "${RED}❌ React app structure not found${NC}"
        fi
    else
        echo -e "${RED}❌ No HTML content detected${NC}"
        echo -e "${YELLOW}Content preview: $CONTENT${NC}"
    fi
else
    echo -e "${RED}❌ Main site returned HTTP $HTTP_STATUS${NC}"
    if [ "$HTTP_STATUS" = "000" ]; then
        echo -e "${YELLOW}💡 Network/DNS issue - check if domain points to CloudFront${NC}"
    fi
fi

# Test index.html directly
INDEX_STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$SITE_URL/index.html" 2>/dev/null)
if [ "$INDEX_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ /index.html directly accessible (HTTP $INDEX_STATUS)${NC}"
else
    echo -e "${RED}❌ /index.html returned HTTP $INDEX_STATUS${NC}"
fi

echo ""

# Step 4: Diagnosis and recommendations
echo -e "${YELLOW}Step 4: Diagnosis and recommendations...${NC}"
echo ""

if [ "$HTTP_STATUS" = "200" ] && echo "$CONTENT" | grep -q "root" 2>/dev/null; then
    echo -e "${GREEN}🎉 Your website appears to be working!${NC}"
    echo ""
    echo -e "${YELLOW}If you're still seeing a white screen:${NC}"
    echo "1. Clear browser cache and try incognito mode"
    echo "2. Check browser dev tools (F12) for JavaScript errors"
    echo "3. Verify API key is working for logo generation"
    
elif [ "$HTTP_STATUS" = "200" ] && [ "$INDEX_STATUS" = "200" ]; then
    echo -e "${YELLOW}⚠️ Site loads but React app may not be working${NC}"
    echo ""
    echo -e "${BLUE}🔧 Try these fixes:${NC}"
    echo "1. Check browser console (F12) for JavaScript errors"
    echo "2. Verify your API key is set correctly"
    echo "3. Check if assets are loading properly"
    
elif [ "$INDEX_STATUS" = "200" ] && [ "$HTTP_STATUS" != "200" ]; then
    echo -e "${RED}🎯 FOUND THE ISSUE: Missing CloudFront Error Pages${NC}"
    echo ""
    echo -e "${YELLOW}This is the most common cause of white screens!${NC}"
    echo ""
    echo -e "${BLUE}🔧 FIX: Add CloudFront Error Pages${NC}"
    echo "1. AWS Console → CloudFront → Your Distribution"
    echo "2. Error Pages tab → Create Custom Error Response"
    echo "3. Add: 403 Error → /koda/index.html → Response Code 200"
    echo "4. Add: 404 Error → /koda/index.html → Response Code 200"
    echo "5. Wait 10 minutes for propagation"
    
else
    echo -e "${RED}🔧 Multiple issues detected${NC}"
    echo ""
    echo -e "${BLUE}Try these fixes in order:${NC}"
    echo "1. Verify S3 files are uploaded to /koda/ folder"
    echo "2. Add CloudFront error pages (see above)"
    echo "3. Create CloudFront invalidation: /*"
    echo "4. Check DNS: koda.kocreators.com → CloudFront"
fi

echo ""
echo -e "${BLUE}🧪 Manual Browser Tests:${NC}"
echo "1. Visit: $SITE_URL"
echo "2. Press F12 → Console tab (check for errors)"
echo "3. Press F12 → Network tab (check for failed requests)"
echo ""
echo -e "${YELLOW}💡 Most white screens are fixed by adding CloudFront error pages!${NC}"