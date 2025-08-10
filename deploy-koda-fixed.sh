#!/bin/bash

# Fixed deployment script for Koda Logo Generator to AWS S3 + CloudFront
# This ensures correct file structure and CloudFront configuration

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Deploying Koda Logo Generator to AWS (Fixed Version)${NC}"
echo "============================================================"

# Configuration - UPDATE THESE VALUES
S3_BUCKET="your-s3-bucket-name"  # Update this
CLOUDFRONT_DISTRIBUTION_ID="YOUR_DISTRIBUTION_ID"  # Update this
REGION="us-east-1"  # Update if different

echo ""
echo -e "${YELLOW}📋 Pre-deployment checklist:${NC}"
echo "1. S3 bucket: $S3_BUCKET"
echo "2. CloudFront distribution: $CLOUDFRONT_DISTRIBUTION_ID"
echo "3. Files will be uploaded to: s3://$S3_BUCKET/koda/"
echo ""

# Step 1: Build the application
echo -e "${YELLOW}Step 1: Building application...${NC}"
if npm run build; then
    echo -e "${GREEN}✅ Build successful${NC}"
else
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

echo ""

# Step 2: Verify build output
echo -e "${YELLOW}Step 2: Verifying build output...${NC}"
if [ -f "dist/index.html" ]; then
    echo -e "${GREEN}✅ index.html exists${NC}"
    
    # Check if base path is correct
    if grep -q '/koda/' dist/index.html; then
        echo -e "${GREEN}✅ Base path /koda/ found in index.html${NC}"
    else
        echo -e "${RED}❌ Base path /koda/ not found in index.html${NC}"
        echo -e "${YELLOW}💡 Check your vite.config.ts base setting${NC}"
    fi
else
    echo -e "${RED}❌ index.html not found in dist/${NC}"
    exit 1
fi

echo ""

# Step 3: Upload to S3 with correct structure
echo -e "${YELLOW}Step 3: Uploading to S3...${NC}"
echo "Target: s3://$S3_BUCKET/koda/"

if command -v aws >/dev/null 2>&1; then
    echo -e "${BLUE}Syncing files to S3...${NC}"
    
    # Upload files to /koda/ subdirectory
    aws s3 sync dist/ s3://$S3_BUCKET/koda/ \
        --delete \
        --region $REGION \
        --cache-control "public, max-age=31536000" \
        --exclude "*.html" \
        --exclude "*.xml" \
        --exclude "*.txt"
    
    # Upload HTML files with shorter cache
    aws s3 sync dist/ s3://$S3_BUCKET/koda/ \
        --delete \
        --region $REGION \
        --cache-control "public, max-age=300" \
        --include "*.html" \
        --include "*.xml" \
        --include "*.txt"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Files uploaded successfully${NC}"
    else
        echo -e "${RED}❌ S3 upload failed${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ AWS CLI not found${NC}"
    echo -e "${YELLOW}💡 Install AWS CLI: https://aws.amazon.com/cli/${NC}"
    exit 1
fi

echo ""

# Step 4: Create CloudFront invalidation
echo -e "${YELLOW}Step 4: Creating CloudFront invalidation...${NC}"
if [ "$CLOUDFRONT_DISTRIBUTION_ID" != "YOUR_DISTRIBUTION_ID" ]; then
    aws cloudfront create-invalidation \
        --distribution-id $CLOUDFRONT_DISTRIBUTION_ID \
        --paths "/*" \
        --region $REGION
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ CloudFront invalidation created${NC}"
    else
        echo -e "${YELLOW}⚠️ CloudFront invalidation failed (not critical)${NC}"
    fi
else
    echo -e "${YELLOW}⚠️ CloudFront distribution ID not set${NC}"
    echo -e "${YELLOW}💡 Update CLOUDFRONT_DISTRIBUTION_ID in this script${NC}"
fi

echo ""

# Step 5: Verify deployment
echo -e "${YELLOW}Step 5: Verifying deployment...${NC}"

echo -e "${BLUE}Expected S3 structure:${NC}"
echo "s3://$S3_BUCKET/"
echo "└── koda/"
echo "    ├── index.html"
echo "    ├── assets/"
echo "    │   ├── main-[hash].js"
echo "    │   └── main-[hash].css"
echo "    └── favicon.svg"

echo ""
echo -e "${BLUE}Testing file accessibility...${NC}"

# Test if index.html was uploaded correctly
aws s3api head-object --bucket $S3_BUCKET --key koda/index.html --region $REGION >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ koda/index.html exists in S3${NC}"
else
    echo -e "${RED}❌ koda/index.html not found in S3${NC}"
fi

echo ""

# Step 6: CloudFront configuration check
echo -e "${YELLOW}Step 6: CloudFront configuration reminders...${NC}"
echo ""
echo -e "${BLUE}⚠️ IMPORTANT: Configure CloudFront Error Pages${NC}"
echo ""
echo -e "${YELLOW}You MUST add these custom error responses:${NC}"
echo ""
echo "1. AWS Console → CloudFront → Your Distribution"
echo "2. Error Pages tab → Create Custom Error Response"
echo ""
echo -e "${GREEN}Error Response 1:${NC}"
echo "   HTTP Error Code: 403"
echo "   Response Page Path: /koda/index.html"
echo "   HTTP Response Code: 200"
echo ""
echo -e "${GREEN}Error Response 2:${NC}"
echo "   HTTP Error Code: 404"
echo "   Response Page Path: /koda/index.html"
echo "   HTTP Response Code: 200"
echo ""
echo -e "${RED}👆 This step is REQUIRED to prevent white screens!${NC}"

echo ""

# Step 7: Final instructions
echo -e "${BLUE}🎉 Deployment Complete!${NC}"
echo "======================="
echo ""
echo -e "${GREEN}✅ Files uploaded to: s3://$S3_BUCKET/koda/${NC}"
echo -e "${GREEN}✅ CloudFront invalidation created${NC}"
echo ""
echo -e "${YELLOW}🔧 Next Steps:${NC}"
echo "1. Configure CloudFront error pages (see above)"
echo "2. Wait 5-15 minutes for CloudFront propagation"
echo "3. Test: https://koda.kocreators.com/"
echo "4. Check browser dev tools if issues persist"
echo ""
echo -e "${BLUE}🧪 Test Commands:${NC}"
echo "chmod +x test-live-deployment.sh"
echo "./test-live-deployment.sh"
echo ""
echo -e "${YELLOW}💡 Common Issues:${NC}"
echo "• White screen = Missing CloudFront error pages"
echo "• 404 errors = Files uploaded to wrong S3 path"
echo "• Logo generation fails = Missing API key"
echo ""
echo -e "${GREEN}Your Koda Logo Generator should be live soon! 🚀${NC}"