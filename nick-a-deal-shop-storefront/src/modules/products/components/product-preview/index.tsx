import { getProductPrice } from "@lib/util/get-product-price"
import { HttpTypes } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import DealBadge from "@modules/common/components/deal-badge"
import Thumbnail from "../thumbnail"
import PreviewPrice from "./price"

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

  return (
    <LocalizedClientLink href={`/products/${product.handle}`} className="group">
      <div
        data-testid="product-wrapper"
        className="relative bg-card border border-border rounded-2xl p-4 shadow-sm hover:shadow-glow-cyan hover:-translate-y-1 transition-all duration-150"
      >
        {/* Deal Badge - Top Left */}
        <div className="absolute top-4 left-4 z-10">
          <DealBadge variant={isFeatured ? "today" : "approved"} />
        </div>

        <Thumbnail
          thumbnail={product.thumbnail}
          images={product.images}
          size="full"
          isFeatured={isFeatured}
        />
        <div className="flex flex-col txt-compact-medium mt-4 gap-2">
          <h3 className="text-card-foreground font-medium" data-testid="product-title">
            {product.title}
          </h3>
          <div className="flex items-center gap-x-2">
            {cheapestPrice && <PreviewPrice price={cheapestPrice} />}
          </div>
        </div>
      </div>
    </LocalizedClientLink>
  )
}
