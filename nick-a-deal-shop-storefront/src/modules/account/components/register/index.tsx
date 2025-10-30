"use client"

import { useActionState } from "react"
import Input from "@modules/common/components/input"
import { LOGIN_VIEW } from "@modules/account/templates/login-template"
import ErrorMessage from "@modules/checkout/components/error-message"
import { SubmitButton } from "@modules/checkout/components/submit-button"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import { signup } from "@lib/data/customer"

type Props = {
  setCurrentView: (view: LOGIN_VIEW) => void
}

const Register = ({ setCurrentView }: Props) => {
  const [message, formAction] = useActionState(signup, null)

  return (
    <div
      className="w-full flex flex-col items-center"
      data-testid="register-page"
    >
      <h1 className="text-2xl font-semibold text-foreground mb-2">
        Become a Member
      </h1>
      <p className="text-center text-base text-muted-foreground mb-6">
        Create your profile, and get access to an enhanced shopping experience.
      </p>
      <form className="w-full flex flex-col" action={formAction}>
        <div className="flex flex-col w-full gap-y-4">
          <Input
            label="First name"
            name="first_name"
            required
            autoComplete="given-name"
            data-testid="first-name-input"
          />
          <Input
            label="Last name"
            name="last_name"
            required
            autoComplete="family-name"
            data-testid="last-name-input"
          />
          <Input
            label="Email"
            name="email"
            required
            type="email"
            autoComplete="email"
            data-testid="email-input"
          />
          <Input
            label="Phone"
            name="phone"
            type="tel"
            autoComplete="tel"
            data-testid="phone-input"
          />
          <Input
            label="Password"
            name="password"
            required
            type="password"
            autoComplete="new-password"
            data-testid="password-input"
          />
        </div>
        <ErrorMessage error={message} data-testid="register-error" />
        <span className="text-center text-muted-foreground text-sm mt-6">
          By creating an account, you agree to Nick a Deal&apos;s{" "}
          <LocalizedClientLink
            href="/content/privacy-policy"
            className="text-primary hover:text-primary/80 underline transition-colors"
          >
            Privacy Policy
          </LocalizedClientLink>{" "}
          and{" "}
          <LocalizedClientLink
            href="/content/terms-of-use"
            className="text-primary hover:text-primary/80 underline transition-colors"
          >
            Terms of Use
          </LocalizedClientLink>
          .
        </span>
        <SubmitButton className="w-full mt-6 h-12 bg-primary text-primary-foreground shadow-glow-magenta hover:opacity-95 text-base font-medium" data-testid="register-button">
          Join
        </SubmitButton>
      </form>
      <span className="text-center text-muted-foreground text-sm mt-6">
        Already a member?{" "}
        <button
          onClick={() => setCurrentView(LOGIN_VIEW.SIGN_IN)}
          className="text-primary hover:text-primary/80 underline transition-colors"
        >
          Sign in
        </button>
        .
      </span>
    </div>
  )
}

export default Register
