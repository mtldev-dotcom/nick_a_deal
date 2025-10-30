import { Button, Heading, Text } from "@medusajs/ui"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

const SignInPrompt = () => {
  return (
    <div className="bg-background/30 border border-border rounded-lg p-4 flex items-center justify-between">
      <div>
        <Heading level="h2" className="text-base font-semibold text-foreground">
          Already have an account?
        </Heading>
        <Text className="text-sm text-muted-foreground mt-1">
          Sign in for a better experience.
        </Text>
      </div>
      <div>
        <LocalizedClientLink href="/account">
          <Button variant="secondary" className="btn-animated-border btn-animated-border-secondary h-10 bg-secondary text-secondary-foreground hover:opacity-90" data-testid="sign-in-button">
            Sign in
          </Button>
        </LocalizedClientLink>
      </div>
    </div>
  )
}

export default SignInPrompt
