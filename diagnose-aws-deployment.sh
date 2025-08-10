#!/bin/bash

# Koda Logo Generator - AWS Deployment Diagnosis Script
# This script helps identify why your app shows a white screen on AWS

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Diagnosing AWS Deployment Issues for Koda Logo Generator${NC}"
echo -e "${BLUE}================================================================${NC}"
echo ""

# Step 1: Check local build
echo -e "${YELLOW}Step 1: Testing local build...${NC}"
if [ -d "dist" ]; then
    echo -e "${GREEN}✅ dist folder exists${NC}"
    
    if [ -f "dist/index.html" ]; then
        echo -e "${GREEN}✅ index.html exists in dist${NC}"
        
        # Check if index.html has the correct base path
        if grep -q '/koda/' dist/index.html; then
            echo -e "${GREEN}✅ index.html contains /koda/ base path${NC}"
        else
            echo -e "${RED}❌ index.html missing /koda/ base path${NC}"
            echo -e "${YELLOW}💡 This might cause routing issues on AWS${NC}"
        fi
        
        # Check if main JS file exists
        JS_FILE=$(grep -o 'src="/koda/assets/.*\.js"' dist/index.html | sed 's/src="//;s/"//' | head -1)
        if [ -n "$JS_FILE" ]; then
            ACTUAL_JS_FILE="dist${JS_FILE#/koda}"
            if [ -f "$ACTUAL_JS_FILE" ]; then
                echo -e "${GREEN}✅ Main JavaScript file exists: $ACTUAL_JS_FILE${NC}"
            else
                echo -e "${RED}❌ Main JavaScript file missing: $ACTUAL_JS_FILE${NC}"
            fi
        fi
        
    else
        echo -e "${RED}❌ index.html missing from dist folder${NC}"
        echo -e "${YELLOW}💡 Run 'npm run build' first${NC}"
    fi
else
    echo -e "${RED}❌ dist folder doesn't exist${NC}"
    echo -e "${YELLOW}💡 Run 'npm run build' first${NC}"
fi

echo ""

# Step 2: Environment variables
echo -e "${YELLOW}Step 2: Checking environment variables...${NC}"
if [ -f ".env" ]; then
    echo -e "${GREEN}✅ .env file exists${NC}"
    if grep -q "VITE_PLUGGER_API_KEY" .env; then
        echo -e "${GREEN}✅ VITE_PLUGGER_API_KEY found in .env${NC}"
    else
        echo -e "${RED}❌ VITE_PLUGGER_API_KEY missing from .env${NC}"
        echo -e "${YELLOW}💡 Logo generation will fail without API key${NC}"
    fi
else
    echo -e "${RED}❌ .env file missing${NC}"
    echo -e "${YELLOW}💡 Create .env file with VITE_PLUGGER_API_KEY${NC}"
fi

echo ""

# Step 3: Check deployment configuration
echo -e "${YELLOW}Step 3: Checking deployment configuration...${NC}"

echo -e "${BLUE}Expected file structure after deployment:${NC}"
echo -e "${YELLOW}S3 Bucket Structure:${NC}"
echo "  📁 your-bucket/"
echo "  ├── 📁 koda/"
echo "  │   ├── 📄 index.html"
echo "  │   ├── 📁 assets/"
echo "  │   │   ├── 📄 main-[hash].js"
echo "  │   │   └── 📄 main-[hash].css"
echo "  │   └── 📄 favicon.svg"

echo ""
echo -e "${BLUE}CloudFront Requirements:${NC}"
echo -e "1. ${YELLOW}Origin Path:${NC} Should be empty (/) or point to root"
echo -e "2. ${YELLOW}Default Root Object:${NC} Leave empty for subdirectories"
echo -e "3. ${YELLOW}Error Pages:${NC} Must redirect to /koda/index.html"
echo -e "4. ${YELLOW}Behavior Path:${NC} /koda/* should point to S3"

echo ""

# Step 4: Generate diagnostic URLs
echo -e "${YELLOW}Step 4: Diagnostic URLs to test...${NC}"
echo ""
echo -e "${BLUE}Test these URLs in your browser:${NC}"
echo ""
echo -e "1. ${GREEN}Main App:${NC} https://koda.kocreators.com/"
echo -e "   Expected: Should show Koda logo generator"
echo -e "   If fails: Check CloudFront origin configuration"
echo ""
echo -e "2. ${GREEN}Index File:${NC} https://koda.kocreators.com/index.html"
echo -e "   Expected: Should show same as above"
echo -e "   If fails: Check S3 bucket file structure"
echo ""
echo -e "3. ${GREEN}Assets:${NC} https://koda.kocreators.com/assets/"
echo -e "   Expected: Should show asset files or 403"
echo -e "   If fails: Assets not uploaded correctly"
echo ""
echo -e "4. ${GREEN}API Test:${NC} Open browser dev tools on main app"
echo -e "   Expected: No console errors"
echo -e "   If errors: Check for CORS or missing files"

echo ""

# Step 5: Common fixes
echo -e "${YELLOW}Step 5: Common fixes for white screen...${NC}"
echo ""
echo -e "${BLUE}🔧 Most Common Solutions:${NC}"
echo ""
echo -e "${GREEN}Fix #1: CloudFront Error Pages${NC}"
echo -e "   • Go to CloudFront distribution"
echo -e "   • Error Pages tab → Create Custom Error Response"
echo -e "   • HTTP Error Code: 403, 404"
echo -e "   • Response Page Path: /koda/index.html"
echo -e "   • HTTP Response Code: 200"
echo ""
echo -e "${GREEN}Fix #2: S3 File Upload${NC}"
echo -e "   • Files should be uploaded to: /koda/ folder"
echo -e "   • Not to root bucket"
echo -e "   • index.html should be at: /koda/index.html"
echo ""
echo -e "${GREEN}Fix #3: CloudFront Cache${NC}"
echo -e "   • Create invalidation: /*"
echo -e "   • Wait 5-15 minutes for propagation"
echo ""
echo -e "${GREEN}Fix #4: CORS Headers${NC}"
echo -e "   • S3 bucket should allow GET requests"
echo -e "   • Add CORS policy if API calls fail"

echo ""

# Step 6: Quick test commands
echo -e "${YELLOW}Step 6: Quick diagnostic commands...${NC}"
echo ""
echo -e "${BLUE}Run these commands to test:${NC}"
echo ""
echo "# Test if your site is accessible:"
echo "curl -I https://koda.kocreators.com/"
echo ""
echo "# Check if index.html loads:"
echo "curl -s https://koda.kocreators.com/index.html | head -10"
echo ""
echo "# Check CloudFront headers:"
echo "curl -I https://koda.kocreators.com/ | grep -i 'x-cache\\|server'"

echo ""
echo -e "${BLUE}================================================================${NC}"
echo -e "${GREEN}🎯 Next Steps:${NC}"
echo -e "1. Run the diagnostic URLs in your browser"
echo -e "2. Check browser dev tools for errors"
echo -e "3. Verify S3 file structure matches expected layout"
echo -e "4. Configure CloudFront error pages if needed"
echo -e "5. Invalidate CloudFront cache"
echo ""
echo -e "${YELLOW}Need help? The most common issue is missing CloudFront error page configuration.${NC}"