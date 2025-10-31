"use server"

import { sdk } from "@lib/config"
import medusaError from "@lib/util/medusa-error"
import { HttpTypes } from "@medusajs/types"
import { getCacheOptions } from "./cookies"

export const listRegions = async () => {
  const next = {
    ...(await getCacheOptions("regions")),
  }

  return sdk.client
    .fetch<{ regions: HttpTypes.StoreRegion[] }>(`/store/regions`, {
      method: "GET",
      next,
      cache: "force-cache",
    })
    .then(({ regions }) => regions)
    .catch(medusaError)
}

export const retrieveRegion = async (id: string) => {
  const next = {
    ...(await getCacheOptions(["regions", id].join("-"))),
  }

  return sdk.client
    .fetch<{ region: HttpTypes.StoreRegion }>(`/store/regions/${id}`, {
      method: "GET",
      next,
      cache: "force-cache",
    })
    .then(({ region }) => region)
    .catch(medusaError)
}

const regionMap = new Map<string, HttpTypes.StoreRegion>()

export const getRegion = async (countryCode: string) => {
  try {
    if (regionMap.has(countryCode)) {
      return regionMap.get(countryCode)
    }

    const regions = await listRegions()

    if (!regions) {
      return null
    }

    regions.forEach((region) => {
      region.countries?.forEach((c) => {
        regionMap.set(c?.iso_2 ?? "", region)
      })
    })

    const region = countryCode
      ? regionMap.get(countryCode)
      : regionMap.get("us")

    return region
  } catch (e: any) {
    return null
  }
}

/**
 * Gets a country code for a given currency code
 * Returns the first available country code in a region with the specified currency
 */
export const getCountryCodeByCurrency = async (currencyCode: string): Promise<string | null> => {
  try {
    const regions = await listRegions()
    
    if (!regions) {
      return null
    }

    // Find the first region with the matching currency code
    const regionWithCurrency = regions.find(
      (r) => r.currency_code?.toLowerCase() === currencyCode.toLowerCase()
    )

    if (!regionWithCurrency || !regionWithCurrency.countries?.length) {
      return null
    }

    // Return the first country code from that region
    return regionWithCurrency.countries[0]?.iso_2 ?? null
  } catch (e: any) {
    return null
  }
}

/**
 * Gets all available currencies from regions
 */
export const getAvailableCurrencies = async (): Promise<Array<{ code: string; region: HttpTypes.StoreRegion }>> => {
  try {
    const regions = await listRegions()
    
    if (!regions) {
      return []
    }

    // Get unique currencies from all regions
    const currencyMap = new Map<string, HttpTypes.StoreRegion>()
    
    regions.forEach((region) => {
      if (region.currency_code) {
        const code = region.currency_code.toLowerCase()
        if (!currencyMap.has(code)) {
          currencyMap.set(code, region)
        }
      }
    })

    return Array.from(currencyMap.entries()).map(([code, region]) => ({
      code: code.toUpperCase(),
      region,
    }))
  } catch (e: any) {
    return []
  }
}