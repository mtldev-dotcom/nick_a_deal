import LocalizedClientLink from "@modules/common/components/localized-client-link"
import ChevronDown from "@modules/common/icons/chevron-down"
import Logo from "@modules/common/components/logo"
import Footer from "@modules/layout/templates/footer"

export default function CheckoutLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="w-full bg-background relative small:min-h-screen">
      <div className="h-16 bg-background/95 backdrop-blur-md border-b border-border sticky top-0 z-50 shadow-sm">
        <nav className="flex h-full items-center content-container justify-between">
          <LocalizedClientLink
            href="/cart"
            className="text-sm font-medium text-foreground flex items-center gap-x-2 flex-1 basis-0 hover:text-primary transition-colors"
            data-testid="back-to-cart-link"
          >
            <ChevronDown className="rotate-90" size={16} />
            <span className="mt-px hidden small:block">
              Back to shopping cart
            </span>
            <span className="mt-px block small:hidden">
              Back
            </span>
          </LocalizedClientLink>
          <LocalizedClientLink
            href="/"
            className="flex-1 basis-0 flex justify-center"
            data-testid="store-link"
          >
            <Logo />
          </LocalizedClientLink>
          <div className="flex-1 basis-0" />
        </nav>
      </div>
      <div className="relative" data-testid="checkout-container">{children}</div>
      <Footer />
    </div>
  )
}
