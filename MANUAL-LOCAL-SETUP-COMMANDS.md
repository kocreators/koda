# 🖥️ **MANUAL LOCAL SETUP COMMANDS**

## **Step 1: Create Project Directory**
```bash
mkdir koda-ai-generator
cd koda-ai-generator
```

## **Step 2: Initialize Node.js Project**
```bash
npm init -y
```

## **Step 3: Install Dependencies**
```bash
# Core dependencies
npm install react@^18.3.1 react-dom@^18.3.1

# UI and utility libraries
npm install lucide-react clsx class-variance-authority tailwind-merge

# Development dependencies
npm install -D @types/react @types/react-dom @vitejs/plugin-react
npm install -D vite typescript eslint @eslint/js
npm install -D eslint-plugin-react-hooks eslint-plugin-react-refresh
npm install -D globals @tailwindcss/vite
```

## **Step 4: Create Vite Configuration**
```bash
cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'
import path from 'path'

export default defineConfig({
  plugins: [react(), tailwindcss()],
  base: '/koda/',
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./"),
    },
  },
  build: {
    outDir: 'dist',
    assetsDir: 'assets'
  }
})
EOF
```

## **Step 5: Create TypeScript Configuration**
```bash
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["src", "*.tsx", "*.ts", "components/**/*", "types/**/*"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF
```

## **Step 6: Create Directory Structure**
```bash
mkdir -p components/ui
mkdir -p components/figma  
mkdir -p types
mkdir -p styles
mkdir -p src
```

## **Step 7: Create Environment File**
```bash
echo "VITE_PLUGGER_API_KEY=V3A3y007DBgtsqo7" > .env
```

## **Step 8: Create Package Scripts**
Update your `package.json` scripts section:
```bash
npm pkg set scripts.dev="vite"
npm pkg set scripts.build="tsc -b && vite build"  
npm pkg set scripts.preview="vite preview"
npm pkg set scripts.lint="eslint ."
```

## **Step 9: Create Git Repository**
```bash
git init
echo "node_modules\ndist\n.env\n*.local" > .gitignore
git add .
git commit -m "Initial Koda project setup"
```

## **Step 10: Copy Your Files**
Now manually copy these files from your Figma Make project:

### **Root Files:**
- `App.tsx` → `./App.tsx`
- `main.tsx` → `./main.tsx` 
- `index.html` → `./index.html`

### **Component Files:**
- `components/DesignPromptBuilder.tsx`
- `components/LogoGenerator.tsx`
- `components/PricingChatbot.tsx`
- `components/figma/ImageWithFallback.tsx`
- All `components/ui/*.tsx` files

### **Type Files:**
- `types/index.ts`

### **Style Files:**
- `styles/globals.css`

## **Step 11: Test Local Development**
```bash
# Start development server
npm run dev

# Should open http://localhost:5173/koda/
```

## **Step 12: Test Build Process**
```bash
# Build for production
npm run build

# Test production build
npm run preview
```

## **🚀 Quick Setup Script Alternative**
Or just run the setup script I created:
```bash
curl -o setup.sh https://raw.githubusercontent.com/[your-repo]/setup-local-project.sh
chmod +x setup.sh
./setup.sh
```

## **🔧 Troubleshooting**
If you get errors:
1. **TypeScript errors:** `npm run build -- --skipLibCheck`
2. **Module not found:** Check your import paths
3. **Tailwind not working:** Make sure `@tailwindcss/vite` is installed
4. **API not working:** Check `.env` file has correct API key

## **📁 Final Project Structure**
```
koda-ai-generator/
├── package.json
├── vite.config.ts  
├── tsconfig.json
├── .env
├── .gitignore
├── App.tsx
├── main.tsx
├── index.html
├── components/
│   ├── DesignPromptBuilder.tsx
│   ├── LogoGenerator.tsx
│   ├── PricingChatbot.tsx
│   ├── figma/
│   │   └── ImageWithFallback.tsx
│   └── ui/
│       └── [shadcn components]
├── types/
│   └── index.ts
└── styles/
    └── globals.css
```