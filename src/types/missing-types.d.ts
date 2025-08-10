// Type declarations for packages that may not have built-in types

declare module 'lucide-react' {
  import { FC, SVGProps } from 'react';
  export interface IconProps extends SVGProps<SVGSVGElement> {
    size?: number | string;
  }
  export const Search: FC<IconProps>;
  export const ArrowRight: FC<IconProps>;
  export const Check: FC<IconProps>;
  export const ChevronDown: FC<IconProps>;
  export const X: FC<IconProps>;
  // Add more icons as needed
}

declare module 'class-variance-authority' {
  export function cva(base: string, options?: any): any;
  export type VariantProps<T> = any;
}

declare module 'cmdk' {
  import { ReactNode } from 'react';
  export const Command: any;
  export const CommandInput: any;
  export const CommandList: any;
  export const CommandEmpty: any;
  export const CommandGroup: any;
  export const CommandItem: any;
  export const CommandSeparator: any;
  export const CommandShortcut: any;
}

declare module 'vaul' {
  import { ReactNode } from 'react';
  export const Drawer: any;
  export const DrawerContent: any;
  export const DrawerDescription: any;
  export const DrawerFooter: any;
  export const DrawerHeader: any;
  export const DrawerTitle: any;
  export const DrawerTrigger: any;
  export const DrawerClose: any;
  export const DrawerOverlay: any;
  export const DrawerPortal: any;
}

declare module 'react-resizable-panels' {
  import { ReactNode } from 'react';
  export const Panel: any;
  export const PanelGroup: any;
  export const PanelResizeHandle: any;
}

declare module 'react-day-picker' {
  import { ReactNode } from 'react';
  export const DayPicker: any;
  export interface DayPickerProps {
    mode?: 'single' | 'multiple' | 'range';
    selected?: Date | Date[] | { from?: Date; to?: Date };
    onSelect?: (date: Date | Date[] | { from?: Date; to?: Date } | undefined) => void;
    disabled?: (date: Date) => boolean;
    className?: string;
    classNames?: any;
    components?: any;
  }
}

declare module 'sonner@2.0.3' {
  export function toast(message: string, options?: any): void;
  export const Toaster: any;
}