# Development Setup Guide

## Overview

Nick a Deal is built with MedusaJS 2.0+ for the backend and Next.js 15 for the storefront. This guide covers local development setup.

## Prerequisites

- Node.js >= 20
- Yarn (yarn@3.2.3 for storefront, yarn@4.3.0 for backend)
- PostgreSQL (for production, SQLite for development)
- Git (for version control - developers only, not AI assistants)

## Project Structure

```
nick_a_deal/
├── nick-a-deal-shop/              # MedusaJS Backend (port 9000)
│   ├── src/
│   ├── medusa-config.ts
│   └── package.json
├── nick-a-deal-shop-storefront/   # Next.js Storefront (port 8000)
│   ├── src/
│   ├── next.config.js
│   └── package.json
└── docs/                          # Documentation
```

## Backend Setup

### 1. Navigate to backend directory

```bash
cd nick-a-deal-shop
```

### 2. Install dependencies

```bash
yarn install
```

### 3. Environment variables

Create a `.env` file in `nick-a-deal-shop/` with:

```env
DATABASE_URL=postgresql://user:password@localhost:5432/nickadeal
STORE_CORS=http://localhost:8000
ADMIN_CORS=http://localhost:7001
AUTH_CORS=http://localhost:8000
JWT_SECRET=your-jwt-secret
COOKIE_SECRET=your-cookie-secret
```

### 4. Run database migrations

```bash
yarn medusa migrations run
```

### 5. Seed database (optional)

```bash
yarn seed
```

### 6. Start backend server

```bash
yarn dev
```

Backend runs on `http://localhost:9000`

## Storefront Setup

### 1. Navigate to storefront directory

```bash
cd nick-a-deal-shop-storefront
```

### 2. Install dependencies

```bash
yarn install
```

### 3. Environment variables

Create a `.env.local` file in `nick-a-deal-shop-storefront/` with:

```env
NEXT_PUBLIC_MEDUSA_BACKEND_URL=http://localhost:9000
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=your-publishable-key
NEXT_PUBLIC_STRIPE_KEY=your-stripe-public-key
```

### 4. Start development server

```bash
yarn dev
```

Storefront runs on `http://localhost:8000`

## Development Workflow

1. **Start backend first** - Ensure Medusa backend is running on port 9000
2. **Start storefront second** - Next.js will connect to backend
3. **Make changes** - Both servers support hot-reload
4. **Test** - Access storefront at http://localhost:8000

## Ports

- **Backend API**: `http://localhost:9000`
- **Backend Admin** (if enabled): `http://localhost:9000/app`
- **Storefront**: `http://localhost:8000`

## Common Issues

### Port already in use

If port 9000 or 8000 is already in use:

**Windows PowerShell:**
```powershell
# Find process using port
netstat -ano | Select-String ":9000"
# Kill process (replace PID)
Stop-Process -Id <PID> -Force
```

**macOS/Linux:**
```bash
# Find and kill process
lsof -ti:9000 | xargs kill -9
```

### Database connection errors

- Ensure PostgreSQL is running
- Check `DATABASE_URL` in backend `.env`
- Verify database exists and user has permissions

### CORS errors

- Verify `STORE_CORS` and `AUTH_CORS` in backend `.env` match storefront URL
- Ensure backend is running before starting storefront

## Next Steps

- See [Project Structure](./project-structure.md) for code organization
- See [Customization Guide](./customization-guide.md) for component customization
- See [Brand Implementation](./brand-implementation.md) for design system details

