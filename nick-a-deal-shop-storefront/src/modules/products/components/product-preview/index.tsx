import { getProductPrice } from "@lib/util/get-product-price"
import { HttpTypes } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import DealBadge from "@modules/common/components/deal-badge"
import Thumbnail from "../thumbnail"
import PreviewPrice from "./price"
import ProductCardWrapper from "./product-card-wrapper"

export default async function ProductPreview({
  product,
  isFeatured,
  region,
}: {
  product: HttpTypes.StoreProduct
  isFeatured?: boolean
  region: HttpTypes.StoreRegion
}) {
  const { cheapestPrice } = getProductPrice({
    product,
  })

  // Get the collection name, or use null to fall back to default text
  // In MedusaJS, products have a single collection relationship (not collections array)
  const collectionName = product.collection?.title || null

  return (
    <LocalizedClientLink 
      href={`/products/${product.handle}`} 
      className="group block h-full"
    >
      <ProductCardWrapper>
        <div
          data-testid="product-wrapper"
          className="product-card relative h-full flex flex-col bg-card border border-border rounded-3xl overflow-hidden transition-all duration-300 ease-out hover:-translate-y-2"
        >
        {/* Enhanced Deal Badge - Top Left with better positioning */}
        {/* Show collection name if available, otherwise show variant text */}
        <div className="absolute top-3 left-3 z-20">
          <DealBadge 
            variant={isFeatured && !collectionName ? "today" : "approved"} 
            collectionName={collectionName}
          />
        </div>

        {/* Image Container with enhanced padding and hover effects */}
        <div className="relative w-full flex-shrink-0 p-6 pb-4 bg-gradient-to-b from-muted/10 to-transparent">
          <Thumbnail
            thumbnail={product.thumbnail}
            images={product.images}
            size="full"
            isFeatured={isFeatured}
          />
        </div>

        {/* Product Info Section with enhanced spacing and typography */}
        <div className="flex flex-col flex-grow p-5 pt-3 gap-3">
          <h3 
            className="text-card-foreground font-semibold text-base leading-tight line-clamp-2 min-h-[2.5rem] group-hover:text-primary transition-colors duration-300" 
            data-testid="product-title"
          >
            {product.title}
          </h3>
          <div className="flex items-baseline gap-x-2 mt-auto">
            {cheapestPrice && <PreviewPrice price={cheapestPrice} />}
          </div>
        </div>

        {/* Subtle hover gradient overlay */}
        <div className="absolute inset-0 opacity-0 group-hover:opacity-100 bg-gradient-to-br from-primary/5 via-transparent to-secondary/5 pointer-events-none transition-opacity duration-500 rounded-3xl" />
        </div>
      </ProductCardWrapper>
    </LocalizedClientLink>
  )
}
