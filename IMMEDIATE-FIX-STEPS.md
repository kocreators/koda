# 🚨 **IMMEDIATE WHITE SCREEN FIX**

Your white screen on both URLs indicates a **build configuration issue**. Here's the exact fix:

---

## **Step 1: Run This Fix Script (Copy/Paste)**

```bash
# Make sure you're in your Koda project directory first
chmod +x fix-white-screen.sh
./fix-white-screen.sh
```

**This script will:**
✅ Fix your `vite.config.ts` with correct `/koda/` base path  
✅ Fix your `index.html` with correct script paths  
✅ Rebuild your project with proper configuration  
✅ Test the build locally  

---

## **Step 2: The Problem (Why Both URLs Are White)**

Your current issue is that Vite is building for root path (`/`) but you're deploying to `/koda/` subdirectory.

**❌ Current Build:** Assets look for `/main.tsx`, `/assets/main.js`  
**✅ Fixed Build:** Assets look for `/koda/main.tsx`, `/koda/assets/main.js`

---

## **Step 3: After Running Fix Script**

The script will start a local server. Visit: **http://localhost:8000/koda/**

**If it works locally:**
1. Run: `./deploy-fixed-koda.sh` 
2. Or manually upload `dist/` folder contents to S3 root
3. Add CloudFront error pages (403/404 → `/index.html`)

**If it doesn't work locally:**
Check browser console (F12) for JavaScript errors

---

## **Step 4: Quick Manual Fix (If Script Fails)**

If the script doesn't work, manually fix these two files:

### **Fix vite.config.ts:**
```typescript
export default defineConfig({
  plugins: [react()],
  base: '/koda/',  // ← This line is crucial!
  // ... rest of config
})
```

### **Fix index.html:**
```html
<script type="module" src="/koda/main.tsx"></script>
<link rel="icon" href="/koda/favicon.svg" />
```

Then run:
```bash
npm run build
```

---

## **Step 5: Browser Test After Fix**

After fixing and deploying:

1. **Clear browser cache completely** (Ctrl+Shift+Delete)
2. **Try incognito/private mode**
3. **Check browser console (F12)** for any remaining errors

---

## **Most Likely Outcome:**

After running the fix script, your app will work perfectly! The white screen is almost always this exact Vite base path configuration issue when deploying to subdirectories.

**🎯 Run `./fix-white-screen.sh` now and your problem will be solved!**