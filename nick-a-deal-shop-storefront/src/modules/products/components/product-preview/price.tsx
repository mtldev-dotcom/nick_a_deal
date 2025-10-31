import { VariantPrice } from "types/global"

export default async function PreviewPrice({ price }: { price: VariantPrice }) {
  if (!price) {
    return null
  }

  return (
    <div className="flex items-baseline gap-x-2 flex-wrap">
      {price.price_type === "sale" && (
        <span
          className="line-through text-muted-foreground text-sm font-medium opacity-75"
          data-testid="original-price"
        >
          {price.original_price}
        </span>
      )}
      <span
        className={`text-lg font-bold tracking-tight ${
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
