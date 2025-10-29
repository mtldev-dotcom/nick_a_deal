# Nick a Deal - Storefront

<p align="center">
  <a href="https://www.medusajs.com">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/59018053/229103275-b5e482bb-4601-46e6-8142-244f531cebdb.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://user-images.githubusercontent.com/59018053/229103726-e5b529a3-9b3f-4970-8a1f-c6af37f087bf.svg">
    <img alt="Medusa logo" src="https://user-images.githubusercontent.com/59018053/229103726-e5b529a3-9b3f-4970-8a1f-c6af37f087bf.svg">
    </picture>
  </a>
</p>

<h1 align="center">
  Nick a Deal - Next.js Storefront
</h1>

<p align="center">
  A performant, branded storefront for Nick a Deal, combining Medusa's commerce modules with Next.js 15 features.
</p>

<p align="center">
  <a href="https://github.com/medusajs/medusa/blob/master/CONTRIBUTING.md">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat" alt="PRs welcome!" />
  </a>
  <a href="https://discord.gg/xpCwq3Kfn8">
    <img src="https://img.shields.io/badge/chat-on%20discord-7289DA.svg" alt="Discord Chat" />
  </a>
  <a href="https://twitter.com/intent/follow?screen_name=medusajs">
    <img src="https://img.shields.io/twitter/follow/medusajs.svg?label=Follow%20@medusajs" alt="Follow @medusajs" />
  </a>
</p>

## About Nick a Deal

Nick a Deal is a curated deal shop with the tagline: **"If Nick approved it, it's a deal."**

This storefront features:
- 🎨 Custom brand design system (magenta, purple, cyan color scheme)
- 🌓 Light/dark theme support
- ⚡ Fast, modern UX with Next.js 15
- 📱 Fully responsive design
- 🛍️ Complete ecommerce functionality

**Backend**: See `../nick-a-deal-shop/` for the MedusaJS backend.

## Prerequisites

- Node.js >= 20
- A running Medusa server on port 9000 (see backend README)
- Yarn (yarn@3.2.3)

## Quickstart

### 1. Set up environment variables

Create a `.env.local` file in this directory:

```env
NEXT_PUBLIC_MEDUSA_BACKEND_URL=http://localhost:9000
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=your-publishable-key
NEXT_PUBLIC_STRIPE_KEY=your-stripe-public-key
```

### 2. Install dependencies

```bash
yarn install
```

### 3. Start development server

```bash
yarn dev
```

Your storefront will be running at **http://localhost:8000**!

> **Note**: Make sure the Medusa backend is running on port 9000 before starting the storefront.

For more detailed setup instructions, see the [Development Setup Guide](../docs/development-setup.md).

## Overview

The Nick a Deal storefront is built with:

- **[Next.js 15](https://nextjs.org/)** - React framework with App Router
- **[Tailwind CSS](https://tailwindcss.com/)** - Utility-first CSS
- **[TypeScript](https://www.typescriptlang.org/)** - Type safety
- **[Medusa](https://medusajs.com/)** - Commerce backend
- **[Shadcn UI](https://ui.shadcn.com/)** - Customizable component library
- **[next-themes](https://github.com/pacocoursey/next-themes)** - Theme management

## Features

### Ecommerce Functionality

- Product Detail Pages
- Product Listing & Collections
- Shopping Cart
- Checkout with Stripe
- User Accounts & Authentication
- Order Management
- Multi-region Support

### Next.js 15 Features

- App Router
- Server Components
- Server Actions
- Streaming
- Static Pre-Rendering
- Next fetching/caching

### Brand Design System

- Custom color palette (Magenta, Purple, Cyan)
- Light/dark theme support
- Branded components (Logo, DealBadge, etc.)
- Consistent typography and spacing
- Motion elements (arrow animations, glows)

See the [Brand Implementation Guide](../docs/brand-implementation.md) for design system details.

## Project Structure

```
nick-a-deal-shop-storefront/
├── src/
│   ├── app/                    # Next.js App Router
│   │   └── [countryCode]/     # Country-based routing
│   ├── lib/                    # Utilities & config
│   │   ├── data/              # Data fetching
│   │   ├── providers/         # React providers
│   │   └── util/              # Helper functions
│   ├── modules/                # Feature modules
│   │   ├── common/            # Shared components
│   │   ├── home/              # Homepage
│   │   ├── products/          # Product pages
│   │   ├── cart/              # Cart functionality
│   │   ├── checkout/          # Checkout flow
│   │   └── layout/            # Layout components
│   ├── styles/
│   │   └── globals.css            # Global styles + CSS variables
│   └── types/                  # TypeScript types
├── public/                     # Static assets
│   ├── favicon_io/            # Favicons
│   └── nick_a_deal_logo.png   # Logo
└── package.json
```

See [Project Structure](../docs/project-structure.md) for detailed organization.

## Customization

- [Customization Guide](../docs/customization-guide.md) - How to customize components
- [Brand Implementation](../docs/brand-implementation.md) - Design system usage
- [Brand Style Guide](../docs/brand/nick-deal-storefront-design.md) - Complete design specs

## Payment Integrations

By default, this storefront supports:

- **[Stripe](https://stripe.com/)** - Payment processing

To enable Stripe:

1. Add your Stripe public key to `.env.local`:
   ```env
   NEXT_PUBLIC_STRIPE_KEY=your-stripe-public-key
   ```

2. Configure Stripe in the Medusa backend (see [Medusa Stripe docs](https://docs.medusajs.com/resources/commerce-modules/payment/payment-provider/stripe#main))

## Scripts

- `yarn dev` - Start development server (port 8000)
- `yarn build` - Build for production
- `yarn start` - Start production server
- `yarn lint` - Run ESLint

## Brand Assets

- **Logo**: `public/nick_a_deal_logo.png`
- **Favicons**: `public/favicon_io/`
- **Design Guide**: `../docs/brand/nick-deal-storefront-design.md`

## Documentation

- [Root Project README](../README.md)
- [Development Setup](../docs/development-setup.md)
- [Project Structure](../docs/project-structure.md)
- [Customization Guide](../docs/customization-guide.md)
- [Brand Implementation](../docs/brand-implementation.md)

## Resources

### Learn more about Medusa

- [Website](https://www.medusajs.com/)
- [GitHub](https://github.com/medusajs)
- [Documentation](https://docs.medusajs.com/)

### Learn more about Next.js

- [Website](https://nextjs.org/)
- [GitHub](https://github.com/vercel/next.js)
- [Documentation](https://nextjs.org/docs)
