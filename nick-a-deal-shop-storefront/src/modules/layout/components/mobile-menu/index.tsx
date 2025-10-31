"use client"

import { Dialog, Transition } from "@headlessui/react"
import { XMark } from "@medusajs/icons"
import { Fragment } from "react"
import { usePathname, useParams } from "next/navigation"

import LocalizedClientLink from "@modules/common/components/localized-client-link"
import CountrySelect from "../country-select"
import CurrencySelect from "../currency-select"
import ThemeToggle from "../theme-toggle"
import { HttpTypes } from "@medusajs/types"
import { useToggleState } from "@medusajs/ui"
import { useMemo } from "react"

const MenuItems = [
  { name: "Home", href: "/" },
  { name: "Store", href: "/store" },
  { name: "Categories", href: "/categories" },
  { name: "Account", href: "/account" },
]

type MobileMenuProps = {
  isOpen: boolean
  onClose: () => void
  regions: HttpTypes.StoreRegion[] | null
}

/**
 * Slick mobile menu with smooth slide-in animation
 */
export default function MobileMenu({ isOpen, onClose, regions }: MobileMenuProps) {
  const pathname = usePathname()
  const { countryCode } = useParams() as { countryCode: string }
  const toggleState = useToggleState()
  
  // Get current currency from the current region
  const currentCurrency = useMemo(() => {
    if (!regions || !countryCode) return undefined
    
    const currentRegion = regions.find((r) =>
      r.countries?.some((c) => c.iso_2?.toLowerCase() === countryCode?.toLowerCase())
    )
    
    return currentRegion?.currency_code
  }, [regions, countryCode])
  
  // Handle country code prefix in pathname
  const getActivePath = (href: string) => {
    if (!pathname || !countryCode) return false
    const normalizedPath = pathname.split(`/${countryCode}`)[1] || "/"
    return normalizedPath === href || normalizedPath.startsWith(`${href}/`)
  }

  return (
    <Transition show={isOpen} as={Fragment}>
      <Dialog onClose={onClose} className="relative z-50 lg:hidden">
        {/* Backdrop */}
        <Transition.Child
          as={Fragment}
          enter="ease-out duration-300"
          enterFrom="opacity-0"
          enterTo="opacity-100"
          leave="ease-in duration-200"
          leaveFrom="opacity-100"
          leaveTo="opacity-0"
        >
          <div className="fixed inset-0 bg-black/60 backdrop-blur-sm" aria-hidden="true" />
        </Transition.Child>

        {/* Slide panel */}
        <Transition.Child
          as={Fragment}
          enter="ease-out duration-300 transform"
          enterFrom="-translate-x-full"
          enterTo="translate-x-0"
          leave="ease-in duration-200 transform"
          leaveFrom="translate-x-0"
          leaveTo="-translate-x-full"
        >
          <Dialog.Panel className="fixed inset-y-0 left-0 w-80 max-w-sm bg-card border-r border-border shadow-xl">
            <div className="flex flex-col h-full">
              {/* Header */}
              <div className="flex items-center justify-between p-6 border-b border-border">
                <h2 className="text-lg font-semibold text-foreground">Menu</h2>
                <button
                  onClick={onClose}
                  className="p-2 rounded-lg hover:bg-background/50 transition-colors"
                  aria-label="Close menu"
                >
                  <XMark className="w-6 h-6 text-foreground" />
                </button>
              </div>

              {/* Navigation Items */}
              <nav className="flex-1 overflow-y-auto px-6 py-6">
                <ul className="space-y-2">
                  {MenuItems.map((item) => {
                    const isActive = getActivePath(item.href)
                    return (
                      <li key={item.name}>
                        <LocalizedClientLink
                          href={item.href}
                          onClick={onClose}
                          className={`block px-4 py-3 rounded-xl text-base font-medium transition-all duration-150 ${
                            isActive
                              ? "bg-primary/10 text-primary border-l-4 border-primary"
                              : "text-foreground hover:bg-background/50 hover:text-primary"
                          }`}
                        >
                          {item.name}
                        </LocalizedClientLink>
                      </li>
                    )
                  })}
                </ul>

                {/* Country Select */}
                {regions && (
                  <div className="mt-8 pt-8 border-t border-border">
                    <CountrySelect
                      toggleState={toggleState}
                      regions={regions}
                    />
                  </div>
                )}
              </nav>

              {/* Footer */}
              <div className="p-6 border-t border-border space-y-4">
                {regions && (
                  <div className="flex items-center justify-between">
                    <span className="text-sm text-muted-foreground">Currency</span>
                    <CurrencySelect regions={regions} currentCurrency={currentCurrency} />
                  </div>
                )}
                <div className="flex items-center justify-between">
                  <span className="text-sm text-muted-foreground">Theme</span>
                  <ThemeToggle />
                </div>
                <p className="text-xs text-muted-foreground">
                  © {new Date().getFullYear()} Nick a Deal. All rights reserved.
                </p>
              </div>
            </div>
          </Dialog.Panel>
        </Transition.Child>
      </Dialog>
    </Transition>
  )
}
