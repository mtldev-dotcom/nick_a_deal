# Project Structure Guide

## Overview

This document explains the codebase organization for Nick a Deal, covering both the MedusaJS backend and Next.js storefront.

## Backend Structure (`nick-a-deal-shop/`)

```
nick-a-deal-shop/
├── src/
│   ├── admin/              # Admin customization
│   ├── api/                # API routes
│   │   ├── admin/         # Admin API endpoints
│   │   └── store/         # Store API endpoints
│   ├── jobs/              # Background jobs
│   ├── links/             # Module links
│   ├── modules/           # Custom modules
│   ├── scripts/           # Utility scripts (seed.ts, etc.)
│   ├── subscribers/       # Event subscribers
│   └── workflows/         # Workflow definitions
├── medusa-config.ts       # Main Medusa configuration
└── package.json
```

### Key Files

- **`medusa-config.ts`**: Backend configuration (database, CORS, JWT)
- **`src/scripts/seed.ts`**: Database seeding script
- **`src/api/store/custom/route.ts`**: Custom store API routes
- **`src/api/admin/custom/route.ts`**: Custom admin API routes

## Storefront Structure (`nick-a-deal-shop-storefront/`)

```
nick-a-deal-shop-storefront/
├── src/
│   ├── app/                      # Next.js App Router
│   │   ├── [countryCode]/       # Country-based routing
│   │   │   ├── (checkout)/      # Checkout pages
│   │   │   └── (main)/          # Main store pages
│   │   │       ├── page.tsx     # Homepage
│   │   │       ├── account/     # Account pages
│   │   │       ├── cart/        # Cart page
│   │   │       ├── products/    # Product listing
│   │   │       └── ...
│   │   └── layout.tsx           # Root layout
│   ├── lib/                     # Utility libraries
│   │   ├── data/               # Data fetching functions
│   │   ├── hooks/              # Custom React hooks
│   │   ├── util/               # Utility functions
│   │   ├── config.ts           # Medusa SDK configuration
│   │   └── providers/          # React providers (theme, etc.)
│   ├── modules/                 # Feature modules
│   │   ├── account/            # Account components
│   │   ├── cart/               # Cart components
│   │   ├── checkout/           # Checkout components
│   │   ├── common/             # Shared components
│   │   │   ├── components/    # Reusable components
│   │   │   └── icons/         # Icon components
│   │   ├── home/               # Homepage components
│   │   ├── layout/             # Layout components
│   │   │   ├── components/    # Nav, Footer, etc.
│   │   │   └── templates/     # Layout templates
│   │   ├── products/           # Product components
│   │   └── ...
│   ├── styles/
│   │   └── globals.css        # Global styles + CSS variables
│   └── types/
│       └── global.ts          # TypeScript types
├── public/                      # Static assets
│   ├── favicon_io/            # Favicons
│   └── nick_a_deal_logo.png   # Logo
├── next.config.js              # Next.js configuration
├── tailwind.config.js          # Tailwind CSS configuration
└── package.json
```

### Key Patterns

#### Module Structure

Each feature module follows this pattern:

```
modules/[feature]/
├── components/          # Feature-specific components
│   └── [component]/
│       └── index.tsx
└── templates/           # Page templates
    └── index.tsx
```

#### Data Fetching

- Server components fetch data directly using functions from `lib/data/`
- Client components use hooks or React Query where needed
- Medusa SDK instance configured in `lib/config.ts`

#### Styling

- **CSS Variables**: Brand colors defined in `globals.css` as CSS variables
- **Tailwind**: Extends CSS variables in `tailwind.config.js`
- **Components**: Use Tailwind classes with brand token references
- **Theme**: Light/dark theme via `data-theme` attribute on `<html>`

## Important Directories

### `src/lib/data/`

Data fetching functions for Medusa API:
- `cart.ts` - Cart operations
- `products.ts` - Product queries
- `categories.ts` - Category queries
- `regions.ts` - Region/currency data
- `customer.ts` - Customer operations
- `orders.ts` - Order queries

### `src/modules/common/`

Shared components used across the app:
- `components/` - Reusable UI components (Logo, DealBadge, buttons, etc.)
- `icons/` - SVG icon components

### `src/modules/layout/`

Layout components:
- `components/nav/` - Navigation component
- `components/footer/` - Footer component
- `components/cart-button/` - Cart icon/button
- `templates/` - Layout templates

### `src/app/[countryCode]/`

Next.js routing structure:
- `(main)/` - Public store pages (home, products, cart, account)
- `(checkout)/` - Checkout flow pages
- Dynamic `[countryCode]` segment for multi-region support

## Naming Conventions

- **Components**: PascalCase, e.g., `ProductPreview.tsx`
- **Files**: kebab-case for utilities, PascalCase for components
- **CSS Variables**: kebab-case with `--` prefix, e.g., `--brand-500`
- **Tailwind Classes**: Use brand token names, e.g., `bg-primary`, `text-brand-700`

## Adding New Features

1. **Backend**: Add routes in `src/api/`, modules in `src/modules/`, or workflows in `src/workflows/`
2. **Storefront**: Create module in `src/modules/[feature]/`, add pages in `src/app/[countryCode]/(main)/[feature]/`

## Brand Assets

- Logo: `public/nick_a_deal_logo.png`
- Favicons: `public/favicon_io/`
- Design Guide: `docs/brand/nick-deal-storefront-design.md`

## Related Documentation

- [Development Setup](./development-setup.md)
- [Customization Guide](./customization-guide.md)
- [Brand Implementation](./brand-implementation.md)

