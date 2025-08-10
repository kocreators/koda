import React, { useState } from 'react';
import { Button } from './ui/button';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from './ui/dialog';
import type { PricingData, ChatbotSelections, ChatbotStep } from '../types';

// PricingData type is now imported from types/index.ts

interface PricingChatbotProps {
  isOpen: boolean;
  onClose: () => void;
}

// Mock pricing data based on your Google Sheets structure
const pricingDatabase: PricingData[] = [
  {
    category: 'Short Sleeve T-Shirts',
    tier: 'Economy',
    brandName: 'Gildan',
    productName: 'Heavy Cotton T-Shirt',
    placement: 'Front Only Placement',
    decorationStyle: '1-Color - Front Print Only',
    pricing: { '12': 15.99, '24': 13.99, '36': 12.99, '48': 11.99, '72': 10.99, '100': 9.99, '144': 9.49, '200': 8.99, '300': 8.49, '500': 7.99 }
  },
  {
    category: 'Short Sleeve T-Shirts',
    tier: 'Value',
    brandName: 'Next Level',
    productName: 'Premium Fitted Tee',
    placement: 'Front Only Placement',
    decorationStyle: '1-Color - Front Print Only',
    pricing: { '12': 18.99, '24': 16.99, '36': 15.99, '48': 14.99, '72': 13.99, '100': 12.99, '144': 12.49, '200': 11.99, '300': 11.49, '500': 10.99 }
  },
  {
    category: 'Short Sleeve T-Shirts',
    tier: 'Premium',
    brandName: 'American Apparel',
    productName: 'Fine Jersey T-Shirt',
    placement: 'Front Only Placement',
    decorationStyle: '1-Color - Front Print Only',
    pricing: { '12': 22.99, '24': 20.99, '36': 19.99, '48': 18.99, '72': 17.99, '100': 16.99, '144': 16.49, '200': 15.99, '300': 15.49, '500': 14.99 }
  },
  // Add more mock data for other categories...
  {
    category: 'Hooded Sweatshirts',
    tier: 'Economy',
    brandName: 'Gildan',
    productName: 'Heavy Blend Hooded Sweatshirt',
    placement: 'Front Only Placement',
    decorationStyle: '1-Color - Front Print Only',
    pricing: { '12': 32.99, '24': 29.99, '36': 27.99, '48': 25.99, '72': 23.99, '100': 21.99, '144': 20.99, '200': 19.99, '300': 18.99, '500': 17.99 }
  }
];

const categories = [
  'Short Sleeve T-Shirts',
  'Long Sleeve T-Shirts', 
  'Crewneck Sweatshirts',
  'Hooded Sweatshirts',
  'Zip Hoodies',
  '1/4 Zip Crewnecks',
  'Men\'s Short Sleeve Stretch Polos',
  'Men\'s Short Sleeve Cotton Blend Polos',
  'Women\'s Short Sleeve Stretch Polos',
  'Women\'s Short Sleeve Cotton Blend Polos',
  'Unisex Short Sleeve Dri Fits',
  'Women\'s Short Sleeve Dri Fits',
  'Trucker Hats',
  'Snapback Caps',
  'Flexfit Caps',
  'Skull Beanies',
  'Pom Beanies'
];

const tiers = ['Economy', 'Value', 'Premium'];
const placements = ['Front Only Placement', 'Front & Back Placement'];
const decorationStyles = [
  '1-Color - Front Print Only',
  '2-Color - Front Print Only', 
  'Full-Color - Front Print Only',
  '1-Color Front Print, 1-Color Back Print',
  '2-Color Front Print, 1-Color Back Print'
];

export default function PricingChatbot({ isOpen, onClose }: PricingChatbotProps) {
  const [step, setStep] = useState<ChatbotStep>(1);
  const [selections, setSelections] = useState<ChatbotSelections>({
    category: '',
    tier: '',
    placement: '',
    decorationStyle: ''
  });
  const [recommendedProduct, setRecommendedProduct] = useState<PricingData | null>(null);

  const resetChat = () => {
    setStep(1);
    setSelections({
      category: '',
      tier: '',
      placement: '',
      decorationStyle: ''
    });
    setRecommendedProduct(null);
  };

  const handleSelection = (field: keyof typeof selections, value: string) => {
    const newSelections = { ...selections, [field]: value };
    setSelections(newSelections);
    
    if (step < 4) {
      setStep((step + 1) as ChatbotStep);
    } else if (step === 4) {
      // Find matching product
      const product = pricingDatabase.find(p => 
        p.category === newSelections.category && 
        p.tier === newSelections.tier &&
        p.placement === newSelections.placement &&
        p.decorationStyle === newSelections.decorationStyle
      ) || pricingDatabase.find(p => 
        p.category === newSelections.category && 
        p.tier === newSelections.tier
      ) || pricingDatabase[0]; // Fallback
      
      setRecommendedProduct(product);
      setStep(5);
    }
  };

  const handleClose = () => {
    resetChat();
    onClose();
  };

  const renderStep = () => {
    switch (step) {
      case 1:
        return (
          <div className="space-y-4">
            <h3 className="text-xl font-semibold mb-4">👋 Hi there! Let's find the perfect product for you.</h3>
            <p className="text-lg mb-6">First, please select your category:</p>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3 max-h-96 overflow-y-auto">
              {categories.map((category) => (
                <Button
                  key={category}
                  onClick={() => handleSelection('category', category)}
                  variant="outline"
                  className="h-auto p-4 text-left justify-start hover:bg-[#007a62] hover:text-white transition-colors"
                >
                  {category}
                </Button>
              ))}
            </div>
          </div>
        );
      
      case 2:
        return (
          <div className="space-y-4">
            <h3 className="text-xl font-semibold mb-4">Great choice! Now select your product tier:</h3>
            <p className="text-sm text-gray-600 mb-6">Your selection: <strong>{selections.category}</strong></p>
            <div className="space-y-3">
              {tiers.map((tier) => (
                <Button
                  key={tier}
                  onClick={() => handleSelection('tier', tier)}
                  variant="outline"
                  className="w-full h-auto p-4 text-left justify-start hover:bg-[#007a62] hover:text-white transition-colors"
                >
                  <div>
                    <div className="font-semibold">{tier}</div>
                    <div className="text-sm text-gray-500">
                      {tier === 'Economy' && 'Budget-friendly option with reliable quality'}
                      {tier === 'Value' && 'Better quality materials and fit'}
                      {tier === 'Premium' && 'Top-tier quality and premium materials'}
                    </div>
                  </div>
                </Button>
              ))}
            </div>
          </div>
        );
      
      case 3:
        return (
          <div className="space-y-4">
            <h3 className="text-xl font-semibold mb-4">Perfect! Now choose your logo placement:</h3>
            <p className="text-sm text-gray-600 mb-6">
              Your selections: <strong>{selections.category}</strong> - <strong>{selections.tier}</strong>
            </p>
            <div className="space-y-3">
              {placements.map((placement) => (
                <Button
                  key={placement}
                  onClick={() => handleSelection('placement', placement)}
                  variant="outline"
                  className="w-full h-auto p-4 text-left justify-start hover:bg-[#007a62] hover:text-white transition-colors"
                >
                  {placement}
                </Button>
              ))}
            </div>
          </div>
        );
      
      case 4:
        return (
          <div className="space-y-4">
            <h3 className="text-xl font-semibold mb-4">Almost there! Select your decoration style:</h3>
            <p className="text-sm text-gray-600 mb-6">
              Your selections: <strong>{selections.category}</strong> - <strong>{selections.tier}</strong> - <strong>{selections.placement}</strong>
            </p>
            <div className="space-y-3">
              {decorationStyles.map((style) => (
                <Button
                  key={style}
                  onClick={() => handleSelection('decorationStyle', style)}
                  variant="outline"
                  className="w-full h-auto p-4 text-left justify-start hover:bg-[#007a62] hover:text-white transition-colors"
                >
                  {style}
                </Button>
              ))}
            </div>
          </div>
        );
      
      case 5:
        return (
          <div className="space-y-6">
            <div className="text-center">
              <h3 className="text-xl font-semibold mb-4">🎉 Great! Based on your answers, we recommend:</h3>
              {recommendedProduct && (
                <Card className="mb-6">
                  <CardHeader>
                    <CardTitle className="text-[#007a62]">{recommendedProduct.brandName}</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="text-lg font-semibold">{recommendedProduct.productName}</p>
                    <div className="text-sm text-gray-600 mt-2">
                      <p><strong>Category:</strong> {selections.category}</p>
                      <p><strong>Tier:</strong> {selections.tier}</p>
                      <p><strong>Placement:</strong> {selections.placement}</p>
                      <p><strong>Style:</strong> {selections.decorationStyle}</p>
                    </div>
                  </CardContent>
                </Card>
              )}
            </div>
            
            <div>
              <h4 className="text-lg font-semibold mb-4 text-center">💰 Want A Quote? Choose Your Desired Quantity:</h4>
              <p className="text-sm text-gray-600 text-center mb-6">Based on our price breaks:</p>
              <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                {recommendedProduct && Object.entries(recommendedProduct.pricing).map(([quantity, price]) => (
                  <Button
                    key={quantity}
                    variant="outline"
                    className="h-auto p-4 hover:bg-[#007a62] hover:text-white transition-colors"
                    onClick={() => {
                      alert(`Quote for ${quantity} pieces at $${price} each:\n\nTotal: $${(parseInt(quantity) * price).toFixed(2)}\n\nA detailed quote will be sent to your email shortly!`);
                    }}
                  >
                    <div className="text-center">
                      <div className="font-semibold">{quantity} pcs</div>
                      <div className="text-sm">${price} each</div>
                      <div className="text-xs text-gray-500">
                        Total: ${(parseInt(quantity) * price).toFixed(2)}
                      </div>
                    </div>
                  </Button>
                ))}
              </div>
            </div>
            
            <div className="text-center mt-6">
              <Button 
                onClick={resetChat}
                variant="outline"
                className="mr-4"
              >
                🔄 Start Over
              </Button>
              <Button 
                onClick={handleClose}
                className="bg-[#007a62] hover:bg-[#005a43]"
              >
                ✅ Done
              </Button>
            </div>
          </div>
        );
      
      default:
        return null;
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={handleClose}>
      <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="text-2xl text-[#007a62] text-center">
            🛍️ Product & Pricing Assistant
          </DialogTitle>
        </DialogHeader>
        <div className="p-4">
          {renderStep()}
        </div>
      </DialogContent>
    </Dialog>
  );
}