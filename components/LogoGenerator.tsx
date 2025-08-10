import { useState, useEffect } from 'react';
import { Button } from './ui/button';
import { Textarea } from './ui/textarea';
import { Progress } from './ui/progress';
import type { LogoGenerationPayload, LogoGenerationResponse, LogoResultResponse } from '../types';

interface LogoGeneratorProps {
  initialPrompt?: string;
  onRequestQuote: () => void;
}

export default function LogoGenerator({ initialPrompt = '', onRequestQuote }: LogoGeneratorProps) {
  const [prompt, setPrompt] = useState(initialPrompt);
  const [isGenerating, setIsGenerating] = useState(false);
  const [progress, setProgress] = useState(0);
  const [statusMessage, setStatusMessage] = useState('');
  const [images, setImages] = useState<string[]>([]);
  const [selectedImageUrl, setSelectedImageUrl] = useState<string | null>(null);
  
  // Get API key from environment variables
  const apiKey = import.meta.env.VITE_PLUGGER_API_KEY;
  
  // Update prompt when initialPrompt changes
  useEffect(() => {
    if (initialPrompt) {
      setPrompt(initialPrompt);
      // Add a subtle animation to highlight the generated prompt
      const textarea = document.querySelector('textarea');
      if (textarea) {
        textarea.style.boxShadow = '0 0 10px 2px #007a62';
        setTimeout(() => {
          textarea.style.boxShadow = '';
        }, 3000);
      }
    }
  }, [initialPrompt]);

  const statusMessages = [
    "About to drop a logo so hot, it'll melt your screen (just don't sue us). 🔥",
    "Serving up a design so fresh, it needs its own theme song! 🎵 🎶",
    "Making sure your logo won't embarrass you at the review meeting 🎉😎",
    "Ghosting bad ideas like a toxic ex 💔",
    "Kicking out ugly ideas like bad party guests at midnight 🚪👋"
  ];

  useEffect(() => {
    let interval: NodeJS.Timeout;
    let messageInterval: NodeJS.Timeout;
    
    if (isGenerating) {
      let messageIndex = 0;
      setStatusMessage(statusMessages[0]);
      
      messageInterval = setInterval(() => {
        messageIndex = (messageIndex + 1) % statusMessages.length;
        setStatusMessage(statusMessages[messageIndex]);
      }, 3500);
      
      interval = setInterval(() => {
        setProgress(prev => {
          if (prev < 95) {
            return prev + Math.random() * 1.5;
          }
          return prev;
        });
      }, 150);
    }
    
    return () => {
      clearInterval(interval);
      clearInterval(messageInterval);
    };
  }, [isGenerating]);

  const generateLogos = async () => {
    // Check if API key is available
    if (!apiKey) {
      alert('API key not found. Please check your environment configuration.');
      return;
    }

    if (!prompt.trim()) {
      alert('Please enter a prompt first.');
      return;
    }

    setIsGenerating(true);
    setProgress(0);
    setImages([]);
    setSelectedImageUrl(null);

    const payload: LogoGenerationPayload = {
      tool: 'stock photo',
      term: `${prompt}, create the entire logo on a plain white background`,
      promptEnhancing: true,
      size: '1:1'
    };

    try {
      const jobIds: string[] = await Promise.all(
        Array(4).fill(null).map(() =>
          fetch('https://studio.api.plugger.ai/run', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': apiKey
            },
            body: JSON.stringify(payload)
          })
          .then(res => res.json() as Promise<LogoGenerationResponse>)
          .then(data => data.job_id)
        )
      );

      const generatedImages = await Promise.all(
        jobIds.map(id => new Promise<string | null>(resolve => {
          let attempts = 0;
          const poll = () => {
            fetch(`https://studio.api.plugger.ai/result?job_id=${id}`, {
              headers: { 'x-api-key': apiKey }
            })
              .then(res => res.json())
              .then(data => {
                if (data[0]?.image_url) return resolve(data[0].image_url);
                if (attempts++ < 20) setTimeout(poll, 1500);
                else resolve(null);
              }).catch(() => resolve(null));
          };
          poll();
        }))
      );

      setProgress(100);
      setStatusMessage('Select a logo to continue:');
      setImages(generatedImages.filter(Boolean) as string[]);
      setIsGenerating(false);

      if (!generatedImages.some(Boolean)) {
        setStatusMessage('No logos generated. Try again.');
      }
    } catch (err) {
      setProgress(0);
      setStatusMessage('An error occurred. Please try again.');
      setIsGenerating(false);
      console.error(err);
    }
  };

  const saveImage = () => {
    if (!selectedImageUrl) {
      alert('Please select a logo first.');
      return;
    }
    window.open(selectedImageUrl, '_blank');
  };

  const requestEditsEmail = () => {
    if (!selectedImageUrl) {
      alert('Please select a logo first.');
      return;
    }
    const subject = encodeURIComponent('Koda Art Edit Request');
    const body = encodeURIComponent(
      `Dear Koda Art Team:\n\nPlease make the following edits to this logo: \n\n[Enter specific edit requests here. Text and color changes are free.\nFor extensive design edits (like changing artwork), a $29 art fee may apply.\nWe'll confirm any charges before starting. The fee includes up to 3 revisions—additional changes can be quoted if needed.]\n\n[Optional But Helpful: Enter name, and phone number here]\n\nLink to art file: \n${selectedImageUrl}`
    );
    window.location.href = `mailto:sales@kocreators.com?subject=${subject}&body=${body}`;
  };

  return (
    <div className="max-w-4xl mx-auto p-5 text-center bg-gray-50 min-h-screen">
      <h1 className="text-4xl font-black text-[#007a62] uppercase tracking-wide mb-5 drop-shadow-md">
        🎨 Review & Edit Your Final Prompt
      </h1>
      
      <Textarea
        value={prompt}
        onChange={(e) => setPrompt(e.target.value)}
        placeholder="Type your logo prompt here."
        className="min-h-[100px] text-base font-semibold border-2 border-[#007a62] mb-4 transition-shadow"
        rows={4}
      />
      
      <div className="mb-5">
        <Button 
          onClick={generateLogos}
          disabled={isGenerating}
          className="bg-[#007a62] hover:bg-[#005a43] text-white px-6 py-3 text-lg font-semibold min-w-[200px]"
        >
          🪄 Create My Logo Design!
        </Button>
      </div>

      {isGenerating && (
        <div className="mb-5">
          <div className="text-lg font-semibold text-gray-700 mb-2 font-mono">
            {statusMessage}
          </div>
          <div className="w-full bg-gray-200 rounded-lg h-9 relative overflow-hidden">
            <Progress value={progress} className="h-full" />
            <div className="absolute inset-0 flex items-center justify-center text-white font-semibold">
              {Math.floor(progress)}%
            </div>
          </div>
        </div>
      )}

      {!isGenerating && statusMessage && (
        <div className="text-lg font-semibold text-gray-700 mb-4 font-mono">
          {statusMessage}
        </div>
      )}

      {images.length > 0 && (
        <div className="flex flex-wrap gap-4 justify-center mb-5">
          {images.map((url, index) => (
            <img
              key={index}
              src={url}
              alt={`Logo option ${index + 1}`}
              className={`max-w-[45%] cursor-pointer border-2 rounded-lg p-2 shadow-md transition-all ${
                selectedImageUrl === url 
                  ? 'border-4 border-green-500' 
                  : 'border-transparent hover:border-gray-300'
              }`}
              onClick={() => setSelectedImageUrl(url)}
            />
          ))}
        </div>
      )}

      {selectedImageUrl && (
        <div className="flex flex-wrap gap-3 justify-center">
          <Button 
            onClick={saveImage}
            className="bg-green-600 hover:bg-green-700 text-white px-6 py-3"
          >
            💾 Save Image (Opens in New Tab)
          </Button>
          <Button 
            onClick={requestEditsEmail}
            className="bg-yellow-600 hover:bg-yellow-700 text-white px-6 py-3"
          >
            ✉️ Request Edits
          </Button>
          <Button 
            onClick={generateLogos}
            className="bg-yellow-600 hover:bg-yellow-700 text-white px-6 py-3"
          >
            🔄 Generate More Like This
          </Button>
          <Button 
            onClick={onRequestQuote}
            className="bg-[#007a62] hover:bg-[#005a43] text-white px-6 py-3"
          >
            💬 Request a Quote
          </Button>
        </div>
      )}
    </div>
  );
}