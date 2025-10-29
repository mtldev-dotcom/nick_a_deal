"use client"

import { usePathname, useParams } from "next/navigation"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import { cn } from "@lib/util/cn"

const NavItems = [
  { name: "Home", href: "/" },
  { name: "Store", href: "/store" },
  { name: "Categories", href: "/categories" },
]

/**
 * Desktop navigation menu with active state indicators
 */
export default function DesktopNav() {
  const pathname = usePathname()
  const { countryCode } = useParams() as { countryCode: string }

  return (
    <nav className="hidden lg:flex items-center gap-x-8">
      {NavItems.map((item) => {
        // Handle country code prefix in pathname
        if (!pathname || !countryCode) {
          return null
        }
        const normalizedPath = pathname.split(`/${countryCode}`)[1] || "/"
        const isActive = normalizedPath === item.href || normalizedPath.startsWith(`${item.href}/`)
        
        return (
          <LocalizedClientLink
            key={item.name}
            href={item.href}
            className={cn(
              "relative px-3 py-2 text-sm font-medium transition-colors duration-150",
              isActive
                ? "text-primary"
                : "text-foreground/70 hover:text-foreground"
            )}
          >
            {item.name}
            {isActive && (
              <span className="absolute bottom-0 left-0 right-0 h-0.5 bg-primary rounded-full" />
            )}
          </LocalizedClientLink>
        )
      })}
    </nav>
  )
}
