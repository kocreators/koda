# 🧪 QUICK AWS TEST

## **Test Your S3 Bucket:**
```bash
aws s3 ls s3://koda-logo-generator-jordanbremond-2025/
```

## **Test Your Current Files:**
```bash
aws s3 ls s3://koda-logo-generator-jordanbremond-2025/koda/
```

## **Test CloudFront URL:**
```bash
curl -I https://d3d8ucpm7p01n7.cloudfront.net/koda/
```

## **Check Project Files:**
```bash
ls -la | grep -E "(App.tsx|package.json|components)"
```

---

## **Expected Results:**

### **S3 Bucket Test:**
```
2025-08-10 12:00:00     folder1/
2025-08-10 12:00:00     koda/
```

### **Current Koda Files:**
```
2025-08-10 12:00:00    index.html
2025-08-10 12:00:00    assets/
```

### **CloudFront Test:**
```
HTTP/2 200 
```

### **Project Files:**
```
-rw-r--r-- App.tsx
-rw-r--r-- package.json
drwxr-xr-x components/
```

---

## **If Any Test Fails:**
1. **S3 Access Issue:** Check AWS credentials
2. **No Koda Files:** Need to build and deploy
3. **CloudFront 404:** Files not uploaded correctly
4. **No Project Files:** Navigate to correct directory

## **Quick Directory Check:**
```bash
pwd && ls -la App.tsx
```
Should show your project path and confirm App.tsx exists.