import { Suspense } from "react"

import { listRegions } from "@lib/data/regions"
import { StoreRegion } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import Logo from "@modules/common/components/logo"
import CartButton from "@modules/layout/components/cart-button"
import SideMenu from "@modules/layout/components/side-menu"

export default async function Nav() {
  const regions = await listRegions().then((regions: StoreRegion[]) => regions)

  return (
    <div className="sticky top-0 inset-x-0 z-50 group">
      <header className="relative h-16 mx-auto border-b duration-200 bg-background/80 backdrop-blur-md border-border">
        <nav className="content-container txt-xsmall-plus text-foreground flex items-center justify-between w-full h-full text-small-regular">
          {/* Left: Side Menu */}
          <div className="flex-1 basis-0 h-full flex items-center">
            <div className="h-full">
              <SideMenu regions={regions} />
            </div>
          </div>

          {/* Center: Logo */}
          <div className="flex items-center h-full justify-center">
            <Logo />
          </div>

          {/* Right: Search, Account, Cart */}
          <div className="flex items-center gap-x-4 h-full flex-1 basis-0 justify-end">
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

            <div className="hidden small:flex items-center gap-x-6 h-full">
              <LocalizedClientLink
                className="hover:text-foreground/80 transition-colors"
                href="/account"
                data-testid="nav-account-link"
              >
                Account
              </LocalizedClientLink>
            </div>
            <Suspense
              fallback={
                <LocalizedClientLink
                  className="hover:text-foreground/80 transition-colors flex gap-2"
                  href="/cart"
                  data-testid="nav-cart-link"
                >
                  Cart (0)
                </LocalizedClientLink>
              }
            >
              <CartButton />
            </Suspense>
          </div>
        </nav>
      </header>
    </div>
  )
}
