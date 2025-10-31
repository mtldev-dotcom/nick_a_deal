"use client"

import { useState, useEffect, useMemo } from "react"
import { useParams, usePathname } from "next/navigation"
import { HttpTypes } from "@medusajs/types"
import NativeSelect from "@modules/common/components/native-select"
import { updateCurrency } from "@lib/data/currency"

type CurrencySelectProps = {
  regions: HttpTypes.StoreRegion[]
  currentCurrency?: string
}

const CurrencySelect = ({ regions, currentCurrency }: CurrencySelectProps) => {
  const { countryCode } = useParams()
  const pathname = usePathname()
  const [isUpdating, setIsUpdating] = useState(false)

  // Get current path without country code
  const currentPath = useMemo(() => {
    return pathname.split(`/${countryCode}`)[1] || "/store"
  }, [pathname, countryCode])

  // Get available currencies from regions
  const availableCurrencies = useMemo(() => {
    const currencyMap = new Map<string, { code: string; label: string }>()
    
    regions.forEach((region) => {
      if (region.currency_code) {
        const code = region.currency_code.toUpperCase()
        if (!currencyMap.has(code)) {
          // Create a friendly label (USD -> USD, CAD -> CAD)
          currencyMap.set(code, {
            code,
            label: code,
          })
        }
      }
    })

    return Array.from(currencyMap.values()).sort((a, b) => a.code.localeCompare(b.code))
  }, [regions])

  // Get current currency from the current region
  const [currentCurrencyCode, setCurrentCurrencyCode] = useState<string>(
    currentCurrency?.toUpperCase() || "USD"
  )

  useEffect(() => {
    // Find the current region's currency
    const currentRegion = regions.find((r) =>
      r.countries?.some((c) => c.iso_2?.toLowerCase() === (countryCode as string)?.toLowerCase())
    )
    
    if (currentRegion?.currency_code) {
      setCurrentCurrencyCode(currentRegion.currency_code.toUpperCase())
    }
  }, [regions, countryCode])

  const handleCurrencyChange = async (event: React.ChangeEvent<HTMLSelectElement>) => {
    const newCurrency = event.target.value
    
    if (newCurrency === currentCurrencyCode || !newCurrency) {
      return
    }

    setIsUpdating(true)
    
    try {
      // updateCurrency is a server action that will redirect to the new country code
      await updateCurrency(newCurrency, currentPath)
      // Note: The redirect happens server-side, so we don't need router.refresh()
    } catch (error) {
      console.error("Failed to update currency:", error)
      setIsUpdating(false)
      // Reset the select to the previous value on error
      event.target.value = currentCurrencyCode
    }
  }

  if (availableCurrencies.length <= 1) {
    return null // Don't show switcher if only one currency available
  }

  return (
    <div className="flex items-center gap-x-2">
      <span className="text-sm text-muted-foreground hidden sm:inline">Currency:</span>
      <NativeSelect
        value={currentCurrencyCode}
        onChange={handleCurrencyChange}
        disabled={isUpdating}
        className="min-w-[80px]"
      >
        {availableCurrencies.map((currency) => (
          <option key={currency.code} value={currency.code}>
            {currency.code}
          </option>
        ))}
      </NativeSelect>
    </div>
  )
}

export default CurrencySelect

