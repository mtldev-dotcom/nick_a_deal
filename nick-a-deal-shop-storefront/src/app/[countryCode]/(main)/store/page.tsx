import { Metadata } from "next"

import { SortOptions } from "@modules/store/components/refinement-list/sort-products"
import StoreTemplate from "@modules/store/templates"

export const metadata: Metadata = {
  title: "Shop Deals | Hand‑Picked by Nick",
  description: "Discover the best value picks today — curated deals, trending finds, and editor‑approved products.",
}

type Params = {
  searchParams: Promise<{
    sortBy?: SortOptions
    page?: string
    categoryId?: string
    collectionId?: string
    minPrice?: string
    maxPrice?: string
  }>
  params: Promise<{
    countryCode: string
  }>
}

export default async function StorePage(props: Params) {
  const params = await props.params;
  const searchParams = await props.searchParams;
  const { sortBy, page, categoryId, collectionId, minPrice, maxPrice } = searchParams

  return (
    <StoreTemplate
      sortBy={sortBy}
      page={page}
      categoryId={categoryId}
      collectionId={collectionId}
      minPrice={minPrice}
      maxPrice={maxPrice}
      countryCode={params.countryCode}
    />
  )
}
