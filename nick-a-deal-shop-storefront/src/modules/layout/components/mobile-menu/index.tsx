"use client"

import { Dialog, Transition } from "@headlessui/react"
import { XMark } from "@medusajs/icons"
import { Fragment, useState, useEffect } from "react"
import { usePathname, useParams } from "next/navigation"

import LocalizedClientLink from "@modules/common/components/localized-client-link"
import CurrencySelect from "../currency-select"
import ThemeToggle from "../theme-toggle"
import ChevronDown from "@modules/common/icons/chevron-down"
import { HttpTypes } from "@medusajs/types"
import { useMemo } from "react"
import { cn } from "@lib/util/cn"

type SidebarMenuProps = {
  isOpen: boolean
  onClose: () => void
  regions: HttpTypes.StoreRegion[] | null
  categories: HttpTypes.StoreProductCategory[]
  collections: HttpTypes.StoreCollection[]
}

/**
 * Unified sidebar menu with smooth slide-in animation
 * Works on all screen sizes (mobile, tablet, desktop)
 * Fetches categories and collections from Medusa API
 */
export default function SidebarMenu({ isOpen, onClose, regions, categories, collections }: SidebarMenuProps) {
  const pathname = usePathname()
  const { countryCode } = useParams() as { countryCode: string }
  const [categoriesExpanded, setCategoriesExpanded] = useState(false)
  const [collectionsExpanded, setCollectionsExpanded] = useState(false)

  // Get current currency from the current region
  const currentCurrency = useMemo(() => {
    if (!regions || !countryCode) return undefined

    const currentRegion = regions.find((r) =>
      r.countries?.some((c) => c.iso_2?.toLowerCase() === countryCode?.toLowerCase())
    )

    return currentRegion?.currency_code
  }, [regions, countryCode])

  // Filter top-level categories (no parent)
  const topLevelCategories = useMemo(() => {
    return categories.filter((cat) => !cat.parent_category_id)
  }, [categories])

  // Body scroll lock when sidebar is open
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = "hidden"
    } else {
      document.body.style.overflow = ""
    }

    // Cleanup on unmount
    return () => {
      document.body.style.overflow = ""
    }
  }, [isOpen])

  // Handle country code prefix in pathname
  const getActivePath = (href: string) => {
    if (!pathname || !countryCode) return false
    const normalizedPath = pathname.split(`/${countryCode}`)[1] || "/"
    return normalizedPath === href || normalizedPath.startsWith(`${href}/`)
  }

  // Reset expanded states when sidebar closes
  useEffect(() => {
    if (!isOpen) {
      setCategoriesExpanded(false)
      setCollectionsExpanded(false)
    }
  }, [isOpen])

  // Check if categories or collections sections should be active
  const isCategoriesActive = getActivePath("/categories")
  const isCollectionsActive = getActivePath("/collections")

  return (
    <Transition show={isOpen} as={Fragment}>
      <Dialog onClose={onClose} className="relative z-40">
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
          <div className="fixed top-16 inset-x-0 bottom-0 bg-black/60 backdrop-blur-sm" aria-hidden="true" />
        </Transition.Child>

        {/* Slide panel from left - positioned below header */}
        <Transition.Child
          as={Fragment}
          enter="ease-out duration-300 transform"
          enterFrom="-translate-x-full"
          enterTo="translate-x-0"
          leave="ease-in duration-200 transform"
          leaveFrom="translate-x-0"
          leaveTo="-translate-x-full"
        >
          <Dialog.Panel className="fixed top-16 bottom-0 left-0 w-80 max-w-sm bg-card border-r border-border shadow-xl">
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

              {/* Navigation Items - Scrollable */}
              <nav className="flex-1 overflow-y-auto px-6 py-6">
                <ul className="space-y-2">
                  {/* Home */}
                  <li>
                    <LocalizedClientLink
                      href="/"
                      onClick={onClose}
                      className={cn(
                        "block px-4 py-3 rounded-xl text-base font-medium transition-all duration-150",
                        getActivePath("/")
                          ? "bg-primary/10 text-primary border-l-4 border-primary"
                          : "text-foreground hover:bg-background/50 hover:text-primary"
                      )}
                    >
                      Home
                    </LocalizedClientLink>
                  </li>

                  {/* Store */}
                  <li>
                    <LocalizedClientLink
                      href="/store"
                      onClick={onClose}
                      className={cn(
                        "block px-4 py-3 rounded-xl text-base font-medium transition-all duration-150",
                        getActivePath("/store")
                          ? "bg-primary/10 text-primary border-l-4 border-primary"
                          : "text-foreground hover:bg-background/50 hover:text-primary"
                      )}
                    >
                      Store
                    </LocalizedClientLink>
                  </li>

                  {/* Categories - Expandable */}
                  <li>
                    <div className="flex flex-col">
                      <div className="flex items-center justify-between">
                        {topLevelCategories.length > 0 ? (
                          <button
                            onClick={() => {
                              setCategoriesExpanded(!categoriesExpanded)
                            }}
                            className={cn(
                              "flex-1 flex items-center px-4 py-3 rounded-xl text-base font-medium transition-all duration-150",
                              isCategoriesActive
                                ? "bg-primary/10 text-primary border-l-4 border-primary"
                                : "text-foreground hover:bg-background/50 hover:text-primary"
                            )}
                            aria-label={`${categoriesExpanded ? "Collapse" : "Expand"} Categories`}
                            aria-expanded={categoriesExpanded}
                          >
                            <ChevronDown
                              className={cn(
                                "mr-2 w-5 h-5 text-foreground transition-transform duration-200",
                                categoriesExpanded && "rotate-180"
                              )}
                            />
                            Categories
                          </button>
                        ) : (
                          <LocalizedClientLink
                            href="/categories"
                            onClick={onClose}
                            className={cn(
                              "flex-1 block px-4 py-3 rounded-xl text-base font-medium transition-all duration-150",
                              isCategoriesActive
                                ? "bg-primary/10 text-primary border-l-4 border-primary"
                                : "text-foreground hover:bg-background/50 hover:text-primary"
                            )}
                          >
                            Categories
                          </LocalizedClientLink>
                        )}
                      </div>

                      {/* Subcategories */}
                      {categoriesExpanded && topLevelCategories.length > 0 && (
                        <div className="mt-2 ml-4 space-y-1">
                          {topLevelCategories.map((category) => {
                            const categoryHref = `/categories/${category.handle}`
                            const isCategoryActive = getActivePath(categoryHref)
                            return (
                              <LocalizedClientLink
                                key={category.id}
                                href={categoryHref}
                                onClick={onClose}
                                className={cn(
                                  "block px-4 py-2 rounded-lg text-sm transition-all duration-150",
                                  isCategoryActive
                                    ? "bg-primary/10 text-primary border-l-2 border-primary"
                                    : "text-foreground/80 hover:bg-background/50 hover:text-primary"
                                )}
                              >
                                {category.name}
                              </LocalizedClientLink>
                            )
                          })}
                        </div>
                      )}
                    </div>
                  </li>

                  {/* Collections - Expandable */}
                  <li>
                    <div className="flex flex-col">
                      <div className="flex items-center justify-between">
                        {collections.length > 0 ? (
                          <button
                            onClick={() => {
                              setCollectionsExpanded(!collectionsExpanded)
                            }}
                            className={cn(
                              "flex-1 flex items-center px-4 py-3 rounded-xl text-base font-medium transition-all duration-150",
                              isCollectionsActive
                                ? "bg-primary/10 text-primary border-l-4 border-primary"
                                : "text-foreground hover:bg-background/50 hover:text-primary"
                            )}
                            aria-label={`${collectionsExpanded ? "Collapse" : "Expand"} Collections`}
                            aria-expanded={collectionsExpanded}
                          >
                            <ChevronDown
                              className={cn(
                                "mr-2 w-5 h-5 text-foreground transition-transform duration-200",
                                collectionsExpanded && "rotate-180"
                              )}
                            />
                            Collections
                          </button>
                        ) : (
                          <LocalizedClientLink
                            href="/collections"
                            onClick={onClose}
                            className={cn(
                              "flex-1 block px-4 py-3 rounded-xl text-base font-medium transition-all duration-150",
                              isCollectionsActive
                                ? "bg-primary/10 text-primary border-l-4 border-primary"
                                : "text-foreground hover:bg-background/50 hover:text-primary"
                            )}
                          >
                            Collections
                          </LocalizedClientLink>
                        )}
                      </div>

                      {/* Subcollections */}
                      {collectionsExpanded && collections.length > 0 && (
                        <div className="mt-2 ml-4 space-y-1">
                          {collections.map((collection) => {
                            const collectionHref = `/collections/${collection.handle}`
                            const isCollectionActive = getActivePath(collectionHref)
                            return (
                              <LocalizedClientLink
                                key={collection.id}
                                href={collectionHref}
                                onClick={onClose}
                                className={cn(
                                  "block px-4 py-2 rounded-lg text-sm transition-all duration-150",
                                  isCollectionActive
                                    ? "bg-primary/10 text-primary border-l-2 border-primary"
                                    : "text-foreground/80 hover:bg-background/50 hover:text-primary"
                                )}
                              >
                                {collection.title}
                              </LocalizedClientLink>
                            )
                          })}
                        </div>
                      )}
                    </div>
                  </li>
                </ul>
              </nav>

              {/* Bottom Section - Account, Theme, Currency */}
              <div className="p-6 border-t border-border space-y-4">
                {/* Account Link */}
                <LocalizedClientLink
                  href="/account"
                  onClick={onClose}
                  className={cn(
                    "flex items-center px-4 py-3 rounded-xl text-base font-medium transition-all duration-150",
                    getActivePath("/account")
                      ? "bg-primary/10 text-primary border-l-4 border-primary"
                      : "text-foreground hover:bg-background/50 hover:text-primary"
                  )}
                >
                  Account
                </LocalizedClientLink>

                {/* Theme Toggle */}
                <div className="flex items-center justify-between px-4 py-3 rounded-xl hover:bg-background/50 transition-colors">
                  <span className="text-sm font-medium text-foreground">Theme mode</span>
                  <ThemeToggle />
                </div>

                {/* Currency Selector */}
                {regions && (
                  <div className="flex items-center justify-between px-4 py-3 rounded-xl hover:bg-background/50 transition-colors">
                    <span className="text-sm font-medium text-foreground">Currency</span>
                    <CurrencySelect regions={regions} currentCurrency={currentCurrency} />
                  </div>
                )}
              </div>
            </div>
          </Dialog.Panel>
        </Transition.Child>
      </Dialog>
    </Transition>
  )
}
