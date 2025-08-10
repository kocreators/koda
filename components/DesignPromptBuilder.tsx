import React, { useState } from 'react';
import { Button } from './ui/button';

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
    <div className="max-w-[700px] mx-auto mb-8 text-center px-5 py-8">
      {/* Title with responsive design */}
      <h1 className="koda-title mb-5 mt-2.5">
        <br />CREATE YOUR DESIGN
      </h1>

      <br />

      {/* Style Selection */}
      <div className="mb-2.5 text-left">
        <div className="mb-1.5 font-medium">1. What's your design style? (select one or more)</div>
        <div className="flex flex-wrap gap-2 mt-1.5 justify-center w-full">
          {styles.map((style) => (
            <Button
              key={style}
              type="button"
              onClick={() => handleStyleToggle(style)}
              variant="outline"
              className={`px-3 py-2 border border-[#007a62] cursor-pointer rounded text-sm select-none transition-colors ${
                selectedStyles.includes(style)
                  ? 'bg-[#007a62] text-white hover:bg-[#007a62] hover:text-white'
                  : 'bg-white text-[#007a62] hover:bg-[#007a62] hover:text-white'
              }`}
            >
              {style}
            </Button>
          ))}
        </div>
      </div>

      <br />

      {/* Text Input */}
      <label className="block text-left mb-2.5">
        <div className="mb-1.5 font-medium">2. What text do you want to appear in the logo?</div>
        <input 
          type="text"
          value={text}
          onChange={(e) => setText(e.target.value)}
          placeholder="E.g., Mountain Peak"
          className="w-full p-2 border border-gray-300 rounded mb-2.5 text-base focus:border-[#007a62] focus:outline-none focus:ring-2 focus:ring-[#007a62]/20 transition-colors"
        />
      </label>

      <br />

      {/* Colors Input */}
      <label className="block text-left mb-2.5">
        <div className="mb-1.5 font-medium">3. Are there specific colors you want in the design?</div>
        <input 
          type="text"
          value={colors}
          onChange={(e) => setColors(e.target.value)}
          placeholder="E.g., blue, gold, black"
          className="w-full p-2 border border-gray-300 rounded mb-2.5 text-base focus:border-[#007a62] focus:outline-none focus:ring-2 focus:ring-[#007a62]/20 transition-colors"
        />
      </label>

      <br />

      {/* Icons Input */}
      <label className="block text-left mb-2.5">
        <div className="mb-1.5 font-medium">4. Do you have icons or elements that you want to appear in the design?</div>
        <input 
          type="text"
          value={icons}
          onChange={(e) => setIcons(e.target.value)}
          placeholder="E.g., mountain, star, leaf"
          className="w-full p-2 border border-gray-300 rounded mb-2.5 text-base focus:border-[#007a62] focus:outline-none focus:ring-2 focus:ring-[#007a62]/20 transition-colors"
        />
      </label>

      {/* Generate Button */}
      <div className="text-center mt-5">
        <Button
          onClick={generatePrompt}
          className="px-6 py-3 bg-[#007a62] text-white border-none rounded cursor-pointer text-xl font-bold hover:bg-[#005a43] transition-colors shadow-lg hover:shadow-xl"
        >
          ✍️ Write My Design Prompt For Me 
        </Button>
      </div>
    </div>
  );
}