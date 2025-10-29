import { VariantPrice } from "types/global"

export default async function PreviewPrice({ price }: { price: VariantPrice }) {
  if (!price) {
    return null
  }

  return (
    <div className="flex items-center gap-x-2">
      {price.price_type === "sale" && (
        <span
          className="line-through text-muted-foreground text-sm"
          data-testid="original-price"
        >
          {price.original_price}
        </span>
      )}
      <span
        className={`text-sm font-semibold ${
          price.price_type === "sale"
            ? "text-[color:var(--brand-700)] dark:text-[color:var(--primary)]"
            : "text-foreground"
        }`}
        data-testid="price"
      >
        {price.calculated_price}
      </span>
    </div>
  )
}
