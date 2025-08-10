#!/bin/bash

# Koda Logo Generator - Fix and Deploy Script
# This script fixes path issues and deploys the app

# Configuration
BUCKET_NAME="kocreators-koda-app"
CLOUDFRONT_DISTRIBUTION_ID="YOUR_DISTRIBUTION_ID"
DOMAIN="kocreators.com"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Fixing Koda Logo Generator paths and building...${NC}"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed. Please install Node.js first.${NC}"
    exit 1
fi

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📦 Installing dependencies...${NC}"
    npm install
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to install dependencies! Try running: npm install${NC}"
        exit 1
    fi
fi

# Clean previous builds
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
rm -rf dist/

# Build the application
echo -e "${YELLOW}🔨 Building Koda application...${NC}"
npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed! Please check the error messages above.${NC}"
    echo -e "${YELLOW}💡 Common fixes:${NC}"
    echo -e "   1. Make sure all dependencies are installed: npm install"
    echo -e "   2. Check that your .env file has VITE_PLUGGER_API_KEY set"
    echo -e "   3. Run npm run dev first to test for any runtime errors"
    exit 1
fi

# Check if dist folder exists
if [ ! -d "dist" ]; then
    echo -e "${RED}❌ Build directory 'dist' not found!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build successful!${NC}"

# Test the build locally first
echo -e "${YELLOW}🧪 Testing build locally...${NC}"
echo -e "${BLUE}Starting preview server at http://localhost:4173/koda/${NC}"
echo -e "${YELLOW}Press Ctrl+C when you're done testing, then we'll deploy to AWS.${NC}"

# Start preview server (this will pause the script)
npm run preview

# After user stops preview, ask if they want to deploy
echo ""
read -p "$(echo -e ${YELLOW}Deploy to AWS S3? [y/N]:${NC} )" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Check if AWS CLI is installed
    if ! command -v aws &> /dev/null; then
        echo -e "${RED}❌ AWS CLI is not installed. Please install it first.${NC}"
        exit 1
    fi

    # Upload to S3
    echo -e "${YELLOW}⬆️  Uploading to S3 bucket: ${BUCKET_NAME}...${NC}"
    aws s3 sync dist/ s3://$BUCKET_NAME/ --delete --exact-timestamps

    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ S3 upload failed! Check your AWS credentials and bucket name.${NC}"
        echo -e "${YELLOW}💡 Make sure you have:${NC}"
        echo -e "   1. AWS CLI configured: aws configure"
        echo -e "   2. Correct bucket name in this script"
        echo -e "   3. Proper S3 permissions"
        exit 1
    fi

    # Set correct permissions
    echo -e "${YELLOW}🔒 Setting S3 permissions...${NC}"
    aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "PublicReadGetObject",
                "Effect": "Allow",
                "Principal": "*",
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::'$BUCKET_NAME'/*"
            }
        ]
    }'

    # Invalidate CloudFront cache (optional)
    if [ ! -z "$CLOUDFRONT_DISTRIBUTION_ID" ] && [ "$CLOUDFRONT_DISTRIBUTION_ID" != "YOUR_DISTRIBUTION_ID" ]; then
        echo -e "${YELLOW}🔄 Invalidating CloudFront cache...${NC}"
        aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DISTRIBUTION_ID --paths "/koda/*"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ CloudFront cache invalidated!${NC}"
        else
            echo -e "${YELLOW}⚠️  CloudFront invalidation failed, but deployment was successful${NC}"
        fi
    fi

    echo ""
    echo -e "${GREEN}🎉 Deployment complete!${NC}"
    echo -e "${BLUE}🌐 Your Koda Logo Generator should be live at: https://${DOMAIN}/koda${NC}"
else
    echo -e "${BLUE}👍 Build completed successfully. You can deploy later with: aws s3 sync dist/ s3://your-bucket-name/${NC}"
fi

echo ""
echo -e "${GREEN}✅ All done!${NC}"