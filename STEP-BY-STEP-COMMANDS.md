# 📋 **COPY & PASTE THESE COMMANDS ONE BY ONE**

## **First, make sure you're in the right directory:**
```bash
ls -la App.tsx
```
**Expected result:** Should show your App.tsx file details

---

## **1. Clean Installation**
```bash
rm -rf node_modules package-lock.json dist
```

## **2. Install Dependencies**
```bash
npm install
```
**Expected result:** Should install packages without major errors

---

## **3. Start Development Server**
```bash
npm run dev
```
**Expected result:** 
```
VITE v6.0.1  ready in 234 ms
➜  Local:   http://localhost:5173/koda/
```

---

## **4. Open Your Browser**
Visit: **http://localhost:5173/koda/**

**Expected result:** Your Koda logo generator should load

---

## **🎯 If Step 2 Fails, Try This Instead:**
```bash
npm install --legacy-peer-deps
```

## **🎯 If You Want to Test Production Build:**
```bash
npm run build
cd dist
python3 -m http.server 8000
```
Then visit: **http://localhost:8000/koda/**

---

## **🔍 Troubleshooting:**

### **Check if Node.js is installed:**
```bash
node --version
npm --version
```
Should show version numbers like `v18.17.0` and `9.6.7`

### **If you see "command not found":**
Install Node.js from: https://nodejs.org/

### **If you see TypeScript errors:**
```bash
npm run build -- --skipLibCheck
```

### **If port 5173 is busy:**
```bash
npm run dev -- --port 3001
```
Then visit: **http://localhost:3001/koda/**

---

## **🎉 Success Checklist:**
- [ ] `npm install` completes successfully
- [ ] `npm run dev` starts without errors  
- [ ] Browser shows your Koda app at localhost:5173/koda/
- [ ] You can see the "Design Prompt Builder" interface
- [ ] No red errors in browser console (F12)

**You're ready to develop locally!** 🚀