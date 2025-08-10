import React, { useState } from 'react';
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
    <div className="min-h-screen bg-gray-50">
      {currentStep === 'prompt' && (
        <DesignPromptBuilder onPromptGenerated={handlePromptGenerated} />
      )}
      
      {currentStep === 'generate' && (
        <>
          {/* Back button */}
          <div className="text-center pt-5 mb-4">
            <button
              onClick={handleBackToPromptBuilder}
              className="text-[#007a62] hover:text-[#005a43] underline text-lg font-semibold"
            >
              ← Back to Design Builder
            </button>
          </div>
          
          <LogoGenerator 
            initialPrompt={generatedPrompt}
            onRequestQuote={handleRequestQuote} 
          />
        </>
      )}
      
      <PricingChatbot isOpen={isChatbotOpen} onClose={handleCloseChatbot} />
    </div>
  );
}