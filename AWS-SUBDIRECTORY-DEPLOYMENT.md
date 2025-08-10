# 🚀 AWS Subdirectory Deployment Guide - kocreators.com/koda

## Overview
This guide will help you deploy your Koda logo generator to **kocreators.com/koda** as a subdirectory of your main website.

## Option 1: AWS S3 + CloudFront (Recommended for Subdirectory)

### Prerequisites
- Existing kocreators.com website
- AWS Account with existing CloudFront distribution (if applicable)
- AWS CLI configured

### Step 1: Build for Subdirectory
Your app is already configured with `base: '/koda/'` in vite.config.ts

```bash
npm install
npm run build
```

### Step 2: Upload to S3

#### Option A: New S3 Bucket Approach
1. **Create S3 Bucket**
   - Bucket name: `kocreators-koda-app`
   - Region: Same as your main site
   - Enable static website hosting
   - Index document: `index.html`
   - Error document: `index.html`

2. **Upload Built Files**
   ```bash
   aws s3 sync dist/ s3://kocreators-koda-app/ --delete
   ```

3. **Set Bucket Policy**
   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Sid": "PublicReadGetObject",
               "Effect": "Allow",
               "Principal": "*",
               "Action": "s3:GetObject",
               "Resource": "arn:aws:s3:::kocreators-koda-app/*"
           }
       ]
   }
   ```

#### Option B: Existing S3 Bucket (if you have one for kocreators.com)
1. **Upload to subfolder**
   ```bash
   aws s3 sync dist/ s3://your-existing-bucket/koda/ --delete
   ```

### Step 3: CloudFront Configuration

#### If you have existing CloudFront distribution for kocreators.com:

1. **Add New Origin**
   - Origin domain: Your S3 bucket endpoint
   - Origin path: `/koda` (if using existing bucket) or empty (if new bucket)
   - Origin ID: `koda-app-origin`

2. **Create Cache Behavior**
   - Path pattern: `/koda/*`
   - Origin: Select your new origin
   - Viewer protocol policy: Redirect HTTP to HTTPS
   - Allowed HTTP methods: GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE
   - Cache policy: CachingDisabled (for dynamic content) or CachingOptimized
   - Precedence: Set higher than default (e.g., 0)

3. **Add Custom Error Pages for React Router**
   - Error code: 403 → Response page: `/koda/index.html` → HTTP code: 200
   - Error code: 404 → Response page: `/koda/index.html` → HTTP code: 200

#### If creating new CloudFront distribution:
Follow the standard CloudFront setup but set the origin to your S3 bucket.

### Step 4: Deploy Script for Easy Updates

Create `deploy-koda.sh`:
```bash
#!/bin/bash

BUCKET_NAME="kocreators-koda-app"  # or your existing bucket
CLOUDFRONT_DISTRIBUTION_ID="YOUR_DISTRIBUTION_ID"
S3_PATH="s3://$BUCKET_NAME/"  # or "s3://existing-bucket/koda/" for subfolder

echo "🚀 Building Koda app..."
npm run build

echo "⬆️  Uploading to S3..."
aws s3 sync dist/ $S3_PATH --delete --exact-timestamps

if [ ! -z "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
    echo "🔄 Invalidating CloudFront cache..."
    aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DISTRIBUTION_ID --paths "/koda/*"
fi

echo "✅ Deployment complete!"
echo "🌐 Visit: https://kocreators.com/koda"
```

---

## Option 2: AWS Amplify (Alternative)

### Step 1: Amplify Configuration
1. **Create new Amplify app**
   - Connect your repository
   - Build settings:
     ```yaml
     version: 1
     frontend:
       phases:
         preBuild:
           commands:
             - npm ci
         build:
           commands:
             - npm run build
       artifacts:
         baseDirectory: dist
         files:
           - '**/*'
       cache:
         paths:
           - node_modules/**/*
     ```

2. **Set up Subdirectory**
   - In Amplify Console → App settings → General
   - Set custom domain: kocreators.com
   - Subdomain: koda

### Step 2: Domain Configuration
1. **Add Domain**
   - Domain name: kocreators.com
   - Subdomain: koda
   - SSL certificate: Amplify provides automatically

---

## Option 3: Integration with Existing Website

If you have an existing website at kocreators.com:

### Step 1: Reverse Proxy Setup (if using Apache/Nginx)

#### Nginx Configuration
Add to your nginx.conf:
```nginx
location /koda {
    proxy_pass https://your-s3-bucket.s3-website-region.amazonaws.com;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    
    # Handle React Router
    try_files $uri $uri/ /koda/index.html;
}
```

#### Apache Configuration
Add to your .htaccess or virtual host:
```apache
ProxyPreserveHost On
ProxyPass /koda/ https://your-s3-bucket.s3-website-region.amazonaws.com/
ProxyPassReverse /koda/ https://your-s3-bucket.s3-website-region.amazonaws.com/

# React Router fallback
RewriteEngine On
RewriteRule ^koda/(.*)$ /koda/index.html [L]
```

---

## Testing Your Deployment

### URLs to Test:
- https://kocreators.com/koda (main app)
- https://kocreators.com/koda/ (with trailing slash)
- Direct navigation to any deep links should work

### Checklist:
- ✅ Logo generator loads
- ✅ API calls work from kocreators.com domain
- ✅ Pricing chatbot opens and functions
- ✅ All assets (CSS, JS, images) load correctly
- ✅ React Router navigation works
- ✅ No mixed content warnings (HTTP/HTTPS)

---

## CORS Configuration

Make sure your logo generation API allows requests from kocreators.com:

```javascript
// If you control the API, add this header:
Access-Control-Allow-Origin: https://kocreators.com
```

---

## Environment Variables for Production

Create `.env.production`:
```env
VITE_API_KEY=V3A3y007DBgtsqo7
VITE_BASE_URL=https://kocreators.com/koda
```

---

## Monitoring & Analytics

Consider adding:
1. **Google Analytics** for usage tracking
2. **AWS CloudWatch** for performance monitoring
3. **Error tracking** (Sentry, etc.)

---

## Cost Optimization

For subdirectory hosting:
- **S3 storage**: ~$0.50-2/month
- **CloudFront**: ~$1-5/month
- **Data transfer**: Varies by usage

Total estimated cost: **$1.50-7/month** for moderate traffic.

---

## Maintenance

### Regular Updates:
1. Run `./deploy-koda.sh` after changes
2. Monitor CloudFront cache hit rates
3. Update API keys as needed
4. Check for broken links monthly

### Backup Strategy:
- S3 versioning enabled
- Source code in Git
- Database backups (if added later)

🎉 **Your Koda app will be live at https://kocreators.com/koda!**