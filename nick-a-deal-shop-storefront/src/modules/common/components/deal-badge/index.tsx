import { cn } from "@lib/util/cn"

type DealBadgeProps = {
  variant?: "approved" | "today"
  className?: string
}

/**
 * DealBadge component for "Nick Approved" and "Today's Deal" badges
 * Supports light/dark theme per brand design guide
 */
export default function DealBadge({
  variant = "approved",
  className,
}: DealBadgeProps) {
  const text = variant === "approved" ? "Nick Approved" : "Today's Deal"

  return (
    <span
      className={cn(
        // Enhanced styling with better visual appeal
        "px-3 py-1.5 rounded-full text-xs font-bold tracking-wide uppercase",
        "shadow-lg backdrop-blur-sm",
        "transition-all duration-300",
        "group-hover:scale-110 group-hover:shadow-xl",
        // Light theme - enhanced colors
        "bg-gradient-to-r from-[color:var(--cloud-100)] to-[color:var(--brand-50)]",
        "text-[color:var(--brand-700)]",
        "border border-[color:var(--brand-500)]/20",
        // Dark theme - enhanced colors
        "dark:bg-gradient-to-r dark:from-[#1A1B20] dark:to-[#2A1B30]",
        "dark:text-[color:var(--accent-100)]",
        "dark:border-[color:var(--accent-500)]/30",
        className
      )}
    >
      {text}
    </span>
  )
}

