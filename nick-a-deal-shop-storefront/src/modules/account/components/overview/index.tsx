import { Container } from "@medusajs/ui"

import ChevronDown from "@modules/common/icons/chevron-down"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import { convertToLocale } from "@lib/util/money"
import { HttpTypes } from "@medusajs/types"

type OverviewProps = {
  customer: HttpTypes.StoreCustomer | null
  orders: HttpTypes.StoreOrder[] | null
}

const Overview = ({ customer, orders }: OverviewProps) => {
  return (
    <div data-testid="overview-page-wrapper">
      <div className="hidden small:block">
        <div className="text-xl font-semibold flex justify-between items-center mb-4 text-foreground">
          <span data-testid="welcome-message" data-value={customer?.first_name}>
            Hello {customer?.first_name}
          </span>
          <span className="text-sm text-muted-foreground">
            Signed in as:{" "}
            <span
              className="font-semibold text-foreground"
              data-testid="customer-email"
              data-value={customer?.email}
            >
              {customer?.email}
            </span>
          </span>
        </div>
        <div className="flex flex-col py-8 border-t border-border">
          <div className="flex flex-col gap-y-4 h-full col-span-1 row-span-2 flex-1">
            <div className="flex items-start gap-x-16 mb-6">
              <div className="flex flex-col gap-y-4">
                <h3 className="text-lg font-semibold text-foreground">Profile</h3>
                <div className="flex items-end gap-x-2">
                  <span
                    className="text-3xl font-semibold leading-none text-foreground"
                    data-testid="customer-profile-completion"
                    data-value={getProfileCompletion(customer)}
                  >
                    {getProfileCompletion(customer)}%
                  </span>
                  <span className="uppercase text-sm text-muted-foreground">
                    Completed
                  </span>
                </div>
              </div>

              <div className="flex flex-col gap-y-4">
                <h3 className="text-lg font-semibold text-foreground">Addresses</h3>
                <div className="flex items-end gap-x-2">
                  <span
                    className="text-3xl font-semibold leading-none text-foreground"
                    data-testid="addresses-count"
                    data-value={customer?.addresses?.length || 0}
                  >
                    {customer?.addresses?.length || 0}
                  </span>
                  <span className="uppercase text-sm text-muted-foreground">
                    Saved
                  </span>
                </div>
              </div>
            </div>

            <div className="flex flex-col gap-y-4">
              <div className="flex items-center gap-x-2">
                <h3 className="text-lg font-semibold text-foreground">Recent orders</h3>
              </div>
              <ul
                className="flex flex-col gap-y-4"
                data-testid="orders-wrapper"
              >
                {orders && orders.length > 0 ? (
                  orders.slice(0, 5).map((order) => {
                    return (
                      <li
                        key={order.id}
                        data-testid="order-wrapper"
                        data-value={order.id}
                      >
                        <LocalizedClientLink
                          href={`/account/orders/details/${order.id}`}
                        >
                          <Container className="bg-card border border-border rounded-lg flex justify-between items-center p-4">
                            <div className="grid grid-cols-3 grid-rows-2 text-sm gap-x-4 flex-1">
                              <span className="font-semibold text-foreground">Date placed</span>
                              <span className="font-semibold text-foreground">
                                Order number
                              </span>
                              <span className="font-semibold text-foreground">
                                Total amount
                              </span>
                              <span data-testid="order-created-date" className="text-muted-foreground">
                                {new Date(order.created_at).toDateString()}
                              </span>
                              <span
                                data-testid="order-id"
                                data-value={order.display_id}
                                className="text-muted-foreground"
                              >
                                #{order.display_id}
                              </span>
                              <span data-testid="order-amount" className="text-muted-foreground">
                                {convertToLocale({
                                  amount: order.total,
                                  currency_code: order.currency_code,
                                })}
                              </span>
                            </div>
                            <button
                              className="flex items-center justify-between text-muted-foreground hover:text-foreground transition-colors"
                              data-testid="open-order-button"
                            >
                              <span className="sr-only">
                                Go to order #{order.display_id}
                              </span>
                              <ChevronDown className="-rotate-90" />
                            </button>
                          </Container>
                        </LocalizedClientLink>
                      </li>
                    )
                  })
                ) : (
                  <span data-testid="no-orders-message" className="text-muted-foreground">No recent orders</span>
                )}
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

const getProfileCompletion = (customer: HttpTypes.StoreCustomer | null) => {
  let count = 0

  if (!customer) {
    return 0
  }

  if (customer.email) {
    count++
  }

  if (customer.first_name && customer.last_name) {
    count++
  }

  if (customer.phone) {
    count++
  }

  const billingAddress = customer.addresses?.find(
    (addr) => addr.is_default_billing
  )

  if (billingAddress) {
    count++
  }

  return (count / 4) * 100
}

export default Overview
