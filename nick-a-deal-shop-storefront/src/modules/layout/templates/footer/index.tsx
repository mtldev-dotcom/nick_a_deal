import { listCategories } from "@lib/data/categories"
import { listCollections } from "@lib/data/collections"

import LocalizedClientLink from "@modules/common/components/localized-client-link"
import Logo from "@modules/common/components/logo"

export default async function Footer() {
  const { collections } = await listCollections({
    fields: "*products",
  })
  const productCategories = await listCategories()

  return (
    <footer className="border-t border-border bg-background w-full">
      <div className="content-container flex flex-col w-full">
        <div className="flex flex-col gap-y-12 xsmall:flex-row items-start justify-between py-16 md:py-24">
          {/* Brand Section */}
          <div className="flex flex-col gap-y-4">
            <Logo />
            <p className="text-sm text-muted-foreground max-w-xs">
              Deals hand-picked by Nick. If Nick approved it, it's a deal.
            </p>
          </div>

          {/* Links Grid */}
          <div className="text-small-regular gap-10 md:gap-x-16 grid grid-cols-2 sm:grid-cols-3">
            {productCategories && productCategories?.length > 0 && (
              <div className="flex flex-col gap-y-4">
                <span className="text-sm font-semibold text-foreground">
                  Categories
                </span>
                <ul
                  className="flex flex-col gap-2"
                  data-testid="footer-categories"
                >
                  {productCategories?.slice(0, 6).map((c) => {
                    if (c.parent_category) {
                      return null
                    }

                    return (
                      <li key={c.id}>
                        <LocalizedClientLink
                          className="text-sm text-muted-foreground hover:text-primary transition-colors"
                          href={`/categories/${c.handle}`}
                          data-testid="category-link"
                        >
                          {c.name}
                        </LocalizedClientLink>
                      </li>
                    )
                  })}
                </ul>
              </div>
            )}
            {collections && collections.length > 0 && (
              <div className="flex flex-col gap-y-4">
                <span className="text-sm font-semibold text-foreground">
                  Collections
                </span>
                <ul className="flex flex-col gap-2">
                  {collections?.slice(0, 6).map((c) => (
                    <li key={c.id}>
                      <LocalizedClientLink
                        className="text-sm text-muted-foreground hover:text-primary transition-colors"
                        href={`/collections/${c.handle}`}
                      >
                        {c.title}
                      </LocalizedClientLink>
                    </li>
                  ))}
                </ul>
              </div>
            )}
            <div className="flex flex-col gap-y-4">
              <span className="text-sm font-semibold text-foreground">
                Help
              </span>
              <ul className="flex flex-col gap-y-2">
                <li>
                  <LocalizedClientLink
                    href="/account"
                    className="text-sm text-muted-foreground hover:text-primary transition-colors"
                  >
                    Account
                  </LocalizedClientLink>
                </li>
                <li>
                  <LocalizedClientLink
                    href="/account/orders"
                    className="text-sm text-muted-foreground hover:text-primary transition-colors"
                  >
                    Orders
                  </LocalizedClientLink>
                </li>
                <li>
                  <LocalizedClientLink
                    href="/store"
                    className="text-sm text-muted-foreground hover:text-primary transition-colors"
                  >
                    Shop All
                  </LocalizedClientLink>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div className="flex flex-col sm:flex-row w-full pb-8 justify-between items-center gap-4 text-muted-foreground">
          <p className="text-xs">
            © {new Date().getFullYear()} Nick a Deal. All rights reserved.
          </p>
          <div className="flex items-center gap-x-4 text-xs">
            <LocalizedClientLink
              href="#"
              className="hover:text-primary transition-colors"
            >
              Privacy
            </LocalizedClientLink>
            <LocalizedClientLink
              href="#"
              className="hover:text-primary transition-colors"
            >
              Terms
            </LocalizedClientLink>
          </div>
        </div>
      </div>
    </footer>
  )
}
