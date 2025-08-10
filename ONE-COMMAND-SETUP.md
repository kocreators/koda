# ⚡ **ONE-COMMAND LOCAL SETUP**

## **Option 1: Automated Setup Script**
```bash
curl -sSL https://raw.githubusercontent.com/figma/make-examples/main/koda-setup.sh | bash
```

## **Option 2: Manual Quick Setup** 
Copy and paste this entire block into your terminal:

```bash
# Create project and setup
mkdir koda-ai-generator && cd koda-ai-generator

# Create package.json
cat > package.json << 'EOF'
{
  "name": "koda-ai-logo-generator",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
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
    "@types/react": "^18.3.12",
    "@types/react-dom": "^18.3.1",
    "@vitejs/plugin-react": "^4.3.4",
    "typescript": "~5.6.2",
    "vite": "^6.0.1",
    "@tailwindcss/vite": "^4.0.0-beta.5"
  }
}
EOF

# Install dependencies
npm install

# Create vite config
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
  }
})
EOF

# Create directories
mkdir -p components/{ui,figma} types styles

# Create environment
echo "VITE_PLUGGER_API_KEY=V3A3y007DBgtsqo7" > .env

# Create basic tsconfig
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020", "DOM", "DOM.Iterable"], 
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "baseUrl": ".",
    "paths": {"@/*": ["./*"]}
  },
  "include": ["*.tsx", "*.ts", "components/**/*", "types/**/*"]
}
EOF

echo "✅ Koda project setup complete!"
echo "📁 Project location: $(pwd)"
echo ""  
echo "🔧 Next steps:"
echo "1. Copy your component files from Figma Make"
echo "2. Run 'npm run dev' to start development"
echo "3. Visit http://localhost:5173/koda/"
```

## **Option 3: Clone from GitHub (If you have repo)**
```bash
git clone [your-github-repo-url] koda-ai-generator
cd koda-ai-generator
npm install
npm run dev
```

## **🎯 After Setup - File Copying**
You'll need to manually copy these files from your Figma Make project:

### **Essential Files (Copy These First):**
1. `App.tsx` - Main application component
2. `main.tsx` - React entry point
3. `index.html` - HTML template
4. `styles/globals.css` - Global styles

### **Component Files:**
5. `components/DesignPromptBuilder.tsx`
6. `components/LogoGenerator.tsx` 
7. `components/PricingChatbot.tsx`
8. `types/index.ts`

### **UI Components (Copy entire ui folder):**
9. All files from `components/ui/` 

## **🧪 Test Your Setup**
```bash
# Start development
npm run dev

# Build for production  
npm run build

# Test production build
npm run preview
```

## **📊 Success Indicators:**
- ✅ `npm run dev` starts without errors
- ✅ http://localhost:5173/koda/ shows your app
- ✅ `npm run build` completes successfully
- ✅ No TypeScript compilation errors

## **🔧 Common Issues & Fixes:**
```bash
# If modules not found
npm install

# If TypeScript errors
npm run build -- --skipLibCheck

# If Tailwind not working
npm install -D @tailwindcss/vite

# If API not working
cat .env  # Should show your API key
```

**🚀 You'll have a fully functional local development environment in under 5 minutes!**