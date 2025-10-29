# Customization Guide

## Overview

This guide covers how to customize components, add products, modify styling, and extend functionality in the Nick a Deal storefront.

## Brand Design System

Before customizing, familiarize yourself with the brand design system:
- **Design Guide**: `docs/brand/nick-deal-storefront-design.md`
- **CSS Variables**: Defined in `src/styles/globals.css`
- **Tailwind Config**: Extended in `tailwind.config.js`

### Using Brand Colors

Always use CSS variables, not hardcoded hex values:

```tsx
// ✅ Good
<div className="bg-primary text-primary-foreground">
<button className="bg-[color:var(--brand-500)]">

// ❌ Bad
<div className="bg-[#B4228E]">
```

## Customizing Components

### Adding a New Component

1. Create component in appropriate module:
   ```
   src/modules/[feature]/components/[component-name]/index.tsx
   ```

2. Use brand tokens:
   ```tsx
   export default function MyComponent() {
     return (
       <div className="bg-card border border-border rounded-2xl p-4">
         <h2 className="text-card-foreground">Title</h2>
       </div>
     )
   }
   ```

3. Export if needed:
   ```tsx
   // In modules/common/components/index.ts (if creating shared component)
   export { default as MyComponent } from './my-component'
   ```

### Modifying Existing Components

**Product Cards** (`src/modules/products/components/product-preview/`):
- Main component: `index.tsx`
- Price display: `price.tsx`
- Thumbnail: `thumbnail/index.tsx`

**Navigation** (`src/modules/layout/templates/nav/index.tsx`):
- Logo component: `src/modules/common/components/logo.tsx`
- Search bar can be added in nav template
- Cart button: `src/modules/layout/components/cart-button/`

**Hero Section** (`src/modules/home/components/hero/index.tsx`):
- Value prop text
- CTA buttons
- Background patterns

## Adding Products

Products are managed through Medusa Admin panel or API. For local development:

### Via Medusa Admin

1. Start backend: `cd nick-a-deal-shop && yarn dev`
2. Access admin: `http://localhost:9000/app`
3. Log in with admin credentials
4. Navigate to Products → Add Product

### Via API/Scripts

Create a script in `nick-a-deal-shop/src/scripts/`:

```typescript
import { Medusa } from "@medusajs/js-sdk"

const medusa = new Medusa({
  baseUrl: "http://localhost:9000",
})

// Create product logic
```

## Styling Customization

### Adding New CSS Variables

1. Add to `src/styles/globals.css`:
   ```css
   :root {
     --my-custom-color: #HEX;
   }
   
   [data-theme="dark"] {
     --my-custom-color: #HEX;
   }
   ```

2. Add to `tailwind.config.js` if needed:
   ```js
   extend: {
     colors: {
       'my-custom': 'var(--my-custom-color)',
     }
   }
   ```

### Creating Branded Button Variants

Use the brand button classes from design guide:

```tsx
// Primary button
<button className="inline-flex items-center gap-2 rounded-xl px-5 py-3 bg-primary text-primary-foreground shadow-glow-magenta hover:opacity-95">
  Primary CTA
</button>

// Secondary button
<button className="inline-flex items-center gap-2 rounded-xl px-5 py-3 bg-secondary text-secondary-foreground shadow-glow-cyan hover:opacity-95">
  Secondary CTA
</button>
```

### Using Deal Badges

```tsx
import DealBadge from "@modules/common/components/deal-badge"

<DealBadge variant="approved" />  // "Nick Approved"
<DealBadge variant="today" />     // "Today's Deal"
```

## Theme Customization

### Adding Dark Mode Support to Components

Always consider both themes:

```tsx
<div className="bg-card dark:bg-[#101114] text-card-foreground">
  <span className="text-brand-700 dark:text-primary">
    Brand text
  </span>
</div>
```

### Theme Toggle

Theme provider is configured in `src/lib/providers/theme-provider.tsx`. Add toggle component if needed:

```tsx
'use client'

import { useTheme } from 'next-themes'

export default function ThemeToggle() {
  const { theme, setTheme } = useTheme()
  return (
    <button onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}>
      Toggle theme
    </button>
  )
}
```

## Adding Pages

### Creating a New Page

1. Create route in `src/app/[countryCode]/(main)/[page-name]/page.tsx`:
   ```tsx
   import { Metadata } from "next"
   
   export const metadata: Metadata = {
     title: "Page Title",
   }
   
   export default function PageName() {
     return <div>Page content</div>
   }
   ```

2. Add to navigation if needed (`src/modules/layout/templates/nav/index.tsx`)

### Creating a New Layout

Create layout file in route directory:
```tsx
// src/app/[countryCode]/(main)/[section]/layout.tsx
export default function SectionLayout({ children }) {
  return <div className="section-wrapper">{children}</div>
}
```

## Adding API Routes

### Storefront API Routes

Create in `src/app/api/[route]/route.ts`:
```tsx
import { NextResponse } from 'next/server'

export async function GET() {
  return NextResponse.json({ data: 'response' })
}
```

### Backend Custom Routes

Add to `nick-a-deal-shop/src/api/store/custom/route.ts` or create new route files.

## Modifying Checkout Flow

Checkout components are in `src/modules/checkout/`:
- `templates/checkout-form/` - Main checkout form
- `components/` - Checkout steps (address, shipping, payment, review)
- `templates/checkout-summary/` - Order summary

## Adding Payment Providers

1. Install provider in backend: `cd nick-a-deal-shop && yarn add @medusajs/payment-stripe`
2. Configure in `medusa-config.ts`
3. Add provider components in storefront `src/modules/checkout/components/payment/`

## Debugging

### Common Issues

**Styles not applying:**
- Check CSS variables are defined in `globals.css`
- Verify Tailwind config includes file paths
- Check for class name typos

**API errors:**
- Ensure backend is running on port 9000
- Check `MEDUSA_BACKEND_URL` in storefront `.env.local`
- Verify CORS settings in backend `.env`

**Products not showing:**
- Check products are published in Medusa Admin
- Verify region configuration
- Check network tab for API errors

## Best Practices

1. **Use TypeScript**: All components should be typed
2. **Server Components First**: Use server components by default, client only when needed
3. **Brand Consistency**: Always use brand tokens, not hardcoded values
4. **Accessibility**: Maintain focus states, ARIA labels, keyboard navigation
5. **Performance**: Use Next.js Image component, lazy load where appropriate
6. **Responsive**: Test mobile, tablet, desktop breakpoints

## Related Documentation

- [Development Setup](./development-setup.md)
- [Project Structure](./project-structure.md)
- [Brand Implementation](./brand-implementation.md)

