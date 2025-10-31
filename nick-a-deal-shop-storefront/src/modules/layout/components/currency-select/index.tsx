"use client"

import { useState, useEffect, useMemo, Fragment } from "react"
import { useParams, usePathname } from "next/navigation"
import { HttpTypes } from "@medusajs/types"
import { updateCurrency } from "@lib/data/currency"
import Image from "next/image"
import { Listbox, ListboxButton, ListboxOption, ListboxOptions, Transition } from "@headlessui/react"

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

  const handleCurrencyChange = async (newCurrency: string) => {
    if (newCurrency === currentCurrencyCode || !newCurrency) {
      return
    }

    setIsUpdating(true)

    try {
      await updateCurrency(newCurrency, currentPath)
    } catch (error) {
      console.error("Failed to update currency:", error)
      setIsUpdating(false)
    }
  }

  const getFlagForCurrency = (code?: string) => {
    switch ((code || "").toUpperCase()) {
      case "CAD":
        return "/cad-icon.png"
      case "USD":
        return "/usa-icon.png"
      default:
        return "/usa-icon.png"
    }
  }

  if (availableCurrencies.length <= 1) {
    return null // Don't show switcher if only one currency available
  }

  return (
    <Listbox value={currentCurrencyCode} onChange={handleCurrencyChange} disabled={isUpdating}>
      <div className="relative flex items-center">
        <ListboxButton className="relative flex items-center justify-center border border-border bg-card rounded-lg px-2.5 h-10 w-auto">
          <Image
            src={getFlagForCurrency(currentCurrencyCode)}
            alt={`${currentCurrencyCode} flag`}
            width={20}
            height={20}
            className="rounded-sm"
          />
        </ListboxButton>
        <Transition as={Fragment} leave="transition ease-in duration-150" leaveFrom="opacity-100" leaveTo="opacity-0">
          <ListboxOptions className="absolute z-20 right-0 mt-1 rounded-md bg-card border border-border shadow-md focus:outline-none">
            {availableCurrencies.map((currency) => (
              <ListboxOption
                key={currency.code}
                value={currency.code}
                className="cursor-pointer select-none px-3 py-2 text-sm text-foreground hover:bg-muted/30 flex items-center justify-center"
              >
                <Image
                  src={getFlagForCurrency(currency.code)}
                  alt={`${currency.code} flag`}
                  width={20}
                  height={20}
                  className="rounded-sm"
                />
              </ListboxOption>
            ))}
          </ListboxOptions>
        </Transition>
      </div>
    </Listbox>
  )
}

export default CurrencySelect

