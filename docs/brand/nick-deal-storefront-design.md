# Nick a Deal · Brand Style Guide (Next.js + Medusa + Shadcn)

## Brand idea

A curated deal shop: “If Nick approved it, it’s a deal.” Visuals should feel **clean, fast, trustworthy**—with sharp arrows/motion lines (from the logo) and high-contrast cards that spotlight the discount.

---

## Color system (from logo)

**Core hex values**

* **Magenta** (Primary): `#B4228E`
* **Deep Purple** (Primary-700): `#572383`
* **Cyan** (Accent): `#2BB8EB`
* **Royal Blue** (Accent-700): `#0B82CB`
* **Cloud** (Neutral-100): `#E6E7F4`
* **Lavender Mist** (Neutral-200): `#B393C9`
* **True White**: `#FFFFFF`
* **Ink** (Near-black): `#0A0A0B`

**Gradients**

* **Cart Gradient (brand)**: `linear-gradient(135deg, #B4228E 0%, #572383 100%)`
* **Arrow Gradient (motion)**: `linear-gradient(135deg, #2BB8EB 0%, #0B82CB 100%)`

**Usage**

* Primary CTAs, price highlights: **Magenta**
* Links, “View deal”, progress/motion: **Cyan → Royal Blue**
* Surfaces: **Cloud/White** (light), **Ink** (dark)
* Badges & subtle dividers: **Lavender Mist**

---

## Light/Dark theme tokens (CSS variables)

Add to `src/app/(app)/globals.css`:

```css
:root {
  /* Base */
  --background: #FFFFFF;
  --foreground: #0A0A0B;

  /* Brand */
  --brand-50:  #F7E8F3;
  --brand-100: #EFD1E9;
  --brand-500: #B4228E; /* primary */
  --brand-700: #572383;

  --accent-50:  #E9F7FE;
  --accent-100: #D2EFFC;
  --accent-500: #2BB8EB; /* accent */
  --accent-700: #0B82CB;

  /* Neutrals */
  --cloud-100: #E6E7F4;
  --lavender-200: #B393C9;
  --muted: #6B7280; /* text secondary */

  /* UI */
  --card: #FFFFFF;
  --card-foreground: #0A0A0B;
  --border: rgba(10,10,11,0.08);
  --ring: var(--accent-500);

  /* Shadcn tokens */
  --primary: var(--brand-500);
  --primary-foreground: #FFFFFF;
  --secondary: var(--accent-500);
  --secondary-foreground: #0A0A0B;
  --muted-foreground: var(--muted);
  --destructive: #DC2626;
  --destructive-foreground: #FFFFFF;

  /* Effects */
  --glow-magenta: 0 8px 24px rgba(180,34,142,0.28);
  --glow-cyan:    0 8px 24px rgba(43,184,235,0.28);
}

[data-theme="dark"] {
  --background: #0A0A0B;
  --foreground: #F8FAFC;

  --card: #101114;
  --card-foreground: #F8FAFC;
  --border: rgba(255,255,255,0.08);

  /* Increase saturation a touch in dark */
  --primary: #C02A97;
  --secondary: #33BFF0;

  --ring: var(--secondary);
}
```

**Tailwind hook (optional, but nice):**
In `tailwind.config.ts` add CSS-var colors:

```ts
extend: {
  colors: {
    background: "var(--background)",
    foreground: "var(--foreground)",
    primary: { DEFAULT: "var(--primary)", foreground: "var(--primary-foreground)" },
    secondary:{ DEFAULT: "var(--secondary)", foreground: "var(--secondary-foreground)" },
    card: { DEFAULT: "var(--card)", foreground: "var(--card-foreground)" },
    border: "var(--border)",
  },
  boxShadow: {
    "glow-magenta": "var(--glow-magenta)",
    "glow-cyan": "var(--glow-cyan)"
  }
}
```

---

## Shadcn UI theming (map to tokens)

* **Button (primary)**: `bg-primary text-primary-foreground shadow-glow-magenta hover:opacity-95`
* **Button (secondary/link)**: `bg-secondary text-secondary-foreground shadow-glow-cyan hover:opacity-95`
* **Card**: `bg-card text-card-foreground border border-border rounded-2xl`
* **Badge “Nick Approved”**: `bg-[color:var(--cloud-100)] text-[color:var(--brand-700)] dark:bg-[#1A1B20] dark:text-[color:var(--accent-100)]`
* **Input/Select**: focus `ring-2 ring-[color:var(--ring)]`

---

## Components & patterns

**Header**

* Left: logo (small arrow animation on hover, using the arrow gradient)
* Center: search (pill, subtle border)
* Right: account / cart
* Sticky with 1px `border-border`, background `backdrop-blur` on scroll.

**Hero (Home)**

* Short, punchy value prop: “Deals hand-picked by Nick.”
* CTA pair: **Primary** “Shop Today’s Picks”, **Secondary** “How We Pick Deals”
* Subtle arrow-streak background using `--accent-50` shapes in light and `#11131A` in dark.

**Product card**

* Image on neutral surface, 16px radius.
* Price row:

  * **Sale price**: `text-[color:var(--brand-700)] dark:text-[color:var(--primary)]`
  * **Compare-at**: `line-through text-muted-foreground`
* **Deal badge** (top-left): “Nick Approved” or “Today’s Deal”

  * Light: `bg-cloud-100 text-brand-700`
  * Dark: `bg-[#1A1B20] text-accent-100`
* Hover: lift + `shadow-glow-cyan`.

**Deal meter (optional micro-component)**

* Thin progress bar in arrow gradient showing discount %.
* Label: “Great / Good / Okay” thresholds.

**PDP (Product page)**

* Trust block: “Why Nick picked this” (3 bullets)
* “Is this the best price?” mini note with last-seen price (if you track).
* Prominent **Add to cart** (primary), **Save deal** (secondary).

---

## Motion & icons

* Use **arrow streaks**/chevrons to imply speed/savings (echo the logo).
* Micro-interactions: hover glow on CTAs, 120–160ms ease-out.
* Keep icons simple/solid; avoid stock skeuomorphic badges.

---

## Accessibility

* Minimum text contrast: 4.5:1 (use `--brand-700` for magenta text on light).
* Never put neon text over busy images without an overlay.
* Focus states: 2px ring in `--ring` on focus-visible.

---

## Implementation checklist (Next.js + Medusa + Shadcn)

1. **Tokens**: paste CSS vars above into `globals.css`. (Keep existing variables; add new ones.)
2. **Theme switch**: wrap app with a theme provider that toggles `data-theme="dark"` on `<html>`.
3. **Tailwind**: extend colors & shadows as shown; use class names instead of hard-coded hex.
4. **Shadcn**: set component classes to reference `bg-primary`, `bg-secondary`, `border-border`, etc.
5. **Badges**: create a `DealBadge` component with the light/dark classes provided.
6. **Buttons**: primary/secondary presets with glow shadows.
7. **Cards**: standardize product and content cards on `bg-card` + `border-border`.

---

## Quick class snippets

**Primary CTA**

```html
<button class="inline-flex items-center gap-2 rounded-xl px-5 py-3 bg-primary text-primary-foreground shadow-glow-magenta hover:opacity-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[color:var(--ring)]">
  Shop Today’s Picks
</button>
```

**Deal badge**

```html
<span class="px-2 py-1 rounded-md text-xs font-semibold bg-[color:var(--cloud-100)] text-[color:var(--brand-700)] dark:bg-[#1A1B20] dark:text-[color:var(--accent-100)]">
  Nick Approved
</span>
```

**Card**

```html
<div class="bg-card text-card-foreground border border-border rounded-2xl p-4 shadow-sm hover:shadow-glow-cyan transition">
  <!-- product content -->
</div>
```

---

## Content voice

* Friendly, confident, concise.
* Phrases like: **“Picked by Nick.”**, **“Best price today.”**, **“No fluff, just value.”**