# 🔍 How to Diagnose Your AWS White Screen Issue

## ✅ **Run in Your LOCAL Terminal**

The diagnostic script should be run in your **local terminal** where your Koda project files are located.

### **Why Local Terminal?**
- ✅ Checks your local `dist` folder and build files
- ✅ Verifies your local `.env` configuration  
- ✅ Tests your live website from your computer
- ✅ Doesn't require AWS CLI for basic diagnostics
- ✅ Can access your project structure

### **Step-by-Step Instructions:**

1. **Open your local terminal/command prompt**
2. **Navigate to your Koda project directory:**
   ```bash
   cd /path/to/your/koda-project
   ```

3. **Make the script executable and run it:**
   ```bash
   chmod +x diagnose-aws-deployment.sh
   ./diagnose-aws-deployment.sh
   ```

### **What the Script Will Do:**
- 🔍 Check if your `dist` folder exists and is built correctly
- 🔍 Verify your `.env` file has the API key
- 🔍 Test your live website: `https://koda.kocreators.com/`
- 🔍 Provide specific fix recommendations
- 🔍 Show you exactly what to configure in AWS CloudFront

---

## 🚨 **Most Likely Issue: CloudFront Error Pages**

Based on your setup, the white screen is almost certainly caused by **missing CloudFront error page configuration**.

### **Quick Fix (90% chance this solves it):**

1. **Go to AWS Console → CloudFront**
2. **Find your distribution for koda.kocreators.com**
3. **Click "Error Pages" tab**
4. **Add these two custom error responses:**

**Error Response #1:**
- HTTP Error Code: `403`
- Response Page Path: `/koda/index.html`
- HTTP Response Code: `200`
- TTL: `300`

**Error Response #2:**
- HTTP Error Code: `404` 
- Response Page Path: `/koda/index.html`
- HTTP Response Code: `200`
- TTL: `300`

5. **Wait 5-15 minutes for CloudFront to propagate**
6. **Test your site again**

---

## 🔧 **Alternative: Quick Manual Test**

If you want to quickly test what's wrong, open your browser and:

1. **Visit:** https://koda.kocreators.com/
   - If white screen → CloudFront error pages issue
   
2. **Visit:** https://koda.kocreators.com/index.html  
   - If this works → Confirms error pages fix needed
   - If this fails → S3 file structure issue

3. **Press F12 → Console tab**
   - Look for error messages
   - Check Network tab for failed requests

---

## 🎯 **Why This Happens:**

Your app files are uploaded to S3 at `/koda/index.html`, but when someone visits `koda.kocreators.com`, CloudFront looks for `/index.html` (at root). 

When it doesn't find the file, S3 returns a 403/404 error, and CloudFront shows a blank error page.

The solution is to tell CloudFront: "When you get a 403 or 404 error, redirect to `/koda/index.html` instead."

---

## 📞 **Still Need Help?**

Run the diagnostic script first - it will tell you exactly what's wrong:

```bash
chmod +x diagnose-aws-deployment.sh
./diagnose-aws-deployment.sh
```

The script will give you specific next steps based on what it finds! 🚀