#!/bin/bash

# Koda Logo Generator - Subdirectory Deployment Script
# Deploys to kocreators.com/koda

# Configuration - Update these values for your setup
BUCKET_NAME="kocreators-koda-app"
CLOUDFRONT_DISTRIBUTION_ID="YOUR_DISTRIBUTION_ID"
DOMAIN="kocreators.com"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting Koda Logo Generator deployment to ${DOMAIN}/koda...${NC}"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed. Please install Node.js first.${NC}"
    exit 1
fi

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📦 Installing dependencies...${NC}"
    npm install
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to install dependencies!${NC}"
        exit 1
    fi
fi

# Build the application
echo -e "${YELLOW}🔨 Building Koda application for subdirectory deployment...${NC}"
npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi

# Check if dist folder exists
if [ ! -d "dist" ]; then
    echo -e "${RED}❌ Build directory 'dist' not found!${NC}"
    exit 1
fi

# Upload to S3
echo -e "${YELLOW}⬆️  Uploading to S3 bucket: ${BUCKET_NAME}...${NC}"
aws s3 sync dist/ s3://$BUCKET_NAME/ --delete --exact-timestamps

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ S3 upload failed! Check your AWS credentials and bucket name.${NC}"
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
else
    echo -e "${YELLOW}⚠️  CloudFront distribution ID not set, skipping cache invalidation${NC}"
fi

echo ""
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${BLUE}🌐 Your Koda Logo Generator should be live at: https://${DOMAIN}/koda${NC}"
echo ""
echo -e "${YELLOW}📝 Features deployed:${NC}"
echo -e "   • ✅ Design Prompt Builder (Step 1)"
echo -e "   • ✅ AI Logo Generator (Step 2)" 
echo -e "   • ✅ Pricing Chatbot (Step 3)"
echo -e "   • ✅ Email integration for quotes and edits"
echo ""
echo -e "${YELLOW}📋 Next steps:${NC}"
echo -e "   1. Test the full user flow at https://${DOMAIN}/koda"
echo -e "   2. Verify design prompt builder → logo generation flow"
echo -e "   3. Test pricing chatbot functionality"
echo -e "   4. Update CloudFront distribution ID in this script for cache management"
echo -e "   5. Configure analytics and monitoring if needed"
echo ""
echo -e "${GREEN}🎉 Your complete Koda Logo Generator is ready!${NC}"