import { useState } from 'react'
import './App.css'
import { Filters, SearchBar } from './components/SearchBar'
import { useGetMedia } from './hooks/useGetMedia'
import { SkeletonPictures } from './components/SkeletonPictures'
import { NoResults } from './components/NoResults'

function App() {
  const [searchTerm, setSearchTerm] = useState('')
  const [filters, setFilters] = useState<Filters>({ db: '', sortDirection: '' })
  const { images, isLoading } = useGetMedia({ query: searchTerm, sortDirection: filters.sortDirection, db: filters.db })

  const handleSearch = (query: string, searchFilters: Filters = {}) => {
    setSearchTerm(query)
    setFilters(searchFilters)
  }

  const hasNoResults = () => {
    return !isLoading && images.length === 0 && searchTerm !== ''
  }
  // TODO: open dialog with picture details
  // TODO: add infinite scroll
  // TODO: deal with wrong urls
  
  // TODO: add date filter
  return (
    <div className='h-screen flex flex-col items-center rounded p-4'>
      <img src='/imago.svg' className='w-40 mb-4' alt='Imago Logo' />
      <p className="font-bold mb-4">Search through our collection of high-quality images</p>
      <SearchBar onSubmit={handleSearch} />
      {
        isLoading && <SkeletonPictures />
      }
      <div className='flex flex-wrap gap-4 mt-4 justify-center'>
        {
          images.map((image) => (
            <img key={image.id} src={image.image_url} alt={image.description} className='rounded md:max-w-[33rem]' />
          ))
        }
      </div>
      {
        hasNoResults() && <NoResults />
      }
    </div>
  )
}

export default App
