"use client"

import { useState, useMemo } from "react"
import { StoreRegion, HttpTypes } from "@medusajs/types"
import { useParams } from "next/navigation"

import LocalizedClientLink from "@modules/common/components/localized-client-link"
import Logo from "@modules/common/components/logo"
import CartDropdown from "@modules/layout/components/cart-dropdown"
import SidebarMenu from "@modules/layout/components/mobile-menu"
import ThemeToggle from "@modules/layout/components/theme-toggle"
import CurrencySelect from "@modules/layout/components/currency-select"

type NavClientProps = {
  regions: StoreRegion[] | null
  cart: HttpTypes.StoreCart | null
  categories: HttpTypes.StoreProductCategory[]
  collections: HttpTypes.StoreCollection[]
}

export default function NavClient({ regions, cart, categories, collections }: NavClientProps) {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)
  const { countryCode } = useParams()

  // Get current currency from the current region
  const currentCurrency = useMemo(() => {
    if (!regions || !countryCode) return undefined
    
    const currentRegion = regions.find((r) =>
      r.countries?.some((c) => c.iso_2?.toLowerCase() === (countryCode as string)?.toLowerCase())
    )
    
    return currentRegion?.currency_code
  }, [regions, countryCode])

  return (
    <>
      <div className="sticky top-0 inset-x-0 z-50 group">
        <header className="relative h-16 mx-auto border-b duration-200 bg-background/95 backdrop-blur-md border-border shadow-sm">
          <nav className="content-container text-foreground flex items-center justify-between w-full h-full gap-4">
            {/* Left: Logo / Menu Button */}
            <div className="flex items-center gap-x-4">
              {/* Hamburger Menu Button - Visible on all screens */}
              <button
                onClick={() => setMobileMenuOpen(true)}
                className="p-2 rounded-lg hover:bg-background/50 transition-colors"
                aria-label="Open menu"
              >
                {/* Hamburger Menu Icon */}
                <svg
                  className="w-6 h-6 text-foreground"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M4 6h16M4 12h16M4 18h16"
                  />
                </svg>
              </button>

              {/* Logo */}
              <Logo />
            </div>

            {/* Right: Search, Theme Toggle, Cart */}
            <div className="flex items-center justify-center gap-x-1.5 h-full">
              {/* Search Bar - Pill Style */}
              <div className="hidden md:flex items-center">
                <div className="relative">
                  <input
                    type="search"
                    placeholder="Search deals..."
                    className="w-48 px-4 py-2 text-sm rounded-full border border-border bg-background/50 focus:outline-none focus:ring-2 focus:ring-[color:var(--ring)] focus:border-transparent transition-all"
                    aria-label="Search products"
                  />
                </div>
              </div>

              {/* Currency Switcher */}
              {regions && (
                <CurrencySelect regions={regions} currentCurrency={currentCurrency} />
              )}

              {/* Theme Toggle */}
              <ThemeToggle />

              {/* Cart Button */}
              <CartDropdown cart={cart} />
            </div>
          </nav>
        </header>
      </div>

      {/* Sidebar Menu */}
      <SidebarMenu
        isOpen={mobileMenuOpen}
        onClose={() => setMobileMenuOpen(false)}
        regions={regions}
        categories={categories}
        collections={collections}
      />
    </>
  )
}
