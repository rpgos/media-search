import './App.css'
import { Input } from './components/ui/input'

function App() {

  return (
    <div className='bg-gray-200 h-screen flex flex-col items-center rounded p-4'>
      <img src='/imago.svg' className='w-40 mb-4' alt='Imago Logo' />
      <div>
        <Input placeholder='Search' />
      </div>
    </div>
  )
}

export default App
