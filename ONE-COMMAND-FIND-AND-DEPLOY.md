# ⚡ **ONE COMMAND TO FIND PROJECT AND DEPLOY**

## **Copy and paste this single command:**

```bash
PROJECT_DIR=$(find ~ -name "App.tsx" -type f 2>/dev/null | head -1 | xargs dirname) && cd "$PROJECT_DIR" && echo "Found project at: $(pwd)" && ls -la && npm install && npm run build && aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/koda/ --delete && echo "🎉 Koda deployed successfully!"
```

**This command will:**
1. 🔍 Find your project directory automatically
2. 📁 Navigate to it
3. 📦 Install dependencies
4. 🔨 Build your app
5. 🚀 Deploy to S3
6. ✅ Confirm success

---

## **What you'll see:**

### **When it finds your project:**
```
Found project at: /home/cloudshell-user/your-project-path
-rw-r--r-- 1 user user 1234 Aug 10 App.tsx
-rw-r--r-- 1 user user 5678 Aug 10 package.json
drwxr-xr-x 2 user user 4096 Aug 10 components
```

### **When it builds successfully:**
```
✓ built in 2.34s
```

### **When it deploys successfully:**
```
upload: dist/index.html to s3://koda-logo-generator-jordanbremond-2025/koda/index.html
upload: dist/assets/index-abc123.js to s3://...
🎉 Koda deployed successfully!
```

---

## **If the command fails:**
1. It will show you where it got stuck
2. You can then navigate manually using the path it found
3. Run the individual commands step by step

**🌐 After successful deployment, test at:**
https://d3d8ucpm7p01n7.cloudfront.net/koda/

**🎯 This solves the navigation issue AND deploys your complete Koda app in one go!**