import LocalizedClientLink from "@modules/common/components/localized-client-link"

const Hero = () => {
  return (
    <div className="relative h-[70vh] w-full border-b border-border overflow-hidden">
      {/* Arrow-streak background pattern */}
      <div className="absolute inset-0 z-0 bg-[color:var(--accent-50)] dark:bg-[#11131A]">
        {/* Arrow streak decorative elements */}
        <div className="absolute top-20 right-10 w-32 h-1 bg-gradient-to-r from-transparent via-[color:var(--accent-500)] to-transparent opacity-30 rotate-45" />
        <div className="absolute top-40 right-32 w-24 h-1 bg-gradient-to-r from-transparent via-[color:var(--accent-500)] to-transparent opacity-20 rotate-12" />
        <div className="absolute bottom-32 left-20 w-40 h-1 bg-gradient-to-r from-transparent via-[color:var(--accent-500)] to-transparent opacity-25 -rotate-12" />
        <div className="absolute bottom-20 left-40 w-28 h-1 bg-gradient-to-r from-transparent via-[color:var(--accent-500)] to-transparent opacity-20 rotate-45" />
      </div>

      {/* Content */}
      <div className="absolute inset-0 z-10 flex flex-col justify-center items-center text-center px-6 small:p-32 gap-8">
        <div className="flex flex-col gap-4 max-w-2xl">
          <h1 className="text-4xl sm:text-5xl md:text-6xl leading-tight font-semibold text-foreground">
            Deals hand-picked by Nick.
          </h1>
          <p className="text-lg sm:text-xl text-muted-foreground">
            If Nick approved it, it's a deal.
          </p>
        </div>

        {/* CTA Buttons */}
        <div className="flex flex-col sm:flex-row items-center gap-4 mt-4">
          <LocalizedClientLink href="/store">
            <button className="btn-animated-border btn-animated-border-primary inline-flex items-center gap-2 rounded-xl px-6 py-3 bg-foreground dark:bg-[#0A0A0B] text-background dark:text-foreground shadow-lg hover:opacity-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[color:var(--ring)] transition-all duration-150 font-medium">
              Shop Today's Picks
            </button>
          </LocalizedClientLink>
          <LocalizedClientLink href="/about">
            <button className="btn-animated-border btn-animated-border-secondary inline-flex items-center gap-2 rounded-xl px-6 py-3 bg-foreground dark:bg-[#0A0A0B] text-background dark:text-foreground shadow-lg hover:opacity-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[color:var(--ring)] transition-all duration-150 font-medium">
              How We Pick Deals
            </button>
          </LocalizedClientLink>
        </div>
      </div>
    </div>
  )
}

export default Hero
