import { loadEnv, defineConfig } from '@medusajs/framework/utils'

loadEnv(process.env.NODE_ENV || 'development', process.cwd())

// Build modules array conditionally so worker doesn't require Stripe env vars
const isWorker = process.env.MEDUSA_WORKER_MODE === 'worker'
const modules: any[] = []

// Register Stripe only on server/shared and only if STRIPE_API_KEY is defined
if (!isWorker && process.env.STRIPE_API_KEY) {
  modules.push({
    resolve: "@medusajs/medusa/payment",
    options: {
      providers: [
        {
          resolve: "@medusajs/medusa/payment-stripe",
          id: "stripe",
          options: {
            apiKey: process.env.STRIPE_API_KEY,
            webhookSecret: process.env.STRIPE_WEBHOOK_SECRET,
          },
        },
      ],
    },
  })
}

// Ensure MEDUSA_BACKEND_URL uses HTTPS for non-localhost domains to prevent Mixed Content errors
// Browsers block HTTP requests from HTTPS pages (Mixed Content policy)
// This URL is also used by MedusaJS file service to generate static file URLs (e.g., export CSV links)
let backendUrl = process.env.MEDUSA_BACKEND_URL

// Warn if MEDUSA_BACKEND_URL is not set or is localhost in production
const isProduction = process.env.NODE_ENV === 'production'
if (!backendUrl && isProduction) {
  console.error('[Medusa Config] WARNING: MEDUSA_BACKEND_URL is not set in production!')
  console.error('[Medusa Config] Static file URLs (export CSVs, etc.) will use localhost, which will fail.')
  console.error('[Medusa Config] Please set MEDUSA_BACKEND_URL=https://nick-deal-admin.nickybruno.com in your deployment environment.')
} else if (backendUrl && (backendUrl.includes('localhost') || backendUrl.includes('127.0.0.1')) && isProduction) {
  console.error('[Medusa Config] WARNING: MEDUSA_BACKEND_URL is set to localhost in production!')
  console.error('[Medusa Config] Static file URLs (export CSVs, etc.) will be incorrect.')
  console.error('[Medusa Config] Please set MEDUSA_BACKEND_URL=https://nick-deal-admin.nickybruno.com in your deployment environment.')
}

if (backendUrl && backendUrl.startsWith('http://')) {
  // Only convert HTTP to HTTPS for non-localhost domains
  // localhost is typically used in development and may not have HTTPS
  const isLocalhost = backendUrl.includes('localhost') || backendUrl.includes('127.0.0.1')
  if (!isLocalhost) {
    backendUrl = backendUrl.replace('http://', 'https://')
    console.warn('[Medusa Config] Converted MEDUSA_BACKEND_URL from HTTP to HTTPS to prevent Mixed Content errors')
  }
}

module.exports = defineConfig({
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,
    // Configure worker mode per Medusa deployment guidance
    // Values: 'shared' | 'server' | 'worker' (set via MEDUSA_WORKER_MODE)
    workerMode: process.env.MEDUSA_WORKER_MODE as 'shared' | 'worker' | 'server',
    // Redis URL for session store and infrastructure modules (when enabled)
    redisUrl: process.env.REDIS_URL,
    http: {
      storeCors: process.env.STORE_CORS!,
      adminCors: process.env.ADMIN_CORS!,
      authCors: process.env.AUTH_CORS!,
      jwtSecret: process.env.JWT_SECRET || "supersecret",
      cookieSecret: process.env.COOKIE_SECRET || "supersecret",
    }
  },
  // Admin UI config: disable for worker instance and set backend URL for server instance
  admin: {
    disable: process.env.DISABLE_MEDUSA_ADMIN === 'true',
    backendUrl: backendUrl, // Use the sanitized URL that enforces HTTPS in production
  },
  // Conditionally registered modules
  modules,
})
