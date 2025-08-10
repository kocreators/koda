// Global type definitions for the Koda Logo Generator

export interface LogoGenerationPayload {
  tool: string;
  term: string;
  promptEnhancing: boolean;
  size: string;
}

export interface LogoGenerationResponse {
  job_id: string;
}

export interface LogoResultResponse {
  image_url?: string;
}

export interface PricingData {
  category: string;
  tier: string;
  brandName: string;
  productName: string;
  placement: string;
  decorationStyle: string;
  pricing: { [quantity: string]: number };
}

export interface ChatbotSelections {
  category: string;
  tier: string;
  placement: string;
  decorationStyle: string;
}

export type CurrentStep = 'prompt' | 'generate';
export type ChatbotStep = 1 | 2 | 3 | 4 | 5;

// Environment variables
declare global {
  interface Window {
    // Add any global window properties if needed
  }
}