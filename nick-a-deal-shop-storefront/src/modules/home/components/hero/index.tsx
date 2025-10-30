import LocalizedClientLink from "@modules/common/components/localized-client-link"
import WobbleCardDemo from "@/components/wobble-card-demo"

const Hero = () => {
  return (
    <section className="relative w-full border-b border-border mb-8 md:mb-12 overflow-hidden">
      {/* Arrow-streak background pattern */}
      <div className="absolute inset-0 z-0 bg-[color:var(--accent-50)] hero-bg">
        {/* Arrow streak decorative elements */}
        <div className="absolute top-20 right-10 w-32 h-1 bg-gradient-to-r from-transparent via-[color:var(--accent-500)] to-transparent opacity-30 rotate-45" />
        <div className="absolute top-40 right-32 w-24 h-1 bg-gradient-to-r from-transparent via-[color:var(--accent-500)] to-transparent opacity-20 rotate-12" />
        <div className="absolute bottom-32 left-20 w-40 h-1 bg-gradient-to-r from-transparent via-[color:var(--accent-500)] to-transparent opacity-25 -rotate-12" />
        <div className="absolute bottom-20 left-40 w-28 h-1 bg-gradient-to-r from-transparent via-[color:var(--accent-500)] to-transparent opacity-20 rotate-45" />
        {/* Darken background subtly in dark theme */}
        <div className="hero-dark-overlay absolute inset-0 bg-black/40 [mask-image:radial-gradient(130%_85%_at_50%_0%,_black,_transparent_70%)]" />
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
