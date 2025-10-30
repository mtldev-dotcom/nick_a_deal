import React from "react"

import UnderlineLink from "@modules/common/components/interactive-link"

import AccountNav from "../components/account-nav"
import { HttpTypes } from "@medusajs/types"

interface AccountLayoutProps {
  customer: HttpTypes.StoreCustomer | null
  children: React.ReactNode
}

const AccountLayout: React.FC<AccountLayoutProps> = ({
  customer,
  children,
}) => {
  return (
    <div className="flex-1 small:py-12 bg-background" data-testid="account-page">
      <div className="flex-1 content-container h-full max-w-5xl mx-auto bg-card border border-border rounded-xl shadow-sm flex flex-col mt-8 mb-8">
        <div className="grid grid-cols-1 small:grid-cols-[240px_1fr] py-12 px-6 small:px-12">
          <div>{customer && <AccountNav customer={customer} />}</div>
          <div className="flex-1">{children}</div>
        </div>
        <div className="flex flex-col small:flex-row items-end justify-between small:border-t border-border py-12 px-6 small:px-12 gap-8">
          <div>
            <h3 className="text-xl font-semibold text-foreground mb-4">Got questions?</h3>
            <span className="text-base text-muted-foreground">
              You can find frequently asked questions and answers on our
              customer service page.
            </span>
          </div>
          <div>
            <UnderlineLink href="/customer-service">
              Customer Service
            </UnderlineLink>
          </div>
        </div>
      </div>
    </div>
  )
}

export default AccountLayout
