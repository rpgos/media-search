import { useState } from 'react'
import './App.css'
import { Filters, SearchBar } from './components/SearchBar'
import { useGetMedia } from './hooks/useGetMedia'
import { SkeletonPictures } from './components/SkeletonPictures'
import { NoResults } from './components/NoResults'
import { Button } from '@radix-ui/themes'
import { MediaComponent } from './components/MediaComponent'

function App() {
  const [searchTerm, setSearchTerm] = useState('')
  const [filters, setFilters] = useState<Filters>({ db: '', sortDirection: '', photographer: '' })
  const {
    images,
    isLoading,
    fetchNextPage,
    hasNextPage,
    isFetching,
    isError
  } = useGetMedia({ query: searchTerm, sortDirection: filters.sortDirection, db: filters.db, photographer: filters.photographer })

  // useCallback
  const handleSearch = (query: string, searchFilters: Filters = {}) => {
    setSearchTerm(query)
    setFilters(searchFilters)
  }

  const hasNoResults = () => {
    return !isLoading && images.length === 0 && searchTerm !== ''
  }

  return (
    <div className='flex flex-col items-center rounded p-4'>
      <img src='/imago.svg' className='w-40 mb-4' alt='Imago Logo' />
      <p className="font-bold mb-4">Search through our collection of high-quality images</p>
      <SearchBar onSubmit={handleSearch} />
      
      <div className='flex flex-wrap gap-4 mt-4 justify-center'>
        {
          images.map((image) => (
            <MediaComponent key={image.id} media={image} />
          ))
        }
      </div>
      {
        isLoading && <SkeletonPictures />
      }
      {
        hasNoResults() && <NoResults isError={isError} />
      }
      {
        hasNextPage && !isFetching &&
        <div className="p-4 mt-[4rem]">
          <Button onClick={() => fetchNextPage()} color="gray" variant="outline">
            Load more
          </Button>
        </div>
      }
    </div>
  )
}

export default App
