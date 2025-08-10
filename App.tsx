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
