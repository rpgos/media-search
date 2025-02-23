import { useState } from 'react'
import './App.css'
import { SearchBar } from './components/SearchBar'
import { useGetMedia } from './hooks/useGetMedia'

function App() {
  const [searchTerm, setSearchTerm] = useState('')

  const { data } = useGetMedia({ query: searchTerm })

  return (
    <div className='h-screen flex flex-col items-center rounded p-4'>
      <img src='/imago.svg' className='w-40 mb-4' alt='Imago Logo' />
      <p className="font-bold mb-4">Search through our collection of high-quality images</p>
      <SearchBar onSubmit={(query) => setSearchTerm(query)} />
    </div>
  )
}

export default App
