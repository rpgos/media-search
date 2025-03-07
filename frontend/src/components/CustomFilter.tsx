import { getFilterValues } from "../api/getFilterValues";
import { Select } from "@radix-ui/themes";
import { useSuspenseQuery } from "@tanstack/react-query";

export interface CustomFilterProps {
  filter: string
  onChange: (value: string) => void
}

export function CustomFilter({ filter, onChange }: CustomFilterProps) {
  const { data } = useSuspenseQuery({
    queryKey: ['filter'],
    queryFn: () => getFilterValues({ filter }),
  })

  return (
    <Select.Root onValueChange={(value) => onChange(value)}>
      <Select.Trigger placeholder={filter} className="capitalize" />
      <Select.Content>
        <Select.Group>
          <Select.Label className="capitalize">{filter}</Select.Label>
          {
            data.filters.map(value => (
              <Select.Item key={value} value={value}>{value}</Select.Item>
            ))
          }
        </Select.Group>
      </Select.Content>
    </Select.Root>
  )
}
