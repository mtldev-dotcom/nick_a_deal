import { HttpTypes } from "@medusajs/types"
import { Heading, Text } from "@medusajs/ui"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

type ProductInfoProps = {
  product: HttpTypes.StoreProduct
}

const ProductInfo = ({ product }: ProductInfoProps) => {
  return (
    <div id="product-info">
      <div className="flex flex-col gap-y-4 lg:max-w-[500px] mx-auto">
        {product.collection && (
          <LocalizedClientLink
            href={`/collections/${product.collection.handle}`}
            className="text-medium text-ui-fg-muted hover:text-ui-fg-subtle"
          >
            {product.collection.title}
          </LocalizedClientLink>
        )}
        <Heading
          level="h2"
          className="text-3xl leading-10 text-ui-fg-base"
          data-testid="product-title"
        >
          {product.title}
        </Heading>

        <Text
          className="text-medium text-ui-fg-subtle whitespace-pre-line"
          data-testid="product-description"
        >
          {product.description}
        </Text>

        {/* Why Nick picked this - Trust Block */}
        <div className="mt-6 p-4 rounded-2xl bg-[color:var(--cloud-100)] dark:bg-[#1A1B20] border border-border">
          <h3 className="text-base font-semibold text-foreground mb-3">
            Why Nick picked this
          </h3>
          <ul className="flex flex-col gap-2 text-sm text-foreground/80">
            <li className="flex items-start gap-2">
              <span className="text-[color:var(--accent-500)] font-bold">✓</span>
              <span>Best price today vs market average</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-[color:var(--accent-500)] font-bold">✓</span>
              <span>Verified quality from trusted supplier</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-[color:var(--accent-500)] font-bold">✓</span>
              <span>Great value for the money</span>
            </li>
          </ul>
        </div>

        {/* Best Price Note */}
        <div className="mt-4 p-3 rounded-lg bg-[color:var(--accent-50)] dark:bg-[#0B1A2A] border border-[color:var(--accent-500)]/20">
          <p className="text-xs text-foreground/70">
            <strong className="text-foreground">Is this the best price?</strong>{" "}
            We track prices daily. This is the best deal we've found today. Prices change frequently, so grab it while you can!
          </p>
        </div>
      </div>
    </div>
  )
}

export default ProductInfo
