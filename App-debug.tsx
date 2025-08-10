import React, { useState, useEffect } from 'react';
import DesignPromptBuilder from './components/DesignPromptBuilder';
import LogoGenerator from './components/LogoGenerator';
import PricingChatbot from './components/PricingChatbot';
import type { CurrentStep } from './types';

export default function App() {
  const [currentStep, setCurrentStep] = useState<CurrentStep>('prompt');
  const [generatedPrompt, setGeneratedPrompt] = useState('');
  const [isChatbotOpen, setIsChatbotOpen] = useState(false);
  const [debugInfo, setDebugInfo] = useState('');

  useEffect(() => {
    // Debug information
    const debug = {
      apiKey: import.meta.env.VITE_PLUGGER_API_KEY ? 'Found' : 'Missing',
      env: import.meta.env.MODE,
      timestamp: new Date().toISOString(),
      userAgent: navigator.userAgent,
      location: window.location.href
    };
    
    setDebugInfo(JSON.stringify(debug, null, 2));
    console.log('🔧 Koda Debug Info:', debug);
    
    // Test if React is working
    console.log('✅ React App successfully loaded!');
  }, []);

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

  // Error boundary fallback
  try {
    return (
      <div className="min-h-screen bg-gray-50">
        {/* Debug panel - remove after fixing */}
        <div className="bg-yellow-100 border border-yellow-400 p-4 m-4 rounded">
          <h3 className="font-bold text-yellow-800">🔧 Debug Information:</h3>
          <pre className="text-xs text-yellow-700 mt-2 overflow-auto">
            {debugInfo}
          </pre>
          <div className="mt-2">
            <button 
              onClick={() => setCurrentStep('prompt')}
              className="bg-blue-500 text-white px-3 py-1 rounded mr-2 text-sm"
            >
              Step 1: Prompt Builder
            </button>
            <button 
              onClick={() => setCurrentStep('generate')}
              className="bg-green-500 text-white px-3 py-1 rounded mr-2 text-sm"
            >
              Step 2: Logo Generator
            </button>
            <button 
              onClick={() => setIsChatbotOpen(true)}
              className="bg-purple-500 text-white px-3 py-1 rounded text-sm"
            >
              Step 3: Pricing Chat
            </button>
          </div>
        </div>

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
  } catch (error) {
    console.error('🚨 React Error:', error);
    return (
      <div className="min-h-screen bg-red-50 p-8">
        <h1 className="text-2xl font-bold text-red-800 mb-4">🚨 Application Error</h1>
        <p className="text-red-600 mb-4">Something went wrong. Check the browser console for details.</p>
        <pre className="bg-red-100 p-4 rounded text-sm text-red-800 overflow-auto">
          {error instanceof Error ? error.message : String(error)}
        </pre>
        <button 
          onClick={() => window.location.reload()}
          className="mt-4 bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700"
        >
          🔄 Reload Page
        </button>
      </div>
    );
  }
}