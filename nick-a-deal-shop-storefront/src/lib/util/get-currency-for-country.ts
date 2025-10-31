/**
 * Maps country codes to their expected currency codes.
 * This ensures that /us/store shows USD and /ca/store shows CAD.
 */
export const getCurrencyForCountry = (countryCode: string): string => {
  const countryCodeLower = countryCode.toLowerCase()

  const currencyMap: Record<string, string> = {
    us: "usd",
    ca: "cad",
    // Add more mappings as needed
    // gb: "gbp",
    // eu: "eur",
  }

  return currencyMap[countryCodeLower] || "usd" // Default to USD if not found
}

/**
 * Validates that a region's currency matches the expected currency for a country code.
 * @returns true if currency matches, false otherwise
 */
export const validateRegionCurrency = (
  countryCode: string,
  regionCurrencyCode: string | undefined | null
): boolean => {
  if (!regionCurrencyCode) {
    return false
  }

  const expectedCurrency = getCurrencyForCountry(countryCode)
  return regionCurrencyCode.toLowerCase() === expectedCurrency.toLowerCase()
}

