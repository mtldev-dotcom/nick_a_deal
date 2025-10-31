"use client"

import { usePathname, useRouter, useSearchParams } from "next/navigation"
import { useCallback, useMemo, useState, useEffect } from "react"
import NativeSelect from "@modules/common/components/native-select"
import { SortOptions } from "../refinement-list/sort-products"
import { HttpTypes } from "@medusajs/types"

type StoreFiltersProps = {
  sortBy: SortOptions
  selectedCategoryId?: string
  selectedCollectionId?: string
  categories: HttpTypes.StoreProductCategory[]
  collections: HttpTypes.StoreCollection[]
}

const sortOptions = [
  {
    value: "created_at",
    label: "Latest Arrivals",
  },
  {
    value: "price_asc",
    label: "Price: Low → High",
  },
  {
    value: "price_desc",
    label: "Price: High → Low",
  },
]

const StoreFilters = ({
  sortBy,
  selectedCategoryId,
  selectedCollectionId,
  categories,
  collections,
}: StoreFiltersProps) => {
  const router = useRouter()
  const pathname = usePathname()
  const searchParams = useSearchParams()

  // Create a memoized function to update query params
  const createQueryString = useCallback(
    (updates: Record<string, string | null>) => {
      const params = new URLSearchParams(searchParams)
      
      // Apply updates
      Object.entries(updates).forEach(([key, value]) => {
        if (value === null || value === "" || value === "all") {
          params.delete(key)
        } else {
          params.set(key, value)
        }
      })
      
      // Reset page to 1 when filters change
      params.set("page", "1")

      return params.toString()
    },
    [searchParams]
  )

  // Handler for sort changes
  const handleSortChange = (value: string) => {
    const query = createQueryString({ sortBy: value })
    router.push(`${pathname}?${query}`)
  }

  // Handler for category changes
  const handleCategoryChange = (value: string) => {
    const query = createQueryString({ 
      categoryId: value === "all" ? null : value 
    })
    router.push(`${pathname}?${query}`)
  }

  // Handler for collection changes
  const handleCollectionChange = (value: string) => {
    const query = createQueryString({ 
      collectionId: value === "all" ? null : value 
    })
    router.push(`${pathname}?${query}`)
  }

  // Handlers for price range - use state to keep inputs in sync with URL
  const minFromParams = searchParams.get("minPrice") || ""
  const maxFromParams = searchParams.get("maxPrice") || ""
  const [minPriceInput, setMinPriceInput] = useState(minFromParams)
  const [maxPriceInput, setMaxPriceInput] = useState(maxFromParams)

  // Sync inputs when URL params change (e.g., when clear filters is clicked)
  useEffect(() => {
    setMinPriceInput(minFromParams)
    setMaxPriceInput(maxFromParams)
  }, [minFromParams, maxFromParams])

  const applyPriceRange = (min: string, max: string) => {
    const cleanedMin = min && !isNaN(Number(min)) ? String(Math.max(0, Number(min))) : ""
    const cleanedMax = max && !isNaN(Number(max)) ? String(Math.max(0, Number(max))) : ""
    const query = createQueryString({
      minPrice: cleanedMin || null,
      maxPrice: cleanedMax || null,
    })
    router.push(`${pathname}?${query}`)
  }

  // Filter to show only top-level categories (no parent)
  const displayCategories = useMemo(() => {
    return categories.filter((cat) => {
      // Show only top-level categories (those without a parent)
      return !cat.parent_category
    })
  }, [categories])

  return (
    <div className="w-full mb-8 small:mb-12">
      <div className="flex flex-wrap items-center gap-4 small:gap-6">
        {/* Sort By */}
        <div className="flex items-center gap-2">
          <label
            htmlFor="sort-select"
            className="text-sm font-medium text-foreground whitespace-nowrap"
          >
            Sort by:
          </label>
          <NativeSelect
            id="sort-select"
            value={sortBy}
            onChange={(e) => handleSortChange(e.target.value)}
            className="min-w-[180px]"
          >
            {sortOptions.map((option) => (
              <option key={option.value} value={option.value}>
                {option.label}
              </option>
            ))}
          </NativeSelect>
        </div>

        {/* View by Category */}
        {displayCategories.length > 0 && (
          <div className="flex items-center gap-2">
            <label
              htmlFor="category-select"
              className="text-sm font-medium text-foreground whitespace-nowrap"
            >
              View by category:
            </label>
            <NativeSelect
              id="category-select"
              value={selectedCategoryId || "all"}
              onChange={(e) => handleCategoryChange(e.target.value)}
              className="min-w-[180px]"
            >
              <option value="all">All Categories</option>
              {displayCategories.map((category) => (
                <option key={category.id} value={category.id}>
                  {category.name}
                </option>
              ))}
            </NativeSelect>
          </div>
        )}

        {/* View by Collection */}
        {collections.length > 0 && (
          <div className="flex items-center gap-2">
            <label
              htmlFor="collection-select"
              className="text-sm font-medium text-foreground whitespace-nowrap"
            >
              View by collection:
            </label>
            <NativeSelect
              id="collection-select"
              value={selectedCollectionId || "all"}
              onChange={(e) => handleCollectionChange(e.target.value)}
              className="min-w-[180px]"
            >
              <option value="all">All Collections</option>
              {collections.map((collection) => (
                <option key={collection.id} value={collection.id}>
                  {collection.title}
                </option>
              ))}
            </NativeSelect>
          </div>
        )}

        {/* Price Range */}
        <div className="flex items-center gap-2">
          <label className="text-sm font-medium text-foreground whitespace-nowrap">
            Price:
          </label>
          <input
            type="number"
            inputMode="numeric"
            min={0}
            value={minPriceInput}
            onChange={(e) => setMinPriceInput(e.target.value)}
            placeholder="Min"
            onBlur={(e) => applyPriceRange(e.target.value, maxPriceInput)}
            onKeyDown={(e) => {
              if (e.key === "Enter") applyPriceRange((e.target as HTMLInputElement).value, maxPriceInput)
            }}
            className="w-20 rounded-lg border border-border bg-card px-2 py-1.5 text-sm text-foreground outline-none focus:border-primary"
          />
          <span className="text-muted-foreground">–</span>
          <input
            type="number"
            inputMode="numeric"
            min={0}
            value={maxPriceInput}
            onChange={(e) => setMaxPriceInput(e.target.value)}
            placeholder="Max"
            onBlur={(e) => applyPriceRange(minPriceInput, e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") applyPriceRange(minPriceInput, (e.target as HTMLInputElement).value)
            }}
            className="w-20 rounded-lg border border-border bg-card px-2 py-1.5 text-sm text-foreground outline-none focus:border-primary"
          />
        </div>

        {/* Clear Filters Button - Show only if any filter is active */}
        {(selectedCategoryId || selectedCollectionId || minFromParams || maxFromParams) && (
          <button
            onClick={() => {
              const query = createQueryString({
                categoryId: null,
                collectionId: null,
                minPrice: null,
                maxPrice: null,
              })
              router.push(`${pathname}?${query}`)
            }}
            className="ml-auto text-sm text-muted-foreground hover:text-foreground underline transition-colors whitespace-nowrap"
          >
            Clear filters
          </button>
        )}
      </div>

      {/* Dynamic filter summary */}
      <div className="mt-3 text-sm text-muted-foreground" aria-live="polite">
        {(() => {
          const sortLabel = sortOptions.find((o) => o.value === sortBy)?.label || "Latest Arrivals"
          const categoryLabel =
            displayCategories.find((c) => c.id === selectedCategoryId)?.name || "All Categories"
          const collectionLabel =
            collections.find((c) => c.id === selectedCollectionId)?.title || "All Collections"
          const priceSummary = (() => {
            if (minFromParams && maxFromParams) return `$${minFromParams}–$${maxFromParams}`
            if (minFromParams) return `from $${minFromParams}`
            if (maxFromParams) return `up to $${maxFromParams}`
            return "all prices"
          })()

          return (
            <span>
              Showing <span className="font-medium text-foreground">{collectionLabel}</span>
              {" • "}
              <span className="font-medium text-foreground">{categoryLabel}</span>
              {" • Sorted by "}
              <span className="font-medium text-foreground">{sortLabel}</span>
              {" • "}
              <span className="font-medium text-foreground">{priceSummary}</span>
            </span>
          )
        })()}
      </div>
    </div>
  )
}

export default StoreFilters

