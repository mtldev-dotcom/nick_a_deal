import Image from "next/image"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

/**
 * Logo component with arrow hover animation
 * Uses brand gradient for hover effect
 */
export default function Logo() {
  return (
    <LocalizedClientLink
      href="/"
      className="flex items-center group"
      aria-label="Nick a Deal - Home"
    >
      <div className="relative w-32 h-10 sm:w-40 sm:h-12 transition-transform duration-150 ease-out group-hover:animate-arrow-move">
        <Image
          src="/nick_a_deal_logo.png"
          alt="Nick a Deal Logo"
          width={160}
          height={48}
          priority
          className="object-contain w-full h-full"
        />
      </div>
    </LocalizedClientLink>
  )
}

