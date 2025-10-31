import { listRegions } from "@lib/data/regions"
import { retrieveCart } from "@lib/data/cart"
import { listCategories } from "@lib/data/categories"
import { listCollections } from "@lib/data/collections"
import { StoreRegion } from "@medusajs/types"
import NavClient from "./nav-client"

export default async function Nav() {
  const regions = await listRegions().then((regions: StoreRegion[]) => regions)
  const cart = await retrieveCart().catch(() => null)
  const categories = await listCategories().catch(() => [])
  const { collections } = await listCollections().catch(() => ({ collections: [], count: 0 }))

  return <NavClient regions={regions} cart={cart} categories={categories} collections={collections} />
}
