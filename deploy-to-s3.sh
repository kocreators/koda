#!/bin/bash

# AWS S3 Deployment Script for Logo Generator
# Make sure AWS CLI is installed and configured

# Configuration - Update these values
BUCKET_NAME="your-logo-generator-bucket"
CLOUDFRONT_DISTRIBUTION_ID="YOUR_DISTRIBUTION_ID"

echo "🚀 Starting deployment to AWS S3..."

# Build the application
echo "📦 Building application..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

# Upload to S3
echo "⬆️  Uploading to S3..."
aws s3 sync dist/ s3://$BUCKET_NAME --delete --exact-timestamps

if [ $? -ne 0 ]; then
    echo "❌ S3 upload failed!"
    exit 1
fi

# Invalidate CloudFront cache (optional)
if [ ! -z "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
    echo "🔄 Invalidating CloudFront cache..."
    aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DISTRIBUTION_ID --paths "/*"
    
    if [ $? -eq 0 ]; then
        echo "✅ CloudFront cache invalidated!"
    else
        echo "⚠️  CloudFront invalidation failed, but deployment was successful"
    fi
fi

echo "✅ Deployment complete!"
echo "🌐 Your app should be live at: https://$BUCKET_NAME.s3-website-us-east-1.amazonaws.com"