"use client"

import { HttpTypes } from "@medusajs/types"
import { Container } from "@medusajs/ui"
import Image from "next/image"
import { useState, useEffect, useRef, useCallback } from "react"
import { cn } from "@lib/util/cn"

type ImageGalleryProps = {
  images: HttpTypes.StoreProductImage[]
}

const ImageGallery = ({ images }: ImageGalleryProps) => {
  const [currentIndex, setCurrentIndex] = useState(0)
  const [touchStart, setTouchStart] = useState<number | null>(null)
  const [touchEnd, setTouchEnd] = useState<number | null>(null)
  const [isTransitioning, setIsTransitioning] = useState(false)
  const sliderRef = useRef<HTMLDivElement>(null)

  // Minimum swipe distance (in px)
  const minSwipeDistance = 50

  const goToSlide = useCallback((index: number) => {
    if (isTransitioning) return
    // Allow wrapping around for infinite loop
    const validIndex = ((index % images.length) + images.length) % images.length
    setIsTransitioning(true)
    setCurrentIndex(validIndex)
    setTimeout(() => setIsTransitioning(false), 300)
  }, [images.length, isTransitioning])

  const goToNext = useCallback(() => {
    const nextIndex = currentIndex < images.length - 1 ? currentIndex + 1 : 0
    goToSlide(nextIndex)
  }, [currentIndex, images.length, goToSlide])

  const goToPrevious = useCallback(() => {
    const prevIndex = currentIndex > 0 ? currentIndex - 1 : images.length - 1
    goToSlide(prevIndex)
  }, [currentIndex, images.length, goToSlide])

  // Touch handlers for swipe
  const onTouchStart = (e: React.TouchEvent<HTMLDivElement>) => {
    setTouchEnd(null)
    setTouchStart(e.targetTouches[0].clientX)
  }

  const onTouchMove = (e: React.TouchEvent<HTMLDivElement>) => {
    setTouchEnd(e.targetTouches[0].clientX)
  }

  const onTouchEnd = () => {
    if (!touchStart || !touchEnd) return
    const distance = touchStart - touchEnd
    const isLeftSwipe = distance > minSwipeDistance
    const isRightSwipe = distance < -minSwipeDistance

    if (isLeftSwipe) {
      goToNext()
    }
    if (isRightSwipe) {
      goToPrevious()
    }
  }

  // Keyboard navigation
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "ArrowLeft") {
        e.preventDefault()
        goToPrevious()
      }
      if (e.key === "ArrowRight") {
        e.preventDefault()
        goToNext()
      }
    }

    // Only add listener if there are multiple images
    if (images.length > 1) {
      window.addEventListener("keydown", handleKeyDown)
      return () => window.removeEventListener("keydown", handleKeyDown)
    }
  }, [goToPrevious, goToNext, images.length])

  if (!images || images.length === 0) {
    return null
  }

  return (
    <div className="relative w-full max-w-lg mx-auto group">
      {/* Main Slider Container */}
      <div
        ref={sliderRef}
        className="relative overflow-hidden rounded-xl bg-card"
        onTouchStart={onTouchStart}
        onTouchMove={onTouchMove}
        onTouchEnd={onTouchEnd}
      >
        {/* Images Container */}
        <div
          className="flex transition-transform duration-300 ease-out"
          style={{
            transform: `translateX(-${currentIndex * 100}%)`,
          }}
        >
          {images.map((image, index) => (
            <div
              key={image.id}
              className="relative w-full flex-shrink-0 aspect-square sm:aspect-[3/4]"
            >
              <Container className="relative w-full h-full overflow-hidden bg-muted">
                {!!image.url && (
                  <Image
                    src={image.url}
                    priority={index <= 1}
                    className="object-contain"
                    alt={`Product image ${index + 1}`}
                    fill
                    sizes="(max-width: 576px) 100vw, (max-width: 768px) 400px, 500px"
                  />
                )}
              </Container>
            </div>
          ))}
        </div>

        {/* Navigation Arrows */}
        {images.length > 1 && (
          <>
            {/* Left Arrow */}
            <button
              onClick={goToPrevious}
              className={cn(
                "absolute left-2 sm:left-4 top-1/2 -translate-y-1/2 z-10",
                "w-8 h-8 sm:w-10 sm:h-10 rounded-full",
                "bg-background dark:bg-card backdrop-blur-md border-2 border-border",
                "flex items-center justify-center shadow-xl",
                "text-foreground hover:text-primary hover:border-primary",
                "transition-all duration-200",
                "opacity-100 hover:opacity-100 cursor-pointer",
                "!opacity-100" // Force always visible
              )}
              aria-label="Previous image"
            >
              <svg
                className="w-4 h-4 sm:w-5 sm:h-5"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
                strokeWidth={2.5}
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M15 19l-7-7 7-7"
                />
              </svg>
            </button>

            {/* Right Arrow */}
            <button
              onClick={goToNext}
              className={cn(
                "absolute right-2 sm:right-4 top-1/2 -translate-y-1/2 z-10",
                "w-8 h-8 sm:w-10 sm:h-10 rounded-full",
                "bg-background dark:bg-card backdrop-blur-md border-2 border-border",
                "flex items-center justify-center shadow-xl",
                "text-foreground hover:text-primary hover:border-primary",
                "transition-all duration-200",
                "opacity-100 hover:opacity-100 cursor-pointer",
                "!opacity-100" // Force always visible
              )}
              aria-label="Next image"
            >
              <svg
                className="w-4 h-4 sm:w-5 sm:h-5"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
                strokeWidth={2.5}
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M9 5l7 7-7 7"
                />
              </svg>
            </button>
          </>
        )}
      </div>

      {/* Dot Indicators */}
      {images.length > 1 && (
        <div className="flex justify-center gap-2 mt-4">
          {images.map((_, index) => (
            <button
              key={index}
              onClick={() => goToSlide(index)}
              className={cn(
                "w-2 h-2 rounded-full transition-all duration-200",
                {
                  "bg-primary w-8": index === currentIndex,
                  "bg-muted-foreground/30 hover:bg-muted-foreground/50": index !== currentIndex,
                }
              )}
              aria-label={`Go to image ${index + 1}`}
            />
          ))}
        </div>
      )}
    </div>
  )
}

export default ImageGallery
