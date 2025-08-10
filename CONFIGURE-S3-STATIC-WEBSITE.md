# 🌐 **CONFIGURE S3 BUCKET FOR STATIC WEBSITE HOSTING**

## **Step 1: Enable Static Website Hosting**
```bash
aws s3 website s3://koda-logo-generator-jordanbremond-2025 --index-document index.html --error-document index.html
```

---

## **Step 2: Make Bucket Publicly Readable**
### **Create bucket policy JSON:**
```bash
cat > bucket-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::koda-logo-generator-jordanbremond-2025/*"
    }
  ]
}
EOF
```

### **Apply the bucket policy:**
```bash
aws s3api put-bucket-policy --bucket koda-logo-generator-jordanbremond-2025 --policy file://bucket-policy.json
```

---

## **Step 3: Disable Block Public Access (if needed)**
```bash
aws s3api put-public-access-block --bucket koda-logo-generator-jordanbremond-2025 --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
```

---

## **Step 4: Test Your Deployment**

### **Get the S3 website endpoint:**
```bash
echo "Your S3 website URL:"
echo "http://koda-logo-generator-jordanbremond-2025.s3-website-us-east-1.amazonaws.com/koda/"
```

### **Test with curl:**
```bash
curl -I http://koda-logo-generator-jordanbremond-2025.s3-website-us-east-1.amazonaws.com/koda/
```

**Expected result:** HTTP 200 response

---

## **Step 5: Test CloudFront Distribution**
```bash
echo "Your CloudFront URL:"
echo "https://d3d8ucpm7p01n7.cloudfront.net/koda/"
```

### **Test CloudFront:**
```bash
curl -I https://d3d8ucpm7p01n7.cloudfront.net/koda/
```

---

## **🎯 If your files are already uploaded, these commands will make them accessible!**