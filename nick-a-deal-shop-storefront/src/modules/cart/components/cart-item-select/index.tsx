"use client"

import { IconBadge, clx } from "@medusajs/ui"
import {
  SelectHTMLAttributes,
  forwardRef,
  useEffect,
  useImperativeHandle,
  useRef,
  useState,
} from "react"

import ChevronDown from "@modules/common/icons/chevron-down"

type NativeSelectProps = {
  placeholder?: string
  errors?: Record<string, unknown>
  touched?: Record<string, unknown>
} & Omit<SelectHTMLAttributes<HTMLSelectElement>, "size">

const CartItemSelect = forwardRef<HTMLSelectElement, NativeSelectProps>(
  ({ placeholder = "Select...", className, children, ...props }, ref) => {
    const innerRef = useRef<HTMLSelectElement>(null)
    const [isPlaceholder, setIsPlaceholder] = useState(false)

    useImperativeHandle<HTMLSelectElement | null, HTMLSelectElement | null>(
      ref,
      () => innerRef.current
    )

    useEffect(() => {
      if (innerRef.current && innerRef.current.value === "") {
        setIsPlaceholder(true)
      } else {
        setIsPlaceholder(false)
      }
    }, [innerRef.current?.value])

    return (
      <div>
        <IconBadge
          onFocus={() => innerRef.current?.focus()}
          onBlur={() => innerRef.current?.blur()}
          className={clx(
            "relative flex items-center text-sm border border-border bg-card text-foreground rounded-lg group transition-colors hover:border-primary focus-within:border-primary focus-within:ring-2 focus-within:ring-primary/20",
            className,
            {
              "text-muted-foreground": isPlaceholder,
            }
          )}
        >
          <select
            ref={innerRef}
            {...props}
            className="appearance-none bg-transparent border-none px-3 transition-colors duration-150 outline-none w-full h-full items-center justify-center text-sm font-medium cursor-pointer"
          >
            <option disabled value="">
              {placeholder}
            </option>
            {children}
          </select>
          <span className="absolute flex pointer-events-none justify-end right-3 w-5 text-muted-foreground group-hover:text-foreground transition-colors">
            <ChevronDown />
          </span>
        </IconBadge>
      </div>
    )
  }
)

CartItemSelect.displayName = "CartItemSelect"

export default CartItemSelect
