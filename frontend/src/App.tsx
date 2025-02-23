import { Button, Select } from '@radix-ui/themes'
import './App.css'
import { Input } from './components/ui/input'

function App() {

  return (
    <div className='h-screen flex flex-col items-center rounded p-4'>
      <img src='/imago.svg' className='w-40 mb-4' alt='Imago Logo' />
      <p className="font-bold mb-4">Search through our collection of high-quality images</p>
      <div className="flex gap-6 items-center">
        <Input className="lg:w-[30rem]" placeholder='Search' />
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
    </div>
  )
}

export default App
