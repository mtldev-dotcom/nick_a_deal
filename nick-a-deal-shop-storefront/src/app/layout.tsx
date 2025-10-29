import { getBaseURL } from "@lib/util/env"
import { Metadata } from "next"
import { ThemeProvider } from "@lib/providers/theme-provider"
import "styles/globals.css"

export const metadata: Metadata = {
  metadataBase: new URL(getBaseURL()),
  title: {
    default: "Nick a Deal - If Nick approved it, it's a deal",
    template: "%s | Nick a Deal",
  },
  description: "Deals hand-picked by Nick. Curated deals you can trust.",
}

export default function RootLayout(props: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body>
        <ThemeProvider
          attribute="data-theme"
          defaultTheme="light"
          enableSystem={true}
        >
          <main className="relative bg-background text-foreground">
            {props.children}
          </main>
        </ThemeProvider>
      </body>
    </html>
  )
}
