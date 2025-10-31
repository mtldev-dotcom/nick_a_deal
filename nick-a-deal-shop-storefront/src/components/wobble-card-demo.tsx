"use client";

import React from "react";
import { WobbleCard } from "@/components/ui/wobble-card";
import LocalizedClientLink from "@modules/common/components/localized-client-link";

export default function WobbleCardDemo() {
  return (
    <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 max-w-7xl mx-auto w-full my-4 md:my-6">
      {/* Tile A - Green (top-left) */}
      <WobbleCard
        containerClassName="col-span-1 lg:col-span-2 h-full bg-bright-green min-h-[500px] lg:min-h-[300px]"
        className=""
      >
        <div className="max-w-xs relative z-10">
          <h2 className="text-left text-balance text-3xl md:text-3xl lg:text-4xl xl:text-5xl font-semibold tracking-[-0.015em] text-white">
            Deals hand-picked by Nick and his team
          </h2>
          <p className="mt-4 text-left text-base/6 text-secondary-foreground">
            If Nick and his team approved it, it's a deal — carefully curated picks
            bringing you the best value with no fluff, just great prices on quality items.
          </p>
          <LocalizedClientLink
            href="/store"
            className="mt-6 inline-flex items-center gap-2 rounded-xl px-5 py-3 bg-white text-gray-900 font-semibold hover:opacity-90 transition-opacity shadow-lg relative z-10"
          >
            Shop today's picks
          </LocalizedClientLink>
        </div>
        <img
          src="/green-block.png"
          width={500}
          height={500}
          alt="Collage of curated products selected by Nick and his team."
          className="absolute -right-4 lg:-right-[20%] top-20 object-contain rounded-2xl z-0 opacity-30 md:opacity-100 transition-all duration-300 ease-out hover:scale-110 hover:shadow-[0_8px_32px_rgba(28,200,156,0.5)]"
        />
      </WobbleCard>

      {/* Tile B - Yellow (top-right) */}
      <WobbleCard containerClassName="col-span-1 min-h-[300px] bg-bright-yellow relative">
        <img
          src="/yellow-block.png"
          width={300}
          height={300}
          alt="Today's best price found by Nick and his team."
          className="absolute right-2 top-40 object-contain rounded-2xl z-0 opacity-20 sm:opacity-50 transition-all duration-300 ease-out hover:scale-110 hover:shadow-[0_8px_32px_rgba(254,195,1,0.5)]"
        />
        <div className="flex flex-col h-full justify-between relative z-10">
          <div>
            <h2 className="max-w-80 text-left text-balance text-3xl md:text-3xl lg:text-4xl xl:text-5xl font-semibold tracking-[-0.015em] text-white">
              Best price today.
            </h2>
            <p className="mt-4 max-w-[26rem] text-left text-base/6 text-secondary-foreground">
              Nick and his team hunt for today's top deal so you don't have to. When you
              see it here, you know it's worth your time and money.
            </p>
            {/* Dynamic Line (placeholder for future integration) */}
            <div className="mt-4 p-3 bg-white/10 rounded-lg backdrop-blur-sm">
              <p className="text-sm font-medium text-black">
                {/* {{deal_title}} — {{deal_price}} (was {{deal_was_price}}) */}
                Today's featured deal coming soon
              </p>
            </div>
            {/* Micro trust line */}
            <p className="mt-3 text-xs text-black flex items-center gap-2">
              <span className="inline-block w-1.5 h-1.5 bg-green-400 rounded-full"></span>
              Verified deal • Limited time
            </p>
          </div>
          <LocalizedClientLink
            href="/store"
            className="mt-6 inline-flex items-center gap-2 rounded-xl px-4 py-2.5 bg-white text-gray-900 font-semibold hover:opacity-90 transition-opacity shadow-lg text-sm w-full justify-center"
          >
            View this deal
          </LocalizedClientLink>
        </div>
      </WobbleCard>

      {/* Tile C - Blue (bottom-full) */}
      <WobbleCard containerClassName="col-span-1 lg:col-span-3 bg-bright-blue min-h-[500px] lg:min-h-[600px] xl:min-h-[300px]">
        <div className="max-w-sm relative z-10">
          <h2 className="max-w-sm md:max-w-lg text-left text-balance text-3xl md:text-3xl lg:text-4xl xl:text-5xl font-semibold tracking-[-0.015em] text-white">
            Shop today's picks
          </h2>
          <p className="mt-4 max-w-[26rem] text-left text-base/6 text-secondary-foreground">
            Discover hand-selected deals from Nick and his team, updated daily — from
            electronics to home goods, always trustworthy and on sale.
          </p>
          <LocalizedClientLink
            href="/store"
            className="mt-6 inline-flex items-center gap-2 rounded-xl px-5 py-3 bg-white text-gray-900 font-semibold hover:opacity-90 transition-opacity shadow-lg relative z-10"
          >
            Browse all categories
          </LocalizedClientLink>
        </div>
        <img
          src="/blue-block.png"
          width={500}
          height={500}
          alt="Browse today's picks from Nick and his team."
          className="absolute -right-5 md:-right-[20%] lg:-right-[10%] top-10 object-contain rounded-2xl z-0 opacity-30 md:opacity-100 transition-all duration-300 ease-out hover:scale-110 hover:shadow-[0_8px_32px_rgba(1,173,248,0.5)]"
        />
      </WobbleCard>
    </div>
  );
}


