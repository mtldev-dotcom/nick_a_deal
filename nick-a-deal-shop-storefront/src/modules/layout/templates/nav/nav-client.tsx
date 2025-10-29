"use client"

import { useState } from "react"
import { StoreRegion, HttpTypes } from "@medusajs/types"

import LocalizedClientLink from "@modules/common/components/localized-client-link"
import Logo from "@modules/common/components/logo"
import CartDropdown from "@modules/layout/components/cart-dropdown"
import DesktopNav from "@modules/layout/components/desktop-nav"
import MobileMenu from "@modules/layout/components/mobile-menu"
import ThemeToggle from "@modules/layout/components/theme-toggle"

type NavClientProps = {
  regions: StoreRegion[] | null
  cart: HttpTypes.StoreCart | null
}

export default function NavClient({ regions, cart }: NavClientProps) {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)

  return (
    <>
      <div className="sticky top-0 inset-x-0 z-50 group">
        <header className="relative h-16 mx-auto border-b duration-200 bg-background/95 backdrop-blur-md border-border shadow-sm">
          <nav className="content-container text-foreground flex items-center justify-between w-full h-full gap-4">
            {/* Left: Mobile Menu Button / Desktop Nav */}
            <div className="flex items-center gap-x-4">
              {/* Mobile Menu Button */}
              <button
                onClick={() => setMobileMenuOpen(true)}
                className="lg:hidden p-2 rounded-lg hover:bg-background/50 transition-colors"
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

              {/* Desktop Navigation */}
              <DesktopNav />
            </div>

            {/* Center: Logo */}
            <div className="flex items-center h-full justify-center flex-1 lg:flex-initial">
              <Logo />
            </div>

            {/* Right: Search, Theme Toggle, Account, Cart */}
            <div className="flex items-center gap-x-2 sm:gap-x-4 h-full">
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

              {/* Theme Toggle */}
              <ThemeToggle />

              {/* Account Link (Desktop) */}
              <div className="hidden lg:flex items-center">
                <LocalizedClientLink
                  className="px-3 py-2 text-sm font-medium hover:text-primary transition-colors"
                  href="/account"
                  data-testid="nav-account-link"
                >
                  Account
                </LocalizedClientLink>
              </div>

              {/* Cart Button */}
              <CartDropdown cart={cart} />
            </div>
          </nav>
        </header>
      </div>

      {/* Mobile Menu */}
      <MobileMenu
        isOpen={mobileMenuOpen}
        onClose={() => setMobileMenuOpen(false)}
        regions={regions}
      />
    </>
  )
}
