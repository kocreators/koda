#!/bin/bash
set -e

echo "🎨 KODA COMPLETE STYLING UPDATE"
echo "=============================="
echo ""

# Kill any running dev servers
echo "🔄 Stopping any running dev servers..."
pkill -f "vite\|npm.*dev\|yarn.*dev" 2>/dev/null || true
sleep 1

# Clean any build artifacts
echo "🧹 Cleaning build artifacts..."
rm -rf dist/ node_modules/.vite/ 2>/dev/null || true

echo ""
echo "📝 UPDATING APP.TSX WITH CSS CLASSES..."

# Update App.tsx to use CSS classes
cat > App.tsx << 'EOF'
import { useState } from 'react';
import DesignPromptBuilder from './components/DesignPromptBuilder';
import LogoGenerator from './components/LogoGenerator';
import PricingChatbot from './components/PricingChatbot';
import type { CurrentStep } from './types';

export default function App() {
  const [currentStep, setCurrentStep] = useState<CurrentStep>('prompt');
  const [generatedPrompt, setGeneratedPrompt] = useState('');
  const [isChatbotOpen, setIsChatbotOpen] = useState(false);

  const handlePromptGenerated = (prompt: string) => {
    setGeneratedPrompt(prompt);
    setCurrentStep('generate');
  };

  const handleBackToPromptBuilder = () => {
    setCurrentStep('prompt');
    setGeneratedPrompt('');
  };

  const handleRequestQuote = () => {
    setIsChatbotOpen(true);
  };

  const handleCloseChatbot = () => {
    setIsChatbotOpen(false);
  };

  return (
    <div className="koda-app">
      {/* Header - only show when not on prompt step for cleaner design */}
      {currentStep !== 'prompt' && (
        <header className="koda-header">
          <div className="koda-header-container">
            <div className="koda-header-content">
              <div className="koda-header-brand">
                <h1 className="koda-title koda-title-small">
                  Koda Logo Generator
                </h1>
              </div>
              <div className="koda-header-powered">
                Powered by Kocreators
              </div>
            </div>
          </div>
        </header>
      )}

      {/* Main Content */}
      <main className="koda-main">
        {currentStep === 'prompt' && (
          <DesignPromptBuilder onPromptGenerated={handlePromptGenerated} />
        )}
        
        {currentStep === 'generate' && (
          <div className="koda-generator-container">
            {/* Back button */}
            <div className="koda-back-button-container">
              <button
                onClick={handleBackToPromptBuilder}
                className="koda-back-button"
              >
                <svg className="koda-back-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
                </svg>
                Back to Design Builder
              </button>
            </div>
            
            <LogoGenerator 
              initialPrompt={generatedPrompt}
              onRequestQuote={handleRequestQuote} 
            />
          </div>
        )}
        
        {/* Pricing Chatbot Overlay */}
        <PricingChatbot isOpen={isChatbotOpen} onClose={handleCloseChatbot} />
      </main>

      {/* Footer - only show when not on prompt step */}
      {currentStep !== 'prompt' && (
        <footer className="koda-app-footer">
          <div className="koda-app-footer-container">
            <div className="koda-app-footer-content">
              <p className="koda-app-footer-text">
                © 2025 Kocreators. All rights reserved. | Custom merchandise printing and logo design solutions.
              </p>
            </div>
          </div>
        </footer>
      )}
    </div>
  );
}
EOF

echo "✅ App.tsx updated with CSS classes"

echo ""
echo "📝 UPDATING DESIGNPROMPTBUILDER.TSX..."

# Update DesignPromptBuilder.tsx to use pure CSS classes
cat > components/DesignPromptBuilder.tsx << 'EOF'
import { useState } from 'react';

interface DesignPromptBuilderProps {
  onPromptGenerated: (prompt: string) => void;
}

export default function DesignPromptBuilder({ onPromptGenerated }: DesignPromptBuilderProps) {
  const [selectedStyles, setSelectedStyles] = useState<string[]>([]);
  const [text, setText] = useState('');
  const [colors, setColors] = useState('');
  const [icons, setIcons] = useState('');

  const styles = [
    "Minimalist",
    "Vintage/Retro", 
    "Modern/Contemporary",
    "Abstract",
    "Text-Only/Wordmark",
    "Playful/Cartoonish",
    "Luxury/Elegant",
  ];

  const handleStyleToggle = (style: string) => {
    setSelectedStyles(prev => 
      prev.includes(style) 
        ? prev.filter(s => s !== style)
        : [...prev, style]
    );
  };

  const generatePrompt = () => {
    if (!text.trim()) {
      alert("Please enter the text you want in your logo.");
      return;
    }

    let promptParts: string[] = [];

    if (selectedStyles.length > 0) {
      promptParts.push(selectedStyles.join(", ") + " style");
    } else {
      promptParts.push("A stylish");
    }

    promptParts.push(`logo featuring the text '${text}'`);

    if (icons.trim()) {
      promptParts.push(`with elements like ${icons}`);
    }

    if (colors.trim()) {
      promptParts.push(`using colors such as ${colors}`);
    }

    promptParts.push("on a plain white background");

    const prompt = promptParts.join(", ") + ".";
    onPromptGenerated(prompt);
  };

  return (
    <div className="koda-container">
      <div className="koda-hero">
        <h1 className="koda-title">CREATE YOUR DESIGN</h1>
        <p className="koda-subtitle">
          Answer a few quick questions and we'll help you generate the perfect AI prompt for your custom logo design.
        </p>
      </div>

      <div className="koda-card">
        <div className="koda-card-header">
          <h2>Logo Design Questionnaire</h2>
        </div>
        
        <div className="koda-card-content">
          {/* Question 1: Design Style */}
          <div className="koda-question">
            <label>
              1. What's your design style? <span className="koda-optional">(select one or more)</span>
            </label>
            <div className="koda-button-group">
              {styles.map((style) => (
                <button
                  key={style}
                  type="button"
                  onClick={() => handleStyleToggle(style)}
                  className={`koda-style-button ${selectedStyles.includes(style) ? 'selected' : ''}`}
                >
                  {style}
                </button>
              ))}
            </div>
          </div>

          {/* Question 2: Text */}
          <div className="koda-question">
            <label htmlFor="logo-text">
              2. What text do you want to appear in the logo?
            </label>
            <input
              id="logo-text"
              type="text"
              value={text}
              onChange={(e) => setText(e.target.value)}
              placeholder="E.g., Mountain Peak, Acme Corp, Your Business Name"
              className="koda-input"
            />
          </div>

          {/* Question 3: Colors */}
          <div className="koda-question">
            <label htmlFor="logo-colors">
              3. Are there specific colors you want in the design? <span className="koda-optional">(optional)</span>
            </label>
            <input
              id="logo-colors"
              type="text"
              value={colors}
              onChange={(e) => setColors(e.target.value)}
              placeholder="E.g., blue, gold, black, forest green"
              className="koda-input"
            />
          </div>

          {/* Question 4: Icons */}
          <div className="koda-question">
            <label htmlFor="logo-icons">
              4. Do you have icons or elements you want in the design? <span className="koda-optional">(optional)</span>
            </label>
            <input
              id="logo-icons"
              type="text"
              value={icons}
              onChange={(e) => setIcons(e.target.value)}
              placeholder="E.g., mountain, star, leaf, geometric shapes"
              className="koda-input"
            />
          </div>

          {/* Generate Button */}
          <div className="koda-button-container">
            <button onClick={generatePrompt} className="koda-generate-button">
              ✍️ Generate My Design Prompt
            </button>
          </div>
        </div>
      </div>

      <div className="koda-footer">
        <p>
          Powered by <span className="koda-brand">Kocreators</span> • Custom merchandise printing solutions
        </p>
      </div>
    </div>
  );
}
EOF

echo "✅ DesignPromptBuilder.tsx updated with pure CSS classes"

echo ""
echo "📝 ADDING MISSING CSS CLASSES TO GLOBALS.CSS..."

# Add the missing CSS classes for App.tsx to globals.css
cat >> styles/globals.css << 'EOF'

/* App.tsx Component Styles */
@layer components {
  .koda-app {
    min-height: 100vh;
    background-color: #f9fafb;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  }

  .koda-header {
    background-color: #ffffff;
    box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
  }

  .koda-header-container {
    max-width: 80rem;
    margin: 0 auto;
    padding: 0 1rem;
  }

  .koda-header-content {
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 4rem;
  }

  .koda-header-brand {
    display: flex;
    align-items: center;
  }

  .koda-title-small {
    font-size: 1.5rem !important;
    margin: 0 !important;
  }

  .koda-header-powered {
    font-size: 0.875rem;
    color: #6b7280;
  }

  .koda-main {
    position: relative;
  }

  .koda-generator-container {
    min-height: 100vh;
    background-color: #f9fafb;
  }

  .koda-back-button-container {
    text-align: center;
    padding-top: 1.5rem;
    padding-bottom: 1rem;
  }

  .koda-back-button {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    color: var(--kocreators-primary);
    text-decoration: underline;
    font-weight: 600;
    background-color: transparent;
    border: none;
    cursor: pointer;
    font-size: 1rem;
    transition: color 0.2s ease;
    font-family: inherit;
  }

  .koda-back-button:hover {
    color: var(--kocreators-primary-dark);
  }

  .koda-back-icon {
    width: 1rem;
    height: 1rem;
  }

  .koda-app-footer {
    margin-top: 4rem;
    background-color: #111827;
    color: #ffffff;
  }

  .koda-app-footer-container {
    max-width: 80rem;
    margin: 0 auto;
    padding: 0 1rem 2rem;
  }

  .koda-app-footer-content {
    text-align: center;
  }

  .koda-app-footer-text {
    font-size: 0.875rem;
    color: #d1d5db;
    margin: 0;
  }
}
EOF

echo "✅ Added missing CSS classes to globals.css"

echo ""
echo "🔨 TESTING BUILD..."

# Test the build
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed! Check the errors above."
    exit 1
fi

echo "✅ Build successful!"

echo ""
echo "🧪 TESTING LOCAL DEVELOPMENT..."

# Start dev server in background for quick test
npm run dev &
DEV_PID=$!

# Wait a moment for server to start
sleep 3

# Check if dev server is running
if kill -0 $DEV_PID 2>/dev/null; then
    echo "✅ Dev server started successfully"
    echo "🌐 Testing at http://localhost:8080"
    
    # Kill the dev server
    kill $DEV_PID 2>/dev/null
    sleep 1
else
    echo "❌ Dev server failed to start"
    exit 1
fi

echo ""
echo "🚀 DEPLOYING TO PRODUCTION..."

# Deploy to S3 with no cache
aws s3 sync dist/ s3://koda-logo-generator-jordanbremond-2025 --delete \
    --cache-control "no-cache, must-revalidate, max-age=0"

if [ $? -ne 0 ]; then
    echo "❌ S3 upload failed"
    exit 1
fi

echo "✅ S3 upload successful!"

# Clear CloudFront cache
echo ""
echo "🔄 Clearing CloudFront cache..."

DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName, 'koda-logo-generator-jordanbremond-2025')].Id" --output text 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*" >/dev/null
    echo "✅ CloudFront cache cleared"
    
    CUSTOM_DOMAIN=$(aws cloudfront get-distribution --id "$DISTRIBUTION_ID" --query "Distribution.DistributionConfig.Aliases.Items[0]" --output text 2>/dev/null)
else
    echo "⚠️  CloudFront distribution not found"
fi

echo ""
echo "🎉 KODA STYLING UPDATE COMPLETE!"
echo "================================"
echo ""

if [ "$CUSTOM_DOMAIN" != "None" ] && [ "$CUSTOM_DOMAIN" != "null" ] && [ -n "$CUSTOM_DOMAIN" ]; then
    echo "🌐 Your beautiful Koda is live at:"
    echo "   https://$CUSTOM_DOMAIN"
else
    echo "🌐 Check your CloudFront distribution for the URL"
fi

echo ""
echo "✨ What's Updated:"
echo "  🎨 App.tsx now uses CSS classes instead of inline styles"
echo "  💚 DesignPromptBuilder.tsx uses pure CSS classes"
echo "  📋 Added all missing CSS classes to globals.css"
echo "  🏗️  Build tested and working"
echo "  🚀 Deployed to production"
echo ""
echo "🎯 Your Koda should now have beautiful, consistent styling!"
echo "🚨 Use incognito/private browsing to see changes immediately!"

echo ""
echo "🧪 Quick test commands:"
echo "  Local: npm run dev"
echo "  Live:  Open https://koda.kocreators.com in incognito mode"
EOF

chmod +x update-everything-now.sh

echo "✅ Script created successfully!"
echo ""
echo "🚀 RUN THE COMPLETE UPDATE NOW:"
echo "   ./update-everything-now.sh"
echo ""
echo "This script will:"
echo "  ✅ Update App.tsx to use CSS classes"
echo "  ✅ Update DesignPromptBuilder.tsx with clean CSS"
echo "  ✅ Add missing CSS classes to globals.css"
echo "  ✅ Test the build"
echo "  ✅ Deploy to production"
echo "  ✅ Clear CloudFront cache"