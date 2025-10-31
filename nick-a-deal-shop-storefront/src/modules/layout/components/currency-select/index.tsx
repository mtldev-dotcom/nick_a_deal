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
    <div className="flex items-center gap-x-2">
      <span className="text-sm text-muted-foreground hidden sm:inline">Currency:</span>
      <Listbox value={currentCurrencyCode} onChange={handleCurrencyChange} disabled={isUpdating}>
        <div className="relative">
          <ListboxButton className="relative flex items-center gap-2 border border-border bg-card rounded-lg px-3 py-2 text-sm text-foreground min-w-[90px]">
            <Image
              src={getFlagForCurrency(currentCurrencyCode)}
              alt={`${currentCurrencyCode} flag`}
              width={16}
              height={16}
              className="rounded-sm"
            />
            <span>{currentCurrencyCode}</span>
          </ListboxButton>
          <Transition as={Fragment} leave="transition ease-in duration-150" leaveFrom="opacity-100" leaveTo="opacity-0">
            <ListboxOptions className="absolute z-20 mt-1 w-full rounded-md bg-card border border-border shadow-md focus:outline-none">
              {availableCurrencies.map((currency) => (
                <ListboxOption
                  key={currency.code}
                  value={currency.code}
                  className="cursor-pointer select-none px-3 py-2 text-sm text-foreground hover:bg-muted/30 flex items-center gap-2"
                >
                  <Image
                    src={getFlagForCurrency(currency.code)}
                    alt={`${currency.code} flag`}
                    width={16}
                    height={16}
                    className="rounded-sm"
                  />
                  <span>{currency.code}</span>
                </ListboxOption>
              ))}
            </ListboxOptions>
          </Transition>
        </div>
      </Listbox>
    </div>
  )
}

export default CurrencySelect

