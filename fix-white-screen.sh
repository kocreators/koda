#!/bin/bash

# 🔧 COMPREHENSIVE WHITE SCREEN FIX SCRIPT
# This script will diagnose and fix the white screen issue

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔧 KODA WHITE SCREEN FIX SCRIPT${NC}"
echo "=============================================="
echo ""

# Step 1: Check if we're in the right directory
if [ ! -f "App.tsx" ] || [ ! -f "package.json" ]; then
    echo -e "${RED}❌ ERROR: Run this script from your Koda project directory${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Found Koda project files${NC}"

# Step 2: Check current vite.config.ts
echo -e "${YELLOW}Step 1: Checking Vite configuration...${NC}"
if [ -f "vite.config.ts" ]; then
    if grep -q 'base: "/koda/"' vite.config.ts; then
        echo -e "${GREEN}✅ Vite base path correctly set to /koda/${NC}"
    else
        echo -e "${RED}❌ Vite base path not set correctly${NC}"
        echo -e "${YELLOW}💡 Fixing vite.config.ts...${NC}"
        
        # Backup existing config
        cp vite.config.ts vite.config.ts.backup
        
        # Create new config with correct base path
        cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  base: '/koda/',
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./"),
    },
  },
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    rollupOptions: {
      output: {
        manualChunks: undefined
      }
    }
  }
})
EOF
        echo -e "${GREEN}✅ Fixed vite.config.ts${NC}"
    fi
else
    echo -e "${RED}❌ vite.config.ts missing${NC}"
    echo -e "${YELLOW}💡 Creating vite.config.ts...${NC}"
    
    cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  base: '/koda/',
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./"),
    },
  },
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    rollupOptions: {
      output: {
        manualChunks: undefined
      }
    }
  }
})
EOF
    echo -e "${GREEN}✅ Created vite.config.ts${NC}"
fi

# Step 3: Check index.html
echo -e "${YELLOW}Step 2: Checking index.html...${NC}"
if [ -f "index.html" ]; then
    if grep -q '<div id="root"></div>' index.html && grep -q 'main.tsx' index.html; then
        echo -e "${GREEN}✅ index.html structure looks correct${NC}"
        
        # Check if script src is correct for Vite build
        if grep -q 'src="/koda/main.tsx"' index.html; then
            echo -e "${YELLOW}💡 Updating index.html for proper Vite build...${NC}"
            # Backup
            cp index.html index.html.backup
            
            # Fix the script src to use relative path for build
            sed -i.tmp 's|src="/koda/main.tsx"|src="/src/main.tsx"|g' index.html
            rm -f index.html.tmp
            echo -e "${GREEN}✅ Updated index.html script path${NC}"
        fi
    else
        echo -e "${RED}❌ index.html structure incorrect${NC}"
        echo -e "${YELLOW}💡 Recreating index.html...${NC}"
        
        cp index.html index.html.backup 2>/dev/null || true
        
        cat > index.html << 'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/koda/favicon.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Koda - AI Logo Generator</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF
        echo -e "${GREEN}✅ Recreated index.html${NC}"
    fi
else
    echo -e "${RED}❌ index.html missing${NC}"
    echo -e "${YELLOW}💡 Creating index.html...${NC}"
    
    cat > index.html << 'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/koda/favicon.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Koda - AI Logo Generator</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF
    echo -e "${GREEN}✅ Created index.html${NC}"
fi

# Step 4: Check .env file
echo -e "${YELLOW}Step 3: Checking environment variables...${NC}"
if [ -f ".env" ]; then
    if grep -q "VITE_PLUGGER_API_KEY" .env; then
        echo -e "${GREEN}✅ API key found in .env${NC}"
    else
        echo -e "${RED}❌ API key missing from .env${NC}"
        echo -e "${YELLOW}💡 Please add VITE_PLUGGER_API_KEY=your_key_here to .env${NC}"
    fi
else
    echo -e "${RED}❌ .env file missing${NC}"
    echo -e "${YELLOW}💡 Please create .env file with VITE_PLUGGER_API_KEY=your_key_here${NC}"
fi

# Step 5: Clean and rebuild
echo -e "${YELLOW}Step 4: Rebuilding project...${NC}"
echo "Cleaning previous build..."
rm -rf dist node_modules/.vite

echo "Installing dependencies..."
npm install

echo "Building project..."
npm run build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build successful${NC}"
    
    # Check if dist folder has correct structure
    if [ -f "dist/index.html" ]; then
        echo -e "${GREEN}✅ dist/index.html created${NC}"
        
        # Check if assets are in the right place
        if ls dist/assets/*.js 1> /dev/null 2>&1; then
            echo -e "${GREEN}✅ JavaScript assets found${NC}"
        else
            echo -e "${RED}❌ JavaScript assets missing${NC}"
        fi
        
        if ls dist/assets/*.css 1> /dev/null 2>&1; then
            echo -e "${GREEN}✅ CSS assets found${NC}"
        else
            echo -e "${YELLOW}⚠️ CSS assets not found (may be normal)${NC}"
        fi
    else
        echo -e "${RED}❌ dist/index.html not created${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Build failed${NC}"
    echo -e "${YELLOW}💡 Check the error messages above${NC}"
    exit 1
fi

# Step 6: Test local build
echo -e "${YELLOW}Step 5: Testing local build...${NC}"
if command -v python3 &> /dev/null; then
    echo "Starting local server to test build..."
    echo -e "${BLUE}🌐 Open http://localhost:8000/koda/ in your browser${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop the server when done testing${NC}"
    echo ""
    cd dist && python3 -m http.server 8000
elif command -v python &> /dev/null; then
    echo "Starting local server to test build..."
    echo -e "${BLUE}🌐 Open http://localhost:8000/koda/ in your browser${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop the server when done testing${NC}"
    echo ""
    cd dist && python -m SimpleHTTPServer 8000
else
    echo -e "${YELLOW}⚠️ Python not found. Cannot test locally.${NC}"
    echo -e "${BLUE}💡 Your build is ready. Upload the dist/ folder to S3${NC}"
fi

echo ""
echo -e "${GREEN}🎉 BUILD COMPLETE!${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "1. Upload dist/ folder contents to S3 bucket koda.kocreators.com"
echo "2. Make sure files go to the ROOT of the bucket (not in a /koda/ folder)"
echo "3. Set CloudFront error pages:"
echo "   - 403 Error → /index.html → Response Code 200"
echo "   - 404 Error → /index.html → Response Code 200"
echo "4. Create CloudFront invalidation: /*"
echo "5. Wait 10-15 minutes and test your site!"