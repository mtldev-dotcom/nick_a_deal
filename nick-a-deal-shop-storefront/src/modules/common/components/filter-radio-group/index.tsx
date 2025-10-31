import { EllipseMiniSolid } from "@medusajs/icons"
import { Label, RadioGroup, Text, clx } from "@medusajs/ui"

type FilterRadioGroupProps = {
  title: string
  items: {
    value: string
    label: string
  }[]
  value: any
  handleChange: (...args: any[]) => void
  "data-testid"?: string
}

const FilterRadioGroup = ({
  title,
  items,
  value,
  handleChange,
  "data-testid": dataTestId,
}: FilterRadioGroupProps) => {
  return (
    <div className="flex gap-x-3 flex-col gap-y-4">
      <Text className="txt-compact-small-plus text-foreground font-semibold mb-1">
        {title}
      </Text>
      <RadioGroup data-testid={dataTestId} onValueChange={handleChange} className="space-y-2">
        {items?.map((i) => {
          const isActive = i.value === value
          return (
            <div
              key={i.value}
              className={clx(
                "flex gap-x-3 items-center p-2 rounded-lg transition-all duration-200",
                "hover:bg-muted/30 cursor-pointer",
                {
                  "bg-primary/10 border border-primary/20": isActive,
                  "ml-[-23px]": isActive,
                }
              )}
              onClick={() => handleChange(i.value)}
            >
              <div className={clx(
                "flex items-center justify-center w-4 h-4 rounded-full transition-all duration-200",
                {
                  "bg-primary": isActive,
                  "border-2 border-muted": !isActive,
                }
              )}>
                {isActive && (
                  <div className="w-2 h-2 rounded-full bg-white" />
                )}
              </div>
              <RadioGroup.Item
                checked={isActive}
                className="hidden peer"
                id={i.value}
                value={i.value}
              />
              <Label
                htmlFor={i.value}
                className={clx(
                  "!txt-compact-small !transform-none cursor-pointer transition-colors duration-200",
                  {
                    "text-foreground font-semibold": isActive,
                    "text-muted-foreground hover:text-foreground": !isActive,
                  }
                )}
                data-testid="radio-label"
                data-active={isActive}
              >
                {i.label}
              </Label>
            </div>
          )
        })}
      </RadioGroup>
    </div>
  )
}

export default FilterRadioGroup
