"use client"

import { Moon, Sun } from "@medusajs/icons"
import { useEffect, useState } from "react"
import { useTheme } from "next-themes"

/**
 * Theme toggle button component for switching between light/dark mode
 */
export default function ThemeToggle() {
  const [mounted, setMounted] = useState(false)
  const { theme, setTheme } = useTheme()

  // Avoid hydration mismatch
  useEffect(() => {
    setMounted(true)
  }, [])

  if (!mounted) {
    return (
      <button
        className="relative flex items-center justify-center border border-border bg-card rounded-lg h-10 w-10 hover:bg-background/50 transition-colors m-0"
        aria-label="Toggle theme"
      >
        <div className="w-5 h-5" />
      </button>
    )
  }

  return (
    <button
      onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
      className="relative flex items-center justify-center border border-border bg-card rounded-lg h-10 w-10 hover:bg-background/50 transition-colors duration-150 m-0"
      aria-label={`Switch to ${theme === "dark" ? "light" : "dark"} mode`}
    >
      {theme === "dark" ? (
        <Sun className="w-5 h-5 text-foreground" />
      ) : (
        <Moon className="w-5 h-5 text-foreground" />
      )}
    </button>
  )
}

