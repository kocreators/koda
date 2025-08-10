# 🔧 Fix White Screen: AWS CloudFront Configuration for Koda

## 🎯 **Most Likely Causes of White Screen**

### **1. Missing CloudFront Error Pages (90% of cases)**
### **2. Incorrect S3 file structure** 
### **3. CloudFront cache serving old version**
### **4. Base path mismatch**

---

## ✅ **Quick Fix Checklist**

### **Step 1: Verify S3 File Structure**
Your S3 bucket should look like this:
```
📁 your-s3-bucket/
└── 📁 koda/
    ├── 📄 index.html
    ├── 📁 assets/
    │   ├── 📄 main-[hash].js
    │   ├── 📄 main-[hash].css
    │   └── 📄 other-assets...
    └── 📄 favicon.svg
```

**❌ Wrong:** Files in root bucket  
**✅ Right:** Files in `/koda/` folder

### **Step 2: Configure CloudFront Error Pages**
This is the **#1 missing piece** that causes white screens:

1. **Go to AWS CloudFront Console**
2. **Select your distribution**
3. **Click "Error Pages" tab**
4. **Click "Create Custom Error Response"**

**Add these two error pages:**

**Error Page 1:**
- **HTTP Error Code:** `403`
- **Response Page Path:** `/koda/index.html`
- **HTTP Response Code:** `200`
- **TTL:** `300`

**Error Page 2:**
- **HTTP Error Code:** `404`
- **Response Page Path:** `/koda/index.html`
- **HTTP Response Code:** `200`
- **TTL:** `300`

### **Step 3: Check Origin Configuration**
1. **Go to "Origins" tab**
2. **Origin Domain:** Your S3 bucket domain
3. **Origin Path:** Leave **EMPTY** (not `/koda`)
4. **Origin Access:** Use OAC (Origin Access Control)

### **Step 4: Check Behavior Configuration**
1. **Go to "Behaviors" tab**
2. **Path Pattern:** `*` (default)
3. **Origin:** Your S3 origin
4. **Viewer Protocol Policy:** Redirect HTTP to HTTPS
5. **Allowed HTTP Methods:** GET, HEAD
6. **Cache Policy:** Managed-CachingOptimized

---

## 🔍 **Diagnostic Steps**

### **Test These URLs:**

1. **https://koda.kocreators.com/**
   - Should show your app
   - If white screen: CloudFront error pages issue

2. **https://koda.kocreators.com/index.html**
   - Should show same app
   - If 404: S3 file structure issue

3. **Browser Dev Tools → Console**
   - Should have no errors
   - If errors: Missing files or CORS issues

4. **Browser Dev Tools → Network**
   - All files should load (200 status)
   - If 403/404: Files not uploaded correctly

---

## 🚀 **Quick Commands to Test**

```bash
# Test if site is accessible
curl -I https://koda.kocreators.com/

# Check if files exist
curl -s https://koda.kocreators.com/index.html | head -5

# Check CloudFront headers
curl -I https://koda.kocreators.com/ | grep -i cache
```

---

## 🔧 **Step-by-Step Fix Process**

### **1. Fix S3 File Structure (if needed)**
```bash
# Re-upload with correct structure
aws s3 sync dist/ s3://your-bucket/koda/ --delete
```

### **2. Add CloudFront Error Pages**
- **AWS Console → CloudFront → Your Distribution → Error Pages**
- **Add 403 and 404 redirects to `/koda/index.html`**

### **3. Invalidate CloudFront Cache**
```bash
# Create invalidation
aws cloudfront create-invalidation --distribution-id YOUR_DIST_ID --paths "/*"
```
Or in AWS Console:
- **CloudFront → Your Distribution → Invalidations → Create**
- **Paths:** `/*`

### **4. Wait and Test**
- **Wait 5-15 minutes** for CloudFront propagation
- **Test:** https://koda.kocreators.com/

---

## 🎯 **Most Common Issue Resolution**

**90% of white screen issues are fixed by adding CloudFront Error Pages.**

### **Why This Happens:**
1. User visits `https://koda.kocreators.com/`
2. CloudFront looks for file at root: `/index.html`
3. File doesn't exist (it's at `/koda/index.html`)
4. S3 returns 403/404 error
5. CloudFront shows error page (blank by default)
6. **Solution:** Redirect errors to `/koda/index.html`

---

## 📞 **Still Having Issues?**

### **Check These:**

1. **Domain Configuration**
   - Does `koda.kocreators.com` point to CloudFront?
   - CNAME record correct?

2. **SSL Certificate**
   - Certificate covers `koda.kocreators.com`?
   - Certificate in `us-east-1` region?

3. **Browser Cache**
   - Try incognito/private mode
   - Clear browser cache

4. **API Key Issues**
   - App loads but logo generation fails?
   - Check browser console for API errors

---

## ✅ **Success Indicators**

When fixed, you should see:
- ✅ **App loads** at https://koda.kocreators.com/
- ✅ **No console errors** in browser dev tools
- ✅ **All assets load** (CSS, JS files)
- ✅ **Logo generation works** (if API key configured)

**The fix is usually just adding those two CloudFront error pages! 🎉**