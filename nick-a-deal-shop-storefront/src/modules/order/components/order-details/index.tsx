import { HttpTypes } from "@medusajs/types"
import { Text } from "@medusajs/ui"

type OrderDetailsProps = {
  order: HttpTypes.StoreOrder
  showStatus?: boolean
}

const OrderDetails = ({ order, showStatus }: OrderDetailsProps) => {
  const formatStatus = (str: string) => {
    const formatted = str.split("_").join(" ")

    return formatted.slice(0, 1).toUpperCase() + formatted.slice(1)
  }

  return (
    <div>
      <Text className="text-foreground">
        We have sent the order confirmation details to{" "}
        <span
          className="text-primary font-semibold"
          data-testid="order-email"
        >
          {order.email}
        </span>
        .
      </Text>
      <Text className="mt-2 text-foreground">
        Order date:{" "}
        <span className="text-muted-foreground" data-testid="order-date">
          {new Date(order.created_at).toDateString()}
        </span>
      </Text>
      <Text className="mt-2 text-primary font-medium">
        Order number: <span data-testid="order-id">{order.display_id}</span>
      </Text>

      <div className="flex items-center text-sm gap-x-4 mt-4">
        {showStatus && (
          <>
            <Text className="text-foreground">
              Order status:{" "}
              <span className="text-muted-foreground" data-testid="order-status">
                {formatStatus(order.fulfillment_status)}
              </span>
            </Text>
            <Text className="text-foreground">
              Payment status:{" "}
              <span
                className="text-muted-foreground"
                data-testid="order-payment-status"
              >
                {formatStatus(order.payment_status)}
              </span>
            </Text>
          </>
        )}
      </div>
    </div>
  )
}

export default OrderDetails
