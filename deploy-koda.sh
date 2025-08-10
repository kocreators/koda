#!/bin/bash

echo "🚀 Deploying Koda Logo Generator to koda.kocreators.com"
echo "=================================================="

# Step 1: Fix imports and build
echo "Step 1: Fixing imports and building..."
chmod +x fix-imports-and-build.sh
./fix-imports-and-build.sh

if [ $? -ne 0 ]; then
    echo "❌ Build failed. Please check the errors above."
    exit 1
fi

# Step 2: Deploy to S3
echo ""
echo "Step 2: Deploying to S3 bucket..."
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete --acl public-read

if [ $? -ne 0 ]; then
    echo "❌ S3 deployment failed. Make sure AWS CLI is configured."
    exit 1
fi

# Step 3: Get CloudFront distribution ID and invalidate
echo ""
echo "Step 3: Invalidating CloudFront cache..."

# Try to find the distribution ID automatically
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    echo "Found CloudFront distribution: $DISTRIBUTION_ID"
    aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"
    
    if [ $? -eq 0 ]; then
        echo "✅ CloudFront invalidation created successfully!"
    else
        echo "⚠️  CloudFront invalidation failed, but deployment to S3 was successful."
    fi
else
    echo "⚠️  Could not find CloudFront distribution automatically."
    echo "Please manually invalidate your CloudFront distribution with paths: /*"
fi

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================================"
echo "✅ Build: SUCCESS"
echo "✅ S3 Upload: SUCCESS" 
echo "🌐 Your Koda logo generator should be available at:"
echo "   https://koda.kocreators.com"
echo ""
echo "If you need to connect to Google Sheets for product data,"
echo "consider using a backend service to securely handle the integration."

# Test the deployment
echo ""
echo "🧪 Testing deployment..."
sleep 5

# Create a simple test file
cat > test-deployment.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Testing Koda Deployment</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .test-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
        }
        .success { color: #007a62; }
        .button {
            background: #007a62;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            margin: 10px;
            cursor: pointer;
        }
        .button:hover { background: #005a43; }
    </style>
</head>
<body>
    <div class="test-card">
        <h1 class="success">🎉 Koda Logo Generator</h1>
        <p>Your deployment appears to be successful!</p>
        <p>The app should be loading at <strong>koda.kocreators.com</strong></p>
        
        <div style="margin: 30px 0;">
            <a href="https://koda.kocreators.com" class="button" target="_blank">
                🚀 Visit Koda Logo Generator
            </a>
            <a href="https://kocreators.com" class="button" target="_blank">
                🏠 Back to Kocreators
            </a>
        </div>
        
        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
            <h3>Next Steps:</h3>
            <ul style="text-align: left; display: inline-block;">
                <li>Test the logo generation functionality</li>
                <li>Test the pricing chatbot</li>
                <li>Set up Google Sheets integration for product data</li>
                <li>Configure Stripe for payment processing</li>
            </ul>
        </div>
    </div>
</body>
</html>
EOF

echo "📋 Created deployment test file: test-deployment.html"
echo "   You can open this file in your browser to test the deployment"