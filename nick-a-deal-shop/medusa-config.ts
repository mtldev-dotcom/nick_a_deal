import { loadEnv, defineConfig } from '@medusajs/framework/utils'

loadEnv(process.env.NODE_ENV || 'development', process.cwd())

// Build modules array conditionally so worker doesn't require Stripe env vars
const isWorker = process.env.MEDUSA_WORKER_MODE === 'worker'
const isProduction = process.env.NODE_ENV === 'production'
const isServer = !isWorker // Server instance (not worker)
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

// Configure file service with S3 (Cloudflare R2) if credentials are provided
// This ensures export CSV URLs use the R2 bucket domain instead of localhost
if (process.env.S3_ACCESS_KEY_ID && process.env.S3_SECRET_ACCESS_KEY) {
  const s3Bucket = process.env.S3_BUCKET || "nick-a-deal"
  const s3Endpoint = process.env.S3_ENDPOINT || "https://adb42a8f4caba5f8c2c67f6a9eb2ddb6.r2.cloudflarestorage.com"

  // Determine file URL: where files are publicly accessible
  // For Cloudflare R2:
  // - If S3_FILE_URL is set (custom domain or R2 public URL), use it
  // - Otherwise, construct from endpoint (ensure bucket has public access enabled in Cloudflare)
  // Note: The file_url should be where users can download files, not the API endpoint
  const fileUrl = process.env.S3_FILE_URL || s3Endpoint

  modules.push({
    resolve: "@medusajs/medusa/file",
    options: {
      providers: [
        {
          resolve: "@medusajs/file-s3",
          id: "s3",
          options: {
            // File URL: Where files are publicly accessible
            file_url: fileUrl,
            // Cloudflare R2 credentials
            access_key_id: process.env.S3_ACCESS_KEY_ID,
            secret_access_key: process.env.S3_SECRET_ACCESS_KEY,
            // Cloudflare R2 specific settings
            region: process.env.S3_REGION || "auto", // Cloudflare R2 uses "auto"
            bucket: s3Bucket,
            endpoint: s3Endpoint,
            // Additional client config for S3-compatible services
            additional_client_config: {
              forcePathStyle: false, // Cloudflare R2 supports virtual-hosted-style URLs
            },
          },
        },
      ],
    },
  })

  if (isServer && isProduction) {
    console.log('[Medusa Config] File service configured with Cloudflare R2 (S3)')
    console.log('[Medusa Config] S3 Bucket:', s3Bucket)
    console.log('[Medusa Config] File URL:', fileUrl)
  }
} else if (isServer && isProduction) {
  console.warn('[Medusa Config] WARNING: S3 file service not configured.')
  console.warn('[Medusa Config] Export CSV URLs will use localhost. Configure S3_ACCESS_KEY_ID and S3_SECRET_ACCESS_KEY to use Cloudflare R2.')
}

// Ensure MEDUSA_BACKEND_URL uses HTTPS for non-localhost domains to prevent Mixed Content errors
// Browsers block HTTP requests from HTTPS pages (Mixed Content policy)
// Note: When S3 file service is configured (above), file URLs come from R2, not MEDUSA_BACKEND_URL
// MEDUSA_BACKEND_URL is still required for admin UI configuration
let backendUrl = process.env.MEDUSA_BACKEND_URL

// Warn if MEDUSA_BACKEND_URL is not set or is localhost in production
// Only check servers (workers don't need MEDUSA_BACKEND_URL)
if (isServer && isProduction) {
  if (!backendUrl) {
    console.error('[Medusa Config] WARNING: MEDUSA_BACKEND_URL is not set in production!')
    console.error('[Medusa Config] Static file URLs (export CSVs, etc.) will use localhost, which will fail.')
    console.error('[Medusa Config] Please set MEDUSA_BACKEND_URL=https://nick-deal-admin.nickybruno.com in your deployment environment.')
  } else if (backendUrl.includes('localhost') || backendUrl.includes('127.0.0.1')) {
    console.error('[Medusa Config] WARNING: MEDUSA_BACKEND_URL is set to localhost in production!')
    console.error('[Medusa Config] Current value:', backendUrl)
    console.error('[Medusa Config] Static file URLs (export CSVs, etc.) will be incorrect.')
    console.error('[Medusa Config] Please set MEDUSA_BACKEND_URL=https://nick-deal-admin.nickybruno.com in your deployment environment.')
  } else {
    console.log('[Medusa Config] MEDUSA_BACKEND_URL is set correctly:', backendUrl)
  }
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
