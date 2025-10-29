# Nick a Deal

> "If Nick approved it, it's a deal."

A curated deal shop built with MedusaJS 2.0+ and Next.js 15, featuring a clean, fast, and trustworthy storefront design.

## Project Structure

This monorepo contains:

- **`nick-a-deal-shop/`** - MedusaJS backend (port 9000)
- **`nick-a-deal-shop-storefront/`** - Next.js 15 storefront (port 8000)
- **`docs/`** - Project documentation and brand assets

## Quick Start

### Prerequisites

- Node.js >= 20
- Yarn (yarn@3.2.3 for storefront, yarn@4.3.0 for backend)
- PostgreSQL (or SQLite for development)

### Setup

1. **Clone the repository** (if applicable)

2. **Set up the backend:**
   ```bash
   cd nick-a-deal-shop
   yarn install
   # Create .env file (see backend README)
   yarn dev
   ```

3. **Set up the storefront:**
   ```bash
   cd nick-a-deal-shop-storefront
   yarn install
   # Create .env.local file (see storefront README)
   yarn dev
   ```

4. **Access the storefront:**
   - Storefront: http://localhost:8000
   - Backend API: http://localhost:9000

For detailed setup instructions, see the [Development Setup Guide](./docs/development-setup.md).

## Documentation

- [Development Setup](./docs/development-setup.md) - Local development environment setup
- [Project Structure](./docs/project-structure.md) - Codebase organization and patterns
- [Customization Guide](./docs/customization-guide.md) - How to customize components and add features
- [Brand Implementation](./docs/brand-implementation.md) - Design system and brand token usage
- [Brand Style Guide](./docs/brand/nick-deal-storefront-design.md) - Complete design specifications

## Technology Stack

### Backend
- **MedusaJS 2.11.1** - Commerce backend
- **TypeScript** - Type safety
- **PostgreSQL** - Database

### Storefront
- **Next.js 15** - React framework with App Router
- **React 19** - UI library
- **TypeScript** - Type safety
- **Tailwind CSS** - Styling
- **@medusajs/ui** - Medusa UI components
- **Shadcn UI** - Customizable component library
- **next-themes** - Theme management

## Features

- 🛍️ Full ecommerce functionality
- 🎨 Branded design system with light/dark themes
- 📱 Responsive design
- ⚡ Server-side rendering and static generation
- 🔄 Real-time cart updates
- 💳 Stripe payment integration
- 👤 Customer accounts and order management
- 🌍 Multi-region support

## Brand Identity

Nick a Deal features a distinctive brand design with:
- **Primary Colors**: Magenta (#B4228E) and Deep Purple (#572383)
- **Accent Colors**: Cyan (#2BB8EB) and Royal Blue (#0B82CB)
- **Motion Elements**: Arrow-streak designs echoing the logo
- **Voice**: Friendly, confident, concise - "Picked by Nick."

See the [Brand Implementation Guide](./docs/brand-implementation.md) for details.

## Development

### Important Rules

- **Never commit directly** - Use proper git workflows
- **Backend must run first** - Start backend before storefront
- **Check port availability** - Ensure ports 9000 and 8000 are free

### Common Commands

**Backend:**
```bash
cd nick-a-deal-shop
yarn dev          # Start development server
yarn build        # Build for production
yarn seed         # Seed database
```

**Storefront:**
```bash
cd nick-a-deal-shop-storefront
yarn dev          # Start development server
yarn build        # Build for production
yarn lint         # Run linter
```

## Contributing

1. Follow the project structure guidelines in [Project Structure](./docs/project-structure.md)
2. Maintain brand consistency using the design system in [Brand Implementation](./docs/brand-implementation.md)
3. Use TypeScript for type safety
4. Write clear commit messages

## Resources

### MedusaJS
- [Documentation](https://docs.medusajs.com/)
- [GitHub](https://github.com/medusajs/medusa)
- [Discord](https://discord.gg/xpCwq3Kfn8)

### Next.js
- [Documentation](https://nextjs.org/docs)
- [GitHub](https://github.com/vercel/next.js)

## License

MIT

