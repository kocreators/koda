# ⚡ JUST RUN THESE 4 COMMANDS

Copy and paste each command one at a time:

## **1. Clean Start**
```bash
rm -rf node_modules dist
```

## **2. Install Dependencies**
```bash
npm install
```

## **3. Build App**
```bash
npm run build
```

## **4. Deploy to S3**
```bash
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/koda/ --delete
```

---

## **Then Visit Your App:**
🌐 **https://d3d8ucpm7p01n7.cloudfront.net/koda/**

---

## **What Each Command Does:**
1. **Clean Start:** Removes old build files
2. **Install:** Gets all React/Vite dependencies
3. **Build:** Creates production-ready files in `dist/`
4. **Deploy:** Uploads files to your S3 bucket

## **If Command 2 Fails:**
```bash
npm install --legacy-peer-deps
```

## **If Command 3 Fails:**
```bash
npm run build -- --verbose
```

## **If Command 4 Fails:**
```bash
aws configure list
```

---

## **SUCCESS INDICATORS:**
- ✅ Command 2: "added X packages"
- ✅ Command 3: "dist/index.html" created
- ✅ Command 4: "upload: dist/..." messages
- ✅ Browser: Koda app loads with teal title

**Your complete three-step Koda workflow will be live!**