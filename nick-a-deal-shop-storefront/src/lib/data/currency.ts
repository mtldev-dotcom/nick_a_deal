"use server"

import { getCountryCodeByCurrency } from "./regions"
import { updateRegion } from "./cart"

/**
 * Updates the currency by switching to a region with the specified currency
 * @param currencyCode - Currency code (e.g., "USD", "CAD")
 * @param currentPath - Current path without country code
 */
export async function updateCurrency(currencyCode: string, currentPath: string) {
  // Find a country code in a region with the requested currency
  const countryCode = await getCountryCodeByCurrency(currencyCode.toLowerCase())
  
  if (!countryCode) {
    throw new Error(`No region found with currency: ${currencyCode}`)
  }

  // Update region (which will redirect to the new country code path)
  await updateRegion(countryCode, currentPath)
}

