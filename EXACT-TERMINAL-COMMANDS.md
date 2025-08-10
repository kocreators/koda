# 🚀 **EXACT COMMANDS TO COPY & PASTE**

## **DON'T copy the ```bash parts - just copy the actual commands!**

You currently tried to run:
```
```bash
rm -rf node_modules package-lock.json dist && npm install
npm run dev
```

**❌ This is wrong** - you're including the markdown formatting.

## **✅ CORRECT COMMANDS TO RUN:**

### **Step 1: Copy and paste this EXACT line:**
```
rm -rf node_modules package-lock.json dist && npm install
```

### **Step 2: After Step 1 completes, copy and paste this:**
```
npm run dev
```

### **Step 3: Open your browser to:**
```
http://localhost:5173/koda/
```

## **🎯 What Each Command Does:**
1. **rm -rf node_modules package-lock.json dist** - Cleans old installations
2. **npm install** - Installs all dependencies from package.json
3. **npm run dev** - Starts development server with hot reload

## **📋 Expected Output:**
After `npm install`, you should see:
```
added 234 packages, and audited 235 packages in 15s
```

After `npm run dev`, you should see:
```
VITE v6.0.1  ready in 500 ms

➜  Local:   http://localhost:5173/koda/
➜  Network: use --host to expose
```

## **🔧 If You Get Errors:**

### **If npm install fails:**
```
npm install --legacy-peer-deps
```

### **If you get permission errors:**
```
sudo npm install
```

### **If port 5173 is busy:**
```
npm run dev -- --port 3000
```
Then visit: http://localhost:3000/koda/

### **To check if Node.js is installed:**
```
node --version
npm --version
```

## **🎉 Success Checklist:**
- [ ] `npm install` completes without errors
- [ ] `npm run dev` shows "VITE ready" message  
- [ ] Browser shows your Koda app at localhost:5173/koda/
- [ ] You can see the Design Prompt Builder interface
- [ ] No red errors in browser console (press F12)