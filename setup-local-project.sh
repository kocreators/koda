#!/bin/bash

# 🚀 COMPLETE LOCAL KODA PROJECT SETUP
# Run this script to recreate your Koda project locally

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Setting up Koda AI Logo Generator locally...${NC}"
echo ""

# Step 1: Create project directory
PROJECT_NAME="koda-ai-generator"
echo -e "${YELLOW}Step 1: Creating project directory...${NC}"
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Step 2: Initialize package.json
echo -e "${YELLOW}Step 2: Creating package.json...${NC}"
cat > package.json << 'EOF'
{
  "name": "koda-ai-logo-generator",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "lint": "eslint .",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "lucide-react": "^0.469.0",
    "clsx": "^2.1.1",
    "class-variance-authority": "^0.7.1",
    "tailwind-merge": "^2.5.4"
  },
  "devDependencies": {
    "@eslint/js": "^9.15.0",
    "@types/react": "^18.3.12",
    "@types/react-dom": "^18.3.1",
    "@vitejs/plugin-react": "^4.3.4",
    "eslint": "^9.15.0",
    "eslint-plugin-react-hooks": "^5.0.0",
    "eslint-plugin-react-refresh": "^0.4.14",
    "globals": "^15.12.0",
    "typescript": "~5.6.2",
    "vite": "^6.0.1",
    "@tailwindcss/vite": "^4.0.0-beta.5"
  }
}
EOF

# Step 3: Create Vite config
echo -e "${YELLOW}Step 3: Creating Vite configuration...${NC}"
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

# Step 4: Create TypeScript configs
echo -e "${YELLOW}Step 4: Creating TypeScript configuration...${NC}"
cat > tsconfig.json << 'EOF'
{
  "files": [],
  "references": [
    {
      "path": "./tsconfig.app.json"
    },
    {
      "path": "./tsconfig.node.json"
    }
  ]
}
EOF

cat > tsconfig.app.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "Bundler",
    "allowImportingTsExtensions": true,
    "isolatedModules": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": [
    "src/**/*",
    "*.tsx",
    "*.ts",
    "components/**/*",
    "types/**/*"
  ]
}
EOF

cat > tsconfig.node.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["ES2023"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "Bundler",
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "noEmit": true
  },
  "include": [
    "vite.config.ts"
  ]
}
EOF

# Step 5: Create directory structure
echo -e "${YELLOW}Step 5: Creating directory structure...${NC}"
mkdir -p components/ui
mkdir -p components/figma
mkdir -p types
mkdir -p styles

# Step 6: Create environment files
echo -e "${YELLOW}Step 6: Creating environment files...${NC}"
cat > .env << 'EOF'
# Plugger AI API Key for logo generation
VITE_PLUGGER_API_KEY=V3A3y007DBgtsqo7
EOF

cat > .env.example << 'EOF'
# Plugger AI API Key for logo generation
VITE_PLUGGER_API_KEY=your_api_key_here
EOF

# Step 7: Create .gitignore
echo -e "${YELLOW}Step 7: Creating .gitignore...${NC}"
cat > .gitignore << 'EOF'
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

node_modules
dist
dist-ssr
*.local

# Editor directories and files
.vscode/*
!.vscode/extensions.json
.idea
.DS_Store
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# Environment variables
.env.local
.env.development.local
.env.test.local
.env.production.local
EOF

# Step 8: Install dependencies
echo -e "${YELLOW}Step 8: Installing dependencies...${NC}"
npm install

echo -e "${GREEN}✅ Basic project structure created!${NC}"
echo ""
echo -e "${BLUE}📋 Next steps:${NC}"
echo "1. Copy your component files to the components/ directory"
echo "2. Copy your type definitions to the types/ directory"  
echo "3. Copy your global CSS to styles/globals.css"
echo "4. Copy your main App.tsx and main.tsx files"
echo "5. Copy your index.html file"
echo ""
echo -e "${YELLOW}🔧 Manual file copying required:${NC}"
echo "You'll need to copy these files from your Figma Make project:"
echo "- App.tsx"
echo "- main.tsx" 
echo "- index.html"
echo "- components/*.tsx"
echo "- types/*.ts"
echo "- styles/globals.css"
echo ""
echo -e "${GREEN}📁 Project created in: $(pwd)${NC}"