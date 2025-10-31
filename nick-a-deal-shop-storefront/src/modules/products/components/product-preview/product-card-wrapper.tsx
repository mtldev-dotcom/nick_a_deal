"use client"

import { useRef, useState, type ReactNode } from "react"

type ProductCardWrapperProps = {
  children: ReactNode
}

/**
 * Client component wrapper that adds cursor-following shadow effect to product cards
 */
export default function ProductCardWrapper({ children }: ProductCardWrapperProps) {
  const cardRef = useRef<HTMLDivElement>(null)
  const [shadowOffset, setShadowOffset] = useState({ x: 0, y: 0 })

  const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
    if (!cardRef.current) return

    const rect = cardRef.current.getBoundingClientRect()
    // Calculate position relative to card center (-1 to 1 range)
    const x = ((e.clientX - rect.left) / rect.width - 0.5) * 2
    const y = ((e.clientY - rect.top) / rect.height - 0.5) * 2

    // Minimal offset - scale down to keep it subtle
    setShadowOffset({ 
      x: x * 8, // Max 8px offset
      y: y * 8 
    })
  }

  const handleMouseLeave = () => {
    // Reset shadow position when mouse leaves
    setShadowOffset({ x: 0, y: 0 })
  }

  return (
    <div
      ref={cardRef}
      onMouseMove={handleMouseMove}
      onMouseLeave={handleMouseLeave}
      className="product-card-wrapper h-full"
    >
      <div
        style={
          {
            '--shadow-offset-x': `${shadowOffset.x}px`,
            '--shadow-offset-y': `${shadowOffset.y}px`,
          } as React.CSSProperties & { '--shadow-offset-x': string; '--shadow-offset-y': string }
        }
        className="h-full product-card-shadow"
      >
        {children}
      </div>
    </div>
  )
}

