import { isEmpty } from "./isEmpty"

type ConvertToLocaleParams = {
  amount: number
  currency_code: string
  minimumFractionDigits?: number
  maximumFractionDigits?: number
  locale?: string
  omitCurrencySymbol?: boolean
}

export const convertToLocale = ({
  amount,
  currency_code,
  minimumFractionDigits,
  maximumFractionDigits,
  locale,
  omitCurrencySymbol,
}: ConvertToLocaleParams) => {
  if (!currency_code || isEmpty(currency_code)) {
    return amount.toString()
  }

  // Choose a locale that shows the desired symbol for the currency.
  // For example, CAD in en-US shows "CA$" while en-CA shows "$".
  const normalizedCode = (currency_code || "").toUpperCase()
  const effectiveLocale =
    locale || (normalizedCode === "CAD" ? "en-CA" : "en-US")

  const formatter = new Intl.NumberFormat(effectiveLocale, {
    style: "currency",
    currency: currency_code,
    minimumFractionDigits,
    maximumFractionDigits,
  })

  if (!omitCurrencySymbol) {
    return formatter.format(amount)
  }

  // Use formatToParts to drop the currency symbol/code while keeping locale formatting
  const parts = formatter.formatToParts(amount).filter((p) => p.type !== "currency")
  return parts.map((p) => p.value).join("")
}
