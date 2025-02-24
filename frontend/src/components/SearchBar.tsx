import { Button, Select } from '@radix-ui/themes'
import { Input } from '@/components/ui/input'
import { useEffect, useState } from 'react'
import { CornerDownLeft } from 'lucide-react'

interface SearchBarProps {
  onSubmit: (query: string, filters?: Filters) => void
}

export interface Filters {
  db?: string
  sortDirection?: string
}

export function SearchBar({ onSubmit }: SearchBarProps) {
  const [query, setQuery] = useState('')
  const [db, setDb] = useState('')
  const [order, setOrder] = useState('desc')

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    onSubmit(query, { db, sortDirection: order })
  }

  useEffect(() => {
    onSubmit(query, { db, sortDirection: order })
  }, [db, order])

  return (
    <div className="flex gap-6 items-center">
      <form onSubmit={handleSubmit} className="relative">
        <Input className="lg:w-[30rem]" placeholder='Type and press Enter to search' value={query} onChange={(e) => setQuery(e.target.value)} />
        <CornerDownLeft className="absolute w-4 top-2 right-2" />
      </form>
      <div className='flex justify-around gap-2'>
        <Button onClick={() => setDb('')} variant={db === '' ? 'solid' : 'outline'} color="gray" radius="full" className="p-6">All</Button>
        <Button onClick={() => setDb('stock')} variant={db === 'stock' ? 'solid' : 'outline'} color="gray" radius="full" className="p-6">Stock</Button>
        <Button onClick={() => setDb('sport')} variant={db === 'sport' ? 'solid' : 'outline'} color="gray" radius="full" className="p-6">Sport</Button>
      </div>
      <Select.Root defaultValue="desc" onValueChange={(value) => setOrder(value)}>
        <Select.Trigger />
        <Select.Content>
          <Select.Group>
            <Select.Label>Order</Select.Label>
            <Select.Item value="desc">Newest</Select.Item>
            <Select.Item value="asc">Oldest</Select.Item>
          </Select.Group>
        </Select.Content>
      </Select.Root>
    </div>
  )
}
