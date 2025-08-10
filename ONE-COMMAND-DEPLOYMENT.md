# ⚡ **ONE-COMMAND DEPLOYMENT**

## **Super Simple - Just Copy & Paste This:**

```bash
npm run build && aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/koda/ --delete && aws s3 website s3://koda-logo-generator-jordanbremond-2025 --index-document index.html && echo "🎉 Koda deployed successfully!"
```

**This single command will:**
1. Build your complete Koda app
2. Upload it to your S3 bucket  
3. Configure web hosting
4. Tell you when it's done

---

## **🌐 Your Live URL Will Be:**
```
http://koda-logo-generator-jordanbremond-2025.s3-website-[region].amazonaws.com/koda/
```

**To find your exact URL:**
```bash
aws s3api get-bucket-location --bucket koda-logo-generator-jordanbremond-2025
```

---

## **⚠️ If That Command Fails, Try Step-by-Step:**

### **Step 1:**
```bash
npm run build
```

### **Step 2:**
```bash
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/koda/ --delete
```

### **Step 3:**
```bash
aws s3 website s3://koda-logo-generator-jordanbremond-2025 --index-document index.html
```

---

## **🎯 Expected Results:**

### **After npm run build:**
```
✓ built in 2.34s
```
**You'll see a new `dist/` folder created.**

### **After s3 sync:**
```
upload: dist/index.html to s3://koda-logo-generator-jordanbremond-2025/koda/index.html
upload: dist/assets/index-abc123.js to s3://koda-logo-generator-jordanbremond-2025/koda/assets/index-abc123.js
```

### **After s3 website:**
```
Website configuration updated successfully
```

**🚀 Your complete Koda AI Logo Generator will be live on the internet!**