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
            className="text-sm font-medium text-muted-foreground hover:text-primary transition-colors"
          >
            {product.collection.title}
          </LocalizedClientLink>
        )}
        <Heading
          level="h2"
          className="text-3xl md:text-4xl leading-tight font-semibold text-foreground"
          data-testid="product-title"
        >
          {product.title}
        </Heading>

        <Text
          className="text-base md:text-lg text-muted-foreground whitespace-pre-line leading-relaxed"
          data-testid="product-description"
        >
          {product.description}
        </Text>

        {/* Why Nick picked this - Trust Block */}
        <div className="mt-6 p-5 rounded-2xl bg-card border border-border shadow-sm">
          <h3 className="text-base font-semibold text-foreground mb-4">
            Why Nick picked this
          </h3>
          <ul className="flex flex-col gap-3 text-sm">
            <li className="flex items-start gap-3">
              <span className="text-accent-500 font-bold text-base leading-none mt-0.5">✓</span>
              <span className="text-foreground">Best price today vs market average</span>
            </li>
            <li className="flex items-start gap-3">
              <span className="text-accent-500 font-bold text-base leading-none mt-0.5">✓</span>
              <span className="text-foreground">Verified quality from trusted supplier</span>
            </li>
            <li className="flex items-start gap-3">
              <span className="text-accent-500 font-bold text-base leading-none mt-0.5">✓</span>
              <span className="text-foreground">Great value for the money</span>
            </li>
          </ul>
        </div>

        {/* Best Price Note */}
        <div className="mt-4 p-4 rounded-lg bg-card border border-accent-500/40 dark:border-accent-500/20">
          <p className="text-sm text-foreground leading-relaxed">
            <strong className="text-foreground font-semibold">Is this the best price?</strong>{" "}
            We track prices daily. This is the best deal we&apos;ve found today. Prices change frequently, so grab it while you can!
          </p>
        </div>
      </div>
    </div>
  )
}

export default ProductInfo
