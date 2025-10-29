import { listRegions } from "@lib/data/regions"
import { retrieveCart } from "@lib/data/cart"
import { StoreRegion } from "@medusajs/types"
import NavClient from "./nav-client"

export default async function Nav() {
  const regions = await listRegions().then((regions: StoreRegion[]) => regions)
  const cart = await retrieveCart().catch(() => null)

  return <NavClient regions={regions} cart={cart} />
}
