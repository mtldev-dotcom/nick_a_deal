import { Heading, Text } from "@medusajs/ui"

import InteractiveLink from "@modules/common/components/interactive-link"

const EmptyCartMessage = () => {
  return (
    <div className="py-24 px-2 flex flex-col justify-center items-center text-center" data-testid="empty-cart-message">
      <div className="bg-muted text-foreground flex items-center justify-center w-20 h-20 rounded-full mb-6 font-semibold text-2xl">
        <span>0</span>
      </div>
      <Heading
        level="h1"
        className="text-4xl font-semibold text-foreground mb-4"
      >
        Cart
      </Heading>
      <Text className="text-base text-muted-foreground mb-8 max-w-md">
        You don&apos;t have anything in your cart. Let&apos;s change that, use
        the link below to start browsing our products.
      </Text>
      <div>
        <InteractiveLink href="/store">Explore products</InteractiveLink>
      </div>
    </div>
  )
}

export default EmptyCartMessage
