import { useState } from 'react'
import './App.css'
import { SearchBar } from './components/SearchBar'
import { useGetMedia } from './hooks/useGetMedia'
import { Media } from './api/@types'

function App() {
  const [searchTerm, setSearchTerm] = useState('')

  const { data } = useGetMedia({ query: searchTerm })

  let images: Media[] = []

  if(data?.pages) {
    images = data?.pages.reduce(page => page)
  }

  return (
    <div className='h-screen flex flex-col items-center rounded p-4'>
      <img src='/imago.svg' className='w-40 mb-4' alt='Imago Logo' />
      <p className="font-bold mb-4">Search through our collection of high-quality images</p>
      <SearchBar onSubmit={(query) => setSearchTerm(query)} />
      <div className='flex flex-wrap gap-4 mt-4 justify-center'>
        {
          images.map((image) => (
            <img key={image.id} src={image.image_url} alt={image.description} className='rounded' />
          ))
        }
      </div>
    </div>
  )
}

export default App
