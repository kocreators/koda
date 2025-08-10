# 🚨 **IMMEDIATE WHITE SCREEN FIX**

## **The Problem:**
CloudFront is serving cached broken files or the build has incorrect paths for the `/koda` subdirectory.

## **Step 1: Clear CloudFront Cache**
```bash
aws cloudfront create-invalidation --distribution-id EXXXXXXXXXXXXXXX --paths "/*"
```
*(Replace EXXXXXXXXXXXXXXX with your actual CloudFront distribution ID)*

## **Step 2: Check Your Vite Config**
First, let's see your current vite config:
```bash
cat vite.config.ts
```

## **Step 3: Fix Vite Config for Subdirectory**
Your vite.config.ts should look like this for the `/koda` subdirectory:
```typescript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  base: '/koda/',
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    rollupOptions: {
      output: {
        manualChunks: undefined,
      },
    },
  },
})
```

## **Step 4: Rebuild and Redeploy**
```bash
rm -rf dist/
npm run build
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025/koda/ --delete
```

## **Step 5: Force CloudFront Cache Clear**
```bash
aws cloudfront create-invalidation --distribution-id EXXXXXXXXXXXXXXX --paths "/koda/*" "/koda/index.html" "/koda/assets/*"
```

## **🌐 Then test these URLs:**
- https://d3d8ucpm7p01n7.cloudfront.net/koda/
- https://d3d8ucpm7p01n7.cloudfront.net/koda/index.html

**🎉 Your complete Koda app should load with the Design Prompt Builder form!**