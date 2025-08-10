import { useState } from 'react';

interface DesignPromptBuilderProps {
  onPromptGenerated: (prompt: string) => void;
}

export default function DesignPromptBuilder({ onPromptGenerated }: DesignPromptBuilderProps) {
  const [selectedStyles, setSelectedStyles] = useState<string[]>([]);
  const [logoText, setLogoText] = useState('');
  const [colors, setColors] = useState('');
  const [elements, setElements] = useState('');

  const styleOptions = [
    'Minimalist',
    'Vintage/Retro', 
    'Modern/Contemporary',
    'Abstract',
    'Text-Only/Wordmark',
    'Playful/Cartoonish',
    'Luxury/Elegant'
  ];

  const toggleStyle = (style: string) => {
    setSelectedStyles(prev => 
      prev.includes(style) 
        ? prev.filter(s => s !== style)
        : [...prev, style]
    );
  };

  const generatePrompt = () => {
    if (!logoText.trim()) {
      alert('Please enter text for your logo');
      return;
    }

    let prompt = `Create a ${selectedStyles.length > 0 ? selectedStyles.join(', ') : 'modern'} logo design`;
    prompt += ` with the text "${logoText}"`;
    
    if (colors.trim()) {
      prompt += ` using colors: ${colors}`;
    }
    
    if (elements.trim()) {
      prompt += ` incorporating elements: ${elements}`;
    }
    
    prompt += '. Professional, clean, and suitable for business use.';
    
    onPromptGenerated(prompt);
  };

  return (
    <div className="koda-container">
      {/* Hero Section */}
      <div className="koda-hero">
        <h1 className="koda-title">CREATE YOUR DESIGN</h1>
        <p className="koda-subtitle">
          Answer a few quick questions and we'll help you generate the perfect AI prompt for your custom logo design.
        </p>
      </div>

      {/* Main Card */}
      <div className="koda-card">
        {/* Card Header */}
        <div className="koda-card-header">
          <h2>Logo Design Questionnaire</h2>
        </div>

        {/* Card Content */}
        <div className="koda-card-content">
          {/* Question 1: Style */}
          <div className="koda-question">
            <label>
              1. What's your design style? <span className="koda-optional">(select one or more)</span>
            </label>
            <div className="koda-button-group">
              {styleOptions.map((style) => (
                <button
                  key={style}
                  onClick={() => toggleStyle(style)}
                  className={`koda-style-button ${selectedStyles.includes(style) ? 'selected' : ''}`}
                >
                  {style}
                </button>
              ))}
            </div>
          </div>

          {/* Question 2: Text */}
          <div className="koda-question">
            <label>2. What text do you want to appear in the logo?</label>
            <input
              type="text"
              value={logoText}
              onChange={(e) => setLogoText(e.target.value)}
              placeholder="E.g., Mountain Peak, AI"
              className="koda-input"
            />
          </div>

          {/* Question 3: Colors */}
          <div className="koda-question">
            <label>
              3. Are there specific colors you want in the design? <span className="koda-optional">(optional)</span>
            </label>
            <input
              type="text"
              value={colors}
              onChange={(e) => setColors(e.target.value)}
              placeholder="E.g., blue, gold, black, []"
              className="koda-input"
            />
          </div>

          {/* Question 4: Elements */}
          <div className="koda-question">
            <label>
              4. Do you have icons or elements you want in the design? <span className="koda-optional">(optional)</span>
            </label>
            <input
              type="text"
              value={elements}
              onChange={(e) => setElements(e.target.value)}
              placeholder="E.g., mountain, star, tea"
              className="koda-input"
            />
          </div>

          {/* Generate Button */}
          <div className="koda-button-container">
            <button onClick={generatePrompt} className="koda-generate-button">
              ✨ Generate My Design Prompt
            </button>
          </div>
        </div>
      </div>

      {/* Footer */}
      <div className="koda-footer">
        <p>
          Powered by <span className="koda-brand">Kocreators</span> • Custom merchandise printing solutions
        </p>
      </div>
    </div>
  );
}