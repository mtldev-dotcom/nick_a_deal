# Nick a Deal - Backend

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
  Nick a Deal - MedusaJS Backend
</h1>

<h4 align="center">
  <a href="https://docs.medusajs.com">Documentation</a> |
  <a href="https://www.medusajs.com">Website</a>
</h4>

<p align="center">
  Commerce backend for Nick a Deal storefront. Built with MedusaJS 2.0+.
</p>

## About

This is the backend server for **Nick a Deal**, a curated deal shop. It provides the commerce API, product management, order processing, and payment handling.

**Frontend**: See `../nick-a-deal-shop-storefront/` for the Next.js storefront.

## Compatibility

This backend is compatible with versions >= 2 of `@medusajs/medusa` (currently using 2.11.1).

## Getting Started

### Prerequisites

- Node.js >= 20
- PostgreSQL (or SQLite for development)
- Yarn (yarn@4.3.0)
- **Redis (optional but recommended)** - See [Redis Setup Guide](./REDIS_SETUP.md) for installation instructions

### Installation

1. **Install dependencies:**
   ```bash
   yarn install
   ```

2. **Set up environment variables:**
   
   Create a `.env` file in this directory:
   ```env
   DATABASE_URL=postgresql://user:password@localhost:5432/nickadeal
   STORE_CORS=http://localhost:8000
   ADMIN_CORS=http://localhost:7001
   AUTH_CORS=http://localhost:8000
   JWT_SECRET=your-jwt-secret-here
   COOKIE_SECRET=your-cookie-secret-here
   REDIS_URL=redis://localhost:6379  # Optional: Only needed if Redis is installed
   ```
   
   **Note:** Redis connection errors will appear if `REDIS_URL` is set but Redis is not running. The server will still start, but some features may not work. See [Redis Setup Guide](./REDIS_SETUP.md) for details.

3. **Run database migrations:**
   ```bash
   yarn medusa migrations run
   ```

4. **Seed the database (optional):**
   ```bash
   yarn seed
   ```

5. **Start the development server:**
   ```bash
   yarn dev
   ```

The backend will run on `http://localhost:9000`.

For more detailed setup instructions, see the [Development Setup Guide](../docs/development-setup.md).

## Project Structure

```
nick-a-deal-shop/
├── src/
│   ├── admin/          # Admin customization
│   ├── api/            # API routes (admin & store)
│   ├── jobs/           # Background jobs
│   ├── modules/        # Custom modules
│   ├── scripts/        # Utility scripts (seed.ts)
│   ├── subscribers/    # Event subscribers
│   └── workflows/      # Workflow definitions
├── medusa-config.ts    # Main configuration
└── package.json
```

## Scripts

- `yarn dev` - Start development server
- `yarn build` - Build for production
- `yarn start` - Start production server
- `yarn seed` - Seed database with sample data
- `yarn test:unit` - Run unit tests
- `yarn test:integration:http` - Run HTTP integration tests

## Configuration

Main configuration is in `medusa-config.ts`. Key settings:

- Database connection
- CORS origins (storefront, admin, auth)
- JWT and cookie secrets
- Module configurations

## API Endpoints

- **Store API**: `http://localhost:9000/store/`
- **Admin API**: `http://localhost:9000/admin/`
- **Health Check**: `http://localhost:9000/health`

## Customization

Custom API routes can be added in:
- `src/api/store/custom/route.ts` - Store endpoints
- `src/api/admin/custom/route.ts` - Admin endpoints

Custom modules, workflows, and subscribers can be added in their respective directories.

## What is Medusa

Medusa is a set of commerce modules and tools that allow you to build rich, reliable, and performant commerce applications without reinventing core commerce logic. The modules can be customized and used to build advanced ecommerce stores, marketplaces, or any product that needs foundational commerce primitives.

Learn more about [Medusa's architecture](https://docs.medusajs.com/learn/introduction/architecture) and [commerce modules](https://docs.medusajs.com/learn/fundamentals/modules/commerce-modules) in the Docs.

## Troubleshooting

### Redis Connection Errors

If you see `[ioredis] Unhandled error event: Error: connect ECONNREFUSED 127.0.0.1:6379`, Redis is not running. See [Redis Setup Guide](./REDIS_SETUP.md) for installation and setup instructions.

**Quick fix:** Install Redis via Docker:
```powershell
docker run -d --name redis-medusa -p 6379:6379 redis:7-alpine
```

Then add to `.env`:
```env
REDIS_URL=redis://localhost:6379
```

## Documentation

- [Root Project README](../README.md)
- [Development Setup](../docs/development-setup.md)
- [Project Structure](../docs/project-structure.md)
- [Redis Setup Guide](./REDIS_SETUP.md)
- [MedusaJS Docs](https://docs.medusajs.com)

## Community & Support

- [GitHub Discussions](https://github.com/medusajs/medusa/discussions)
- [Discord Server](https://discord.com/invite/medusajs)
- [GitHub Issues](https://github.com/medusajs/medusa/issues)
