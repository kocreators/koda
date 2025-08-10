# 🎨 Koda Logo Generator - Deployment to kocreators.com/koda

## Quick Start

### 1. Prerequisites
- AWS Account configured
- Node.js 18+ installed
- AWS CLI installed and configured

### 2. Configure Your Environment
Update the deployment script variables:
```bash
# In deploy-koda-subdirectory.sh
BUCKET_NAME="your-kocreators-koda-bucket"
CLOUDFRONT_DISTRIBUTION_ID="your-distribution-id"
```

### 3. Deploy
```bash
# Make script executable
chmod +x deploy-koda-subdirectory.sh

# Deploy
npm run deploy
```

## Manual Deployment Steps

### 1. Build
```bash
npm install
npm run build
```

### 2. Upload to S3
```bash
aws s3 sync dist/ s3://your-bucket-name/ --delete
```

### 3. Invalidate CloudFront (if applicable)
```bash
aws cloudfront create-invalidation --distribution-id YOUR_ID --paths "/koda/*"
```

## File Structure After Build
```
dist/
├── index.html          # Main entry point
├── assets/             # CSS, JS, and other assets
│   ├── index-[hash].js # Main JavaScript bundle
│   └── index-[hash].css # Compiled CSS
└── favicon.svg         # App icon
```

## Environment Variables

### For GitHub Actions
Set these secrets in your repository settings:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `S3_BUCKET_NAME`
- `CLOUDFRONT_DISTRIBUTION_ID` (optional)
- `VITE_API_KEY` (your logo generation API key)

### For Local Development
Create `.env.local`:
```env
VITE_API_KEY=your_api_key_here
```

## Testing Your Deployment

Visit these URLs to verify everything works:
- https://kocreators.com/koda
- https://kocreators.com/koda/ (with trailing slash)

Test all features:
- ✅ Logo generation
- ✅ Image selection
- ✅ Pricing chatbot
- ✅ Quote generation
- ✅ Email functionality

## Troubleshooting

### Common Issues:

**1. 404 Errors on Refresh**
- Ensure CloudFront has custom error pages configured
- Error 403/404 should redirect to `/koda/index.html` with 200 status

**2. Assets Not Loading**
- Verify base path in `vite.config.ts` is set to `/koda/`
- Check S3 bucket permissions

**3. API Calls Failing**
- Verify CORS settings allow kocreators.com
- Check API key in environment variables

**4. Blank Page**
- Check browser console for JavaScript errors
- Verify all dependencies are installed

### Performance Optimization

1. **CloudFront Settings**
   - Enable compression
   - Set appropriate cache headers
   - Use CachingOptimized policy for assets

2. **S3 Configuration**
   - Enable transfer acceleration (optional)
   - Set up lifecycle policies for old versions

## Monitoring

### AWS CloudWatch Metrics to Monitor:
- S3 bucket requests
- CloudFront cache hit ratio
- API call volume
- Error rates

### Recommended Alerts:
- High error rates (>5%)
- Unusual API usage spikes
- S3 storage costs

## Security Considerations

1. **API Key Protection**
   - Store in environment variables only
   - Rotate keys regularly
   - Monitor API usage

2. **S3 Bucket Security**
   - Only allow public read access
   - Block public write access
   - Enable logging

3. **CloudFront Security**
   - Force HTTPS redirects
   - Set security headers
   - Consider WAF for additional protection

## Cost Management

Expected monthly costs for moderate traffic (10,000 visits):
- **S3 Storage**: $0.50-2.00
- **CloudFront**: $1.00-5.00
- **Data Transfer**: $0.50-3.00

**Total**: ~$2-10/month

## Support

For deployment issues:
1. Check the GitHub Actions logs
2. Verify AWS credentials and permissions
3. Test locally with `npm run preview`
4. Contact AWS support for infrastructure issues

---

🚀 **Your Koda Logo Generator is ready to deploy to kocreators.com/koda!**
```