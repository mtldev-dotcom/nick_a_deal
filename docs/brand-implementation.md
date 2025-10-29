# Brand Implementation Guide

## Overview

This document details how the Nick a Deal brand design system is implemented in the storefront codebase.

## Design System Reference

Full brand guide: `docs/brand/nick-deal-storefront-design.md`

## Color System

### CSS Variables

Brand colors are defined as CSS variables in `src/styles/globals.css`:

```css
:root {
  /* Brand Colors */
  --brand-50:  #F7E8F3;
  --brand-100: #EFD1E9;
  --brand-500: #B4228E;  /* Primary Magenta */
  --brand-700: #572383;  /* Deep Purple */
  
  /* Accent Colors */
  --accent-50:  #E9F7FE;
  --accent-100: #D2EFFC;
  --accent-500: #2BB8EB;  /* Cyan */
  --accent-700: #0B82CB;  /* Royal Blue */
  
  /* Neutrals */
  --cloud-100: #E6E7F4;
  --lavender-200: #B393C9;
  --muted: #6B7280;
}
```

### Usage in Components

**Primary Actions:**
```tsx
<button className="bg-primary text-primary-foreground">
  // Uses --brand-500 in light, adjusted in dark
</button>
```

**Secondary Actions:**
```tsx
<button className="bg-secondary text-secondary-foreground">
  // Uses --accent-500 (cyan)
</button>
```

**Text Colors:**
```tsx
<span className="text-brand-700">  // Deep purple
<span className="text-accent-500">  // Cyan
<span className="text-muted-foreground">  // Gray
```

## Gradients

### Cart Gradient

Used for primary CTAs and cart highlights:

```css
background: linear-gradient(135deg, #B4228E 0%, #572383 100%);
```

**Tailwind class:**
```tsx
<div className="bg-gradient-to-br from-[#B4228E] to-[#572383]">
```

### Arrow Gradient

Used for motion indicators, progress bars, links:

```css
background: linear-gradient(135deg, #2BB8EB 0%, #0B82CB 100%);
```

**Tailwind class:**
```tsx
<div className="bg-gradient-to-br from-[#2BB8EB] to-[#0B82CB]">
```

## Shadows & Glows

### Glow Effects

Defined as CSS variables:

```css
--glow-magenta: 0 8px 24px rgba(180,34,142,0.28);
--glow-cyan: 0 8px 24px rgba(43,184,235,0.28);
```

**Usage:**
```tsx
<div brilliance="shadow-glow-magenta">  // Primary buttons
<div className="shadow-glow-cyan">      // Secondary, hover effects
```

## Typography

### Voice & Tone

Content should be:
- Friendly, confident, concise
- Use phrases: "Picked by Nick.", "Best price today.", "No fluff, just value."

### Text Styles

Custom text utilities in `globals.css`:
- `.text-xsmall-regular`
- `.text-small-regular` / `.text-small-semi`
- `.text-base-regular` / `.text-base-semi`
- `.text-large-regular` / `.text-large-semi`
- `.text-xl-regular` / `.text-xl-semi`
- `.text-2xl-regular` / `.text-2xl-semi`
- `.text-3xl-regular` / `.text-3xl-semi`

## Components

### Logo Component

**Location**: `src/modules/common/components/logo.tsx`

**Features:**
- Uses `/nick_a_deal_logo.png`
- Arrow hover animation (CSS keyframe)
- Gradient overlay on hover
- Links to homepage

**Usage:**
```tsx
import Logo from "@modules/common/components/logo"

<Logo />
```

### DealBadge Component

**Location**: `src/modules/common/components/deal-badge.tsx`

**Variants:**
- `approved` - "Nick Approved"
- `today` - "Today's Deal"

**Styling:**
- Light: `bg-cloud-100 text-brand-700`
- Dark: `bg-[#1A1B20] text-accent-100`

**Usage:**
```tsx
import DealBadge from "@modules/common/components/deal-badge"

<DealBadge variant="approved" />
<DealBadge variant="today" />
```

## Component Patterns

### Product Cards

**Structure:**
```tsx
<div className="bg-card border border-border rounded-2xl p-4">
  <DealBadge variant="approved" />
  <Image ... />
  <div>
    <span className="text-brand-700 line-through">Original</span>
    <span className="text-brand-700 dark:text-primary">Sale Price</span>
  </div>
</div>
```

**Hover Effect:**
```tsx
className="hover:shadow-glow-cyan transition-shadow"
```

### Buttons

**Primary Button:**
```tsx
<button className="inline-flex items-center gap-2 rounded-xl px-5 py-3 bg-primary text-primary-foreground shadow-glow-magenta hover:opacity-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[color:var(--ring)]">
  Shop Today's Picks
</button>
```

**Secondary Button:**
```tsx
<button className="inline-flex items-center gap-2 rounded-xl px-5 py-3 bg-secondary text-secondary-foreground shadow-glow-cyan hover:opacity-95">
  How We Pick Deals
</button>
```

### Navigation

**Header Styling:**
- Sticky positioning
- Border: `border-border`
- Background: `backdrop-blur` on scroll
- Height: 64px (h-16)

**Layout:**
- Left: Logo
- Center: Search bar (pill style)
- Right: Account / Cart

## Theme System

### Light Theme (Default)

Uses standard brand colors from design guide.

### Dark Theme

Activated via `data-theme="dark"` on `<html>`:

```css
[data-theme="dark"] {
  --background: #0A0A0B;
  --foreground: #F8FAFC;
  --card: #101114;
  --card-foreground: #F8FAFC;
  --primary: #C02A97;  /* Slightly brighter magenta */
  --secondary: #33BFF0;  /* Slightly brighter cyan */
}
```

### Theme Provider

**Location**: `src/lib/providers/theme-provider.tsx`

Uses `next-themes` to manage theme state and toggle.

## Accessibility

### Contrast Ratios

- Minimum 4.5:1 for text (WCAG AA)
- Brand-700 on light backgrounds meets contrast
- Never use neon colors on busy images without overlay

### Focus States

All interactive elements should have:
```tsx
className="focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[color:var(--ring)]"
```

Where `--ring` uses `--accent-500` (cyan) by default.

## Motion & Animations

### Logo Animation

Arrow motion on hover using CSS keyframes:

```css
@keyframes arrow-move {
  0% { transform: translateX(0); }
  100% { transform: translateX(4px); }
}
```

### Micro-interactions

- Hover transitions: 120-160ms ease-out
- Card hover: shadow-glow-cyan + slight lift
- Button hover: opacity-95 (subtle)

## Best Practices

1. **Always use CSS variables** - Never hardcode hex values
2. **Support both themes** - Test light and dark mode
3. **Maintain contrast** - Check color combinations meet WCAG AA
4. **Consistent spacing** - Use Tailwind spacing scale
5. **Brand voice** - Keep content friendly and confident

## Files Reference

- **CSS Variables**: `src/styles/globals.css`
- **Tailwind Config**: `tailwind.config.js`
- **Logo**: `src/modules/common/components/logo.tsx`
- **DealBadge**: `src/modules/common/components/deal-badge.tsx`
- **Theme Provider**: `src/lib/providers/theme-provider.tsx`
- **Design Guide**: `docs/brand/nick-deal-storefront-design.md`

## Related Documentation

- [Development Setup](./development-setup.md)
- [Project Structure](./project-structure.md)
- [Customization Guide](./customization-guide.md)

