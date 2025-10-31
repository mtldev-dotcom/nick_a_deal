import { Suspense } from "react"

import SkeletonProductGrid from "@modules/skeletons/templates/skeleton-product-grid"
import StoreFilters from "@modules/store/components/store-filters"
import { SortOptions } from "@modules/store/components/refinement-list/sort-products"
import { listCollections } from "@lib/data/collections"
import { listCategories } from "@lib/data/categories"

import PaginatedProducts from "./paginated-products"

const StoreTemplate = async ({
  sortBy,
  page,
  categoryId,
  collectionId,
  minPrice,
  maxPrice,
  countryCode,
}: {
  sortBy?: SortOptions
  page?: string
  categoryId?: string
  collectionId?: string
  minPrice?: string
  maxPrice?: string
  countryCode: string
}) => {
  const pageNumber = page ? parseInt(page) : 1
  const sort = sortBy || "created_at"

  // Fetch collections and categories in parallel
  const [collectionsData, categories] = await Promise.all([
    listCollections(),
    listCategories(),
  ])

  return (
    <div
      className="flex flex-col py-8 small:py-12 content-container"
      data-testid="category-container"
    >
      <div className="w-full">
        {/* Enhanced store header */}
        <div className="mb-8 small:mb-10">
          <div className="flex items-start justify-between gap-4">
            <h1
              className="text-4xl small:text-5xl font-extrabold tracking-tight bg-gradient-to-r from-[color:var(--brand-500)] to-[color:var(--accent-500)] bg-clip-text text-transparent drop-shadow-sm"
              data-testid="store-page-title"
            >
              Shop Nick's Hand‑Picked Deals
            </h1>
            <span className="hidden small:inline-flex items-center rounded-full border border-border bg-card px-3 py-1 text-xs font-semibold text-muted-foreground shadow-sm">
              New deals weekly
            </span>
          </div>
          <p className="text-muted-foreground mt-2 text-sm small:text-base">
            Curated deals, hand-picked by Nick
          </p>
          <div className="mt-4 h-px w-full bg-gradient-to-r from-transparent via-[color:var(--border)] to-transparent" />
        </div>
        
        {/* Horizontal Filter Bar */}
        <StoreFilters
          sortBy={sort}
          selectedCategoryId={categoryId}
          selectedCollectionId={collectionId}
          categories={categories}
          collections={collectionsData.collections}
        />

        <Suspense fallback={<SkeletonProductGrid />}>
          <PaginatedProducts
            sortBy={sort}
            page={pageNumber}
            categoryId={categoryId}
            collectionId={collectionId}
            minPrice={minPrice ? Number(minPrice) : undefined}
            maxPrice={maxPrice ? Number(maxPrice) : undefined}
            countryCode={countryCode}
          />
        </Suspense>
      </div>
    </div>
  )
}

export default StoreTemplate
