# ⚡ INSTANT KODA TEST

## **Copy and paste this one command:**

```bash
echo "Testing Koda deployment..." && curl -I https://d3d8ucpm7p01n7.cloudfront.net/koda/ 2>/dev/null | head -1 && echo "Files in S3:" && aws s3 ls s3://koda-logo-generator-jordanbremond-2025/koda/ && echo "Project status:" && [ -f App.tsx ] && echo "✅ In project dir" || echo "❌ Wrong directory"
```

**This will instantly show:**
- ✅ If CloudFront is working (HTTP 200)
- 📁 What files are in S3
- 📍 If you're in the right directory

---

## **If you see "❌ Wrong directory":**

```bash
find ~ -name "App.tsx" -type f 2>/dev/null | head -1 | xargs dirname | xargs cd && pwd
```

---

## **If you see files in S3 but CloudFront fails:**

Run this to rebuild and redeploy:
```bash
npm install && npm run build && aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/koda/ --delete
```

---

## **Expected working result:**

```
HTTP/1.1 200 OK
Files in S3:
2025-08-10 index.html
2025-08-10 assets/index-abc123.js
2025-08-10 assets/index-def456.css
✅ In project dir
```

**Then visit:** https://d3d8ucpm7p01n7.cloudfront.net/koda/

---

## **🎯 Your complete three-step Koda app should work:**
1. **Design Prompt Builder** - Business form
2. **Logo Generator** - AI prompt + mock logo  
3. **Pricing Chatbot** - Interactive quotes

**All ready for kocreators.com/koda integration!**