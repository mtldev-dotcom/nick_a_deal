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
        "px-2 py-1 rounded-md text-xs font-semibold transition-colors",
        // Light theme
        "bg-[color:var(--cloud-100)] text-[color:var(--brand-700)]",
        // Dark theme
        "dark:bg-[#1A1B20] dark:text-[color:var(--accent-100)]",
        className
      )}
    >
      {text}
    </span>
  )
}

