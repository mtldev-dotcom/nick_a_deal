"use client"

import { Button } from "@medusajs/ui"
import React from "react"
import { useFormStatus } from "react-dom"

export function SubmitButton({
  children,
  variant = "primary",
  className,
  "data-testid": dataTestId,
}: {
  children: React.ReactNode
  variant?: "primary" | "secondary" | "transparent" | "danger" | null
  className?: string
  "data-testid"?: string
}) {
  const { pending } = useFormStatus()

  const borderClass = variant === "primary" ? "btn-animated-border-primary" : 
                     variant === "secondary" ? "btn-animated-border-secondary" : "";
  
  return (
    <Button
      size="large"
      className={`${borderClass ? `btn-animated-border ${borderClass}` : ""} ${className || ""}`}
      type="submit"
      isLoading={pending}
      variant={variant || "primary"}
      data-testid={dataTestId}
    >
      {children}
    </Button>
  )
}
