import { Button, Select } from '@radix-ui/themes'
import { Input } from '@/components/ui/input'
import { useState } from 'react'

interface SearchBarProps {
  onSubmit: (query: string) => void
}

export function SearchBar({ onSubmit }: SearchBarProps) {
  const [query, setQuery] = useState('')

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    onSubmit(query)
  }

  return (
    <div className="flex gap-6 items-center">
      <form onSubmit={handleSubmit}>
        <Input className="lg:w-[30rem]" placeholder='Search' value={query} onChange={(e) => setQuery(e.target.value)} />
      </form>
      <div className='flex justify-around gap-2'>
        <Button variant="outline" color="gray" radius="full" className="p-6">All</Button>
        <Button variant="outline" color="gray" radius="full" className="p-6">Stock</Button>
        <Button variant="outline" color="gray" radius="full" className="p-6">Sport</Button>
      </div>
      <Select.Root defaultValue="newest">
        <Select.Trigger />
        <Select.Content>
          <Select.Group>
            <Select.Label>Order</Select.Label>
            <Select.Item value="newest">Newest</Select.Item>
            <Select.Item value="Oldest">Oldest</Select.Item>
          </Select.Group>
        </Select.Content>
      </Select.Root>
    </div>
  )
}
