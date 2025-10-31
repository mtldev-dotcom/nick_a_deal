import Image from "next/image"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import WobbleCardDemo from "@/components/wobble-card-demo"

const Hero = () => {
  return (
    <section className="relative w-full border-b border-border mb-8 md:mb-12 overflow-hidden">
      {/* Background images - theme-aware, full screen, fixed position */}
      <div className="fixed top-0 left-0 w-screen h-screen z-0">
        {/* Light mode background */}
        <Image
          src="/bg-streak-light-mode.png"
          alt="Background streaks"
          fill
          className="object-cover hero-bg-light"
          priority
          quality={90}
        />
        {/* Dark mode background */}
        <Image
          src="/bg-streak-dark-mode.png"
          alt="Background streaks"
          fill
          className="object-cover hero-bg-dark"
          priority
          quality={90}
        />
      </div>
      {/* Background overlay for dark theme support - minimal overlay to show bg image */}
      <div className="absolute inset-0 z-[1] pointer-events-none">
        {/* Subtle overlay for dark theme only */}
        <div className="hero-dark-overlay absolute inset-0 bg-black/20 [mask-image:radial-gradient(130%_85%_at_50%_0%,_black,_transparent_70%)]" />
      </div>

      {/* Content */}
      <div className="relative z-10 px-6 small:px-8 py-6 md:py-8">
        <div className="w-full">
          <WobbleCardDemo />
        </div>
      </div>
    </section>
  )
}

export default Hero
