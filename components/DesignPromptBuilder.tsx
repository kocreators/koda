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
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%)',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '1rem',
      fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif'
    }}>
      {/* Hero Section */}
      <div style={{ textAlign: 'center', marginBottom: '3rem', maxWidth: '56rem' }}>
        <h1 style={{
          fontWeight: 900,
          fontSize: '3rem',
          background: 'linear-gradient(135deg, #007a62 0%, #00a87d 100%)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
          backgroundClip: 'text',
          textTransform: 'uppercase',
          letterSpacing: '0.1em',
          margin: 0,
          lineHeight: 1.1,
          position: 'relative'
        }}>
          CREATE YOUR DESIGN
        </h1>
        <p style={{
          color: '#717182',
          fontSize: '1.125rem',
          maxWidth: '42rem',
          margin: '1rem auto 0',
          lineHeight: 1.6
        }}>
          Answer a few quick questions and we'll help you generate the perfect AI prompt for your custom logo design.
        </p>
      </div>

      {/* Main Card */}
      <div style={{
        width: '100%',
        maxWidth: '56rem',
        background: 'rgba(255, 255, 255, 0.95)',
        backdropFilter: 'blur(10px)',
        borderRadius: '0.75rem',
        boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)',
        border: '1px solid rgba(255, 255, 255, 0.2)'
      }}>
        {/* Card Header */}
        <div style={{
          padding: '2rem 2rem 1rem',
          textAlign: 'center',
          borderBottom: '1px solid rgba(0, 0, 0, 0.05)'
        }}>
          <h2 style={{
            fontSize: '1.5rem',
            fontWeight: 600,
            color: '#030213',
            margin: 0
          }}>Logo Design Questionnaire</h2>
        </div>

        {/* Card Content */}
        <div style={{
          padding: '2rem',
          display: 'flex',
          flexDirection: 'column',
          gap: '2rem'
        }}>
          {/* Question 1: Style */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            <label style={{ fontSize: '1.125rem', fontWeight: 600, color: '#030213' }}>
              1. What's your design style? <span style={{ color: '#717182', fontWeight: 400 }}>(select one or more)</span>
            </label>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.75rem' }}>
              {styleOptions.map((style) => (
                <button
                  key={style}
                  onClick={() => toggleStyle(style)}
                  style={{
                    fontSize: '0.875rem',
                    fontWeight: 500,
                    padding: '0.5rem 1rem',
                    borderRadius: '0.5rem',
                    border: '1px solid rgba(0, 0, 0, 0.1)',
                    background: selectedStyles.includes(style) ? '#007a62' : 'white',
                    color: selectedStyles.includes(style) ? 'white' : '#030213',
                    cursor: 'pointer',
                    transition: 'all 0.2s ease',
                    boxShadow: selectedStyles.includes(style) 
                      ? '0 4px 6px -1px rgba(0, 122, 98, 0.2)' 
                      : '0 1px 2px 0 rgba(0, 0, 0, 0.05)'
                  }}
                  onMouseEnter={(e) => {
                    if (!selectedStyles.includes(style)) {
                      e.currentTarget.style.background = '#f8fafc';
                      e.currentTarget.style.borderColor = '#007a62';
                    }
                  }}
                  onMouseLeave={(e) => {
                    if (!selectedStyles.includes(style)) {
                      e.currentTarget.style.background = 'white';
                      e.currentTarget.style.borderColor = 'rgba(0, 0, 0, 0.1)';
                    }
                  }}
                >
                  {style}
                </button>
              ))}
            </div>
          </div>

          {/* Question 2: Text */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            <label style={{ fontSize: '1.125rem', fontWeight: 600, color: '#030213' }}>
              2. What text do you want to appear in the logo?
            </label>
            <input
              type="text"
              value={logoText}
              onChange={(e) => setLogoText(e.target.value)}
              placeholder="E.g., Mountain Peak, AI"
              style={{
                height: '3rem',
                fontSize: '1rem',
                padding: '0.75rem 1rem',
                background: '#f8fafc',
                border: '1px solid rgba(0, 0, 0, 0.1)',
                borderRadius: '0.5rem',
                outline: 'none',
                fontFamily: 'inherit',
                transition: 'all 0.2s ease'
              }}
              onFocus={(e) => {
                e.currentTarget.style.borderColor = '#007a62';
                e.currentTarget.style.boxShadow = '0 0 0 2px rgba(0, 122, 98, 0.1)';
              }}
              onBlur={(e) => {
                e.currentTarget.style.borderColor = 'rgba(0, 0, 0, 0.1)';
                e.currentTarget.style.boxShadow = 'none';
              }}
            />
          </div>

          {/* Question 3: Colors */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            <label style={{ fontSize: '1.125rem', fontWeight: 600, color: '#030213' }}>
              3. Are there specific colors you want in the design? <span style={{ color: '#717182', fontWeight: 400 }}>(optional)</span>
            </label>
            <input
              type="text"
              value={colors}
              onChange={(e) => setColors(e.target.value)}
              placeholder="E.g., blue, gold, black"
              style={{
                height: '3rem',
                fontSize: '1rem',
                padding: '0.75rem 1rem',
                background: '#f8fafc',
                border: '1px solid rgba(0, 0, 0, 0.1)',
                borderRadius: '0.5rem',
                outline: 'none',
                fontFamily: 'inherit',
                transition: 'all 0.2s ease'
              }}
              onFocus={(e) => {
                e.currentTarget.style.borderColor = '#007a62';
                e.currentTarget.style.boxShadow = '0 0 0 2px rgba(0, 122, 98, 0.1)';
              }}
              onBlur={(e) => {
                e.currentTarget.style.borderColor = 'rgba(0, 0, 0, 0.1)';
                e.currentTarget.style.boxShadow = 'none';
              }}
            />
          </div>

          {/* Question 4: Elements */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            <label style={{ fontSize: '1.125rem', fontWeight: 600, color: '#030213' }}>
              4. Do you have icons or elements you want in the design? <span style={{ color: '#717182', fontWeight: 400 }}>(optional)</span>
            </label>
            <input
              type="text"
              value={elements}
              onChange={(e) => setElements(e.target.value)}
              placeholder="E.g., mountain, star, tea"
              style={{
                height: '3rem',
                fontSize: '1rem',
                padding: '0.75rem 1rem',
                background: '#f8fafc',
                border: '1px solid rgba(0, 0, 0, 0.1)',
                borderRadius: '0.5rem',
                outline: 'none',
                fontFamily: 'inherit',
                transition: 'all 0.2s ease'
              }}
              onFocus={(e) => {
                e.currentTarget.style.borderColor = '#007a62';
                e.currentTarget.style.boxShadow = '0 0 0 2px rgba(0, 122, 98, 0.1)';
              }}
              onBlur={(e) => {
                e.currentTarget.style.borderColor = 'rgba(0, 0, 0, 0.1)';
                e.currentTarget.style.boxShadow = 'none';
              }}
            />
          </div>

          {/* Generate Button */}
          <div style={{ paddingTop: '1.5rem', textAlign: 'center' }}>
            <button 
              onClick={generatePrompt} 
              style={{
                padding: '1rem 3rem',
                fontSize: '1.125rem',
                fontWeight: 600,
                background: '#007a62',
                color: 'white',
                border: 'none',
                borderRadius: '0.75rem',
                cursor: 'pointer',
                boxShadow: '0 10px 15px -3px rgba(0, 122, 98, 0.2), 0 4px 6px -2px rgba(0, 122, 98, 0.1)',
                transition: 'all 0.2s ease',
                fontFamily: 'inherit'
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.background = '#005a43';
                e.currentTarget.style.transform = 'translateY(-2px) scale(1.02)';
                e.currentTarget.style.boxShadow = '0 20px 25px -5px rgba(0, 122, 98, 0.25), 0 10px 10px -5px rgba(0, 122, 98, 0.1)';
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.background = '#007a62';
                e.currentTarget.style.transform = 'none';
                e.currentTarget.style.boxShadow = '0 10px 15px -3px rgba(0, 122, 98, 0.2), 0 4px 6px -2px rgba(0, 122, 98, 0.1)';
              }}
            >
              ✨ Generate My Design Prompt
            </button>
          </div>
        </div>
      </div>

      {/* Footer */}
      <div style={{ textAlign: 'center', marginTop: '2rem' }}>
        <p style={{ color: '#717182', fontSize: '0.875rem', margin: 0 }}>
          Powered by <span style={{ fontWeight: 600, color: '#007a62' }}>Kocreators</span> • Custom merchandise printing solutions
        </p>
      </div>
    </div>
  );
}
