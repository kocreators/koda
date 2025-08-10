#!/bin/bash

# 🚀 DEPLOY FIXED KODA TO S3
# Run this AFTER running fix-white-screen.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 DEPLOYING FIXED KODA TO S3${NC}"
echo "=================================="
echo ""

# Check if dist folder exists
if [ ! -d "dist" ]; then
    echo -e "${RED}❌ dist folder not found${NC}"
    echo -e "${YELLOW}💡 Run ./fix-white-screen.sh first${NC}"
    exit 1
fi

# Check if dist has index.html
if [ ! -f "dist/index.html" ]; then
    echo -e "${RED}❌ dist/index.html not found${NC}"
    echo -e "${YELLOW}💡 Run ./fix-white-screen.sh first${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build files found${NC}"

# S3 bucket name
BUCKET_NAME="koda.kocreators.com"

echo -e "${YELLOW}Uploading files to S3 bucket: $BUCKET_NAME${NC}"
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI not found${NC}"
    echo -e "${YELLOW}💡 Install AWS CLI: https://aws.amazon.com/cli/${NC}"
    echo ""
    echo -e "${BLUE}Manual Upload Instructions:${NC}"
    echo "1. Go to AWS S3 Console"
    echo "2. Open bucket: $BUCKET_NAME"
    echo "3. Upload ALL files from dist/ folder to the ROOT of the bucket"
    echo "4. Set public read permissions"
    echo "5. Configure CloudFront error pages"
    exit 1
fi

# Sync files to S3
echo "Syncing files..."
aws s3 sync dist/ s3://$BUCKET_NAME/ --delete --cache-control max-age=86400

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Files uploaded successfully${NC}"
else
    echo -e "${RED}❌ Upload failed${NC}"
    echo -e "${YELLOW}💡 Check your AWS credentials and bucket permissions${NC}"
    exit 1
fi

# Set correct content types
echo "Setting content types..."
aws s3 cp s3://$BUCKET_NAME/index.html s3://$BUCKET_NAME/index.html --content-type "text/html" --metadata-directive REPLACE
aws s3 sync s3://$BUCKET_NAME/assets/ s3://$BUCKET_NAME/assets/ --content-type "application/javascript" --exclude "*" --include "*.js" --metadata-directive REPLACE
aws s3 sync s3://$BUCKET_NAME/assets/ s3://$BUCKET_NAME/assets/ --content-type "text/css" --exclude "*" --include "*.css" --metadata-directive REPLACE

# Create CloudFront invalidation (optional)
echo ""
echo -e "${YELLOW}Creating CloudFront invalidation...${NC}"
echo -e "${BLUE}💡 You'll need your CloudFront distribution ID${NC}"
read -p "Enter CloudFront Distribution ID (or press Enter to skip): " DISTRIBUTION_ID

if [ ! -z "$DISTRIBUTION_ID" ]; then
    aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ CloudFront invalidation created${NC}"
    else
        echo -e "${YELLOW}⚠️ CloudFront invalidation failed (check distribution ID)${NC}"
    fi
fi

echo ""
echo -e "${GREEN}🎉 DEPLOYMENT COMPLETE!${NC}"
echo ""
echo -e "${BLUE}Final Steps:${NC}"
echo "1. ✅ Files uploaded to S3"
echo "2. Configure CloudFront error pages in AWS Console:"
echo "   - 403 Error → /index.html → Response Code 200"
echo "   - 404 Error → /index.html → Response Code 200"
echo "3. Wait 10-15 minutes for CloudFront to propagate"
echo "4. Test your site: https://koda.kocreators.com/"
echo ""
echo -e "${YELLOW}💡 If you still see a white screen after 15 minutes, check browser console (F12) for errors${NC}"