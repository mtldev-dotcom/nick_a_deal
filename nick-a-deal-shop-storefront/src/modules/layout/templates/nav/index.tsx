import { listRegions } from "@lib/data/regions"
import { StoreRegion } from "@medusajs/types"
import NavClient from "./nav-client"

export default async function Nav() {
  const regions = await listRegions().then((regions: StoreRegion[]) => regions)

  return <NavClient regions={regions} />
}
