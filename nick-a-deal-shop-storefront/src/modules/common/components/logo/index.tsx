import Image from "next/image"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

type LogoProps = {
  /**
   * Variant of logo to display
   * - "logo": Full horizontal logo (for header) - uses logo-horizontal.png
   * - "icon": Icon only (for footer) - uses icon-logo.png
   */
  variant?: "logo" | "icon"
}

/**
 * Logo component with arrow hover animation
 * Uses transparent PNG files that work in both light and dark modes
 * Supports both full logo and icon variants
 * Uses brand gradient for hover effect
 */
export default function Logo({ variant = "logo" }: LogoProps) {
  // Determine image source and dimensions based on variant
  const isIcon = variant === "icon"
  const imageSrc = isIcon ? "/icon-logo.png" : "/blue-logo-horizontal.png"
  const altText = isIcon ? "Nick a Deal Icon" : "Nick a Deal Logo"

  // Size props based on variant
  const dimensions = isIcon
    ? {
      width: 64,
      height: 64,
      containerClass: "relative w-16 h-16",
    }
    : {
      width: 160,
      height: 48,
      containerClass: "relative w-32 h-10 sm:w-40 sm:h-12",
    }

  return (
    <LocalizedClientLink
      href="/"
      className="flex items-center group"
      aria-label="Nick a Deal - Home"
    >
      <div
        className={`${dimensions.containerClass} transition-transform duration-150 ease-out group-hover:animate-arrow-move`}
      >
        <Image
          src={imageSrc}
          alt={altText}
          width={dimensions.width}
          height={dimensions.height}
          priority
          className="object-contain w-full h-full"
        />
      </div>
    </LocalizedClientLink>
  )
}

