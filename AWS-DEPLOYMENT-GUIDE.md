# 🚀 AWS Deployment Guide - Logo Generator

## Option 1: AWS Amplify (Recommended - Easiest) ⭐

### Prerequisites

- AWS Account
- GitHub account
- Your code pushed to a GitHub repository

### Step 1: Push Your Code to GitHub

```bash
# Initialize git (if not already done)
git init
git add .
git commit -m "Initial commit - Logo Generator App"

# Create repository on GitHub and push
git remote add origin https://github.com/YOUR_USERNAME/logo-generator.git
git branch -M main
git push -u origin main
```

### Step 2: Deploy with AWS Amplify

1. **Login to AWS Console**

   - Go to [AWS Console](https://console.aws.amazon.com)
   - Search for "Amplify" in the services search

2. **Create New App**

   - Click "Create new app"
   - Select "Host web app"
   - Choose "GitHub" as source

3. **Connect Repository**

   - Authenticate with GitHub
   - Select your logo-generator repository
   - Choose "main" branch
   - Click "Next"

4. **Configure Build Settings**

   - Amplify auto-detects React + Vite
   - Build command: `npm run build`
   - Output directory: `dist`
   - Node version: Latest (18 or 20)
   - Click "Next"

5. **Review & Deploy**
   - Review settings
   - Click "Save and deploy"
   - Wait 3-5 minutes for deployment

### Step 3: Add Environment Variables (Optional)

If you want to hide your API key:

1. In Amplify Console → Your App → Environment variables
2. Add: `VITE_API_KEY` = `V3A3y007DBgtsqo7`
3. Redeploy the app

### Step 4: Custom Domain (Optional)

1. In Amplify Console → Domain management
2. Click "Add domain"
3. Enter your domain name
4. Follow DNS verification steps

---

## Option 2: AWS S3 + CloudFront (Most Cost-Effective) 💰

### Step 1: Build Your Application Locally

```bash
npm install
npm run build
```

### Step 2: Create S3 Bucket

1. **Go to S3 Console**

   - Search "S3" in AWS Console
   - Click "Create bucket"

2. **Configure Bucket**

   - Bucket name: `your-logo-generator` (must be globally unique)
   - Region: Choose closest to your users
   - **Uncheck "Block all public access"** ⚠️
   - Acknowledge the warning
   - Click "Create bucket"

3. **Enable Static Website Hosting**
   - Select your bucket → Properties tab
   - Scroll to "Static website hosting"
   - Click "Edit" → "Enable"
   - Index document: `index.html`
   - Error document: `index.html` (for React Router support)
   - Save changes

### Step 3: Upload Your Built Files

1. **Upload Files**

   - Select your bucket → Objects tab
   - Click "Upload"
   - Drag and drop all files from your `dist` folder
   - Make sure to upload the folder contents, not the folder itself
   - Click "Upload"

2. **Set Public Permissions**
   - Select your bucket → Permissions tab
   - Click "Bucket policy"
   - Paste this policy (replace YOUR-BUCKET-NAME):

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
        }
    ]
}
```

### Step 4: Create CloudFront Distribution

1. **Go to CloudFront Console**

   - Search "CloudFront" in AWS Console
   - Click "Create distribution"

2. **Configure Distribution**

   - **Origin domain**: Select your S3 bucket from dropdown
   - **Origin path**: Leave empty
   - **Name**: Auto-filled
   - **Origin access**: "Origin access control settings"
   - Click "Create control setting" → Create

3. **Default Cache Behavior**

   - **Viewer protocol policy**: "Redirect HTTP to HTTPS"
   - **Allowed HTTP methods**: "GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE"
   - **Cache policy**: "CachingOptimized"

4. **Settings**

   - **Price class**: "Use all edge locations" (or choose based on budget)
   - **Custom error pages**: Add these for React Router support:
     - Error code: 403, Response page path: `/index.html`, HTTP Response code: 200
     - Error code: 404, Response page path: `/index.html`, HTTP Response code: 200

5. **Create Distribution**
   - Click "Create distribution"
   - Wait 10-15 minutes for deployment

### Step 5: Update S3 Bucket Policy for CloudFront

1. Go back to S3 → Your bucket → Permissions → Bucket policy
2. Replace with this policy (CloudFront provides the exact policy):

```json
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::ACCOUNT-ID:distribution/DISTRIBUTION-ID"
                }
            }
        }
    ]
}
```

---

## Post-Deployment Steps 🎯

### Test Your Application

1. Visit your CloudFront domain URL or Amplify URL
2. Test logo generation
3. Test pricing chatbot
4. Verify all images load properly

### Set Up Custom Domain (Optional)

**For Amplify**: Use Amplify's domain management
**For CloudFront**:

1. Get SSL certificate from AWS Certificate Manager
2. Add custom domain in CloudFront settings
3. Update your DNS records

### Monitor Costs 💸

- **Amplify**: ~$1-5/month for small apps
- **S3 + CloudFront**: ~$0.50-2/month for small traffic

### Security Considerations 🔒

1. **API Key Security**: Move to environment variables
2. **CORS**: Your API should allow your domain
3. **HTTPS**: Both options provide SSL automatically

---

## Updating Your Application 🔄

### Amplify (Automatic)

- Push changes to GitHub
- Amplify automatically rebuilds and deploys

### S3 + CloudFront (Manual)

1. Build locally: `npm run build`
2. Upload new files to S3 bucket (overwrite existing)
3. Invalidate CloudFront cache:
   - Go to CloudFront → Your distribution → Invalidations
   - Create invalidation with path: `/*`
   - Wait 5-10 minutes

---

## Troubleshooting 🔧

### Common Issues:

1. **Blank page**: Check browser console for errors
2. **API not working**: Verify CORS settings
3. **Images not loading**: Check file paths and permissions
4. **React Router 404s**: Ensure error page redirects are set up

### Support:

- AWS documentation: https://docs.aws.amazon.com/
- Amplify docs: https://docs.amplify.aws/
- S3 static hosting: https://docs.aws.amazon.com/s3/latest/userguide/WebsiteHosting.html

---

## Cost Estimates 📊

### Monthly costs for moderate traffic (10,000 visits):

- **Amplify**: $1-5/month
- **S3 + CloudFront**: $0.50-2/month
- **Custom domain**: $12/year (Route 53)
- **SSL Certificate**: Free with both options

Choose Amplify for simplicity, S3+CloudFront for cost optimization!