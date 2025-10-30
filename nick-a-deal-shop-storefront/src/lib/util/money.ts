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
  locale = "en-US",
  omitCurrencySymbol,
}: ConvertToLocaleParams) => {
  if (!currency_code || isEmpty(currency_code)) {
    return amount.toString()
  }

  const formatter = new Intl.NumberFormat(locale, {
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
