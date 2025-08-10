export type CurrentStep = 'prompt' | 'generate';

export interface LogoGeneratorProps {
  initialPrompt: string;
  onRequestQuote: () => void;
}

export interface DesignPromptBuilderProps {
  onPromptGenerated: (prompt: string) => void;
}

export interface PricingChatbotProps {
  isOpen: boolean;
  onClose: () => void;
}

export interface ProductCategory {
  id: string;
  name: string;
  description: string;
  basePrice: number;
}

export interface ProductTier {
  id: string;
  name: 'Economy' | 'Value' | 'Premium';
  multiplier: number;
  description: string;
}

export interface DecorationOption {
  id: string;
  name: string;
  colors: string[];
  priceAdjustment: number;
}

export interface QuoteRequest {
  productCategory: string;
  productTier: string;
  logoPlacement: 'front' | 'front-back';
  decorationStyle: string;
  quantity: number;
  logoImage?: string;
}

export interface PricingOption {
  quantity: number;
  unitPrice: number;
  totalPrice: number;
  savings?: number;
}