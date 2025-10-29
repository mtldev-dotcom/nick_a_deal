import { clx } from "@medusajs/ui"

import { getProductPrice } from "@lib/util/get-product-price"
import { HttpTypes } from "@medusajs/types"

export default function ProductPrice({
  product,
  variant,
}: {
  product: HttpTypes.StoreProduct
  variant?: HttpTypes.StoreProductVariant
}) {
  const { cheapestPrice, variantPrice } = getProductPrice({
    product,
    variantId: variant?.id,
  })

  const selectedPrice = variant ? variantPrice : cheapestPrice

  if (!selectedPrice) {
    return <div className="block w-32 h-9 bg-muted animate-pulse rounded" />
  }

  return (
    <div className="flex flex-col gap-y-2 pb-4 border-b border-border">
      <div className="flex items-baseline gap-x-2">
        {selectedPrice.price_type === "sale" && (
          <span
            className="text-sm text-muted-foreground line-through"
            data-testid="original-product-price"
            data-value={selectedPrice.original_price_number}
          >
            {selectedPrice.original_price}
          </span>
        )}
        <span
          className={clx("text-2xl font-semibold", {
            "text-primary": selectedPrice.price_type === "sale",
            "text-foreground": selectedPrice.price_type !== "sale",
          })}
        >
          {!variant && "From "}
          <span
            data-testid="product-price"
            data-value={selectedPrice.calculated_price_number}
          >
            {selectedPrice.calculated_price}
          </span>
        </span>
      </div>
      {selectedPrice.price_type === "sale" && (
        <span className="text-sm font-medium text-primary">
          Save {selectedPrice.percentage_diff}%
        </span>
      )}
    </div>
  )
}
