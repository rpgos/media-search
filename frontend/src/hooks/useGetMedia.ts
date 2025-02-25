import { useInfiniteQuery } from "@tanstack/react-query"
import { getMedia, GetMediaParams } from "../api/getMedia"
import { Media } from "../api/@types"

export const useGetMedia = ({ query, sortDirection, db }: GetMediaParams) => {
  const infiniteQuery = useInfiniteQuery({
    queryKey: ['media', { sortDirection, query, db }],
    enabled: query !== '',
    queryFn: ({ pageParam }) => getMedia({ page: pageParam, query, sortDirection, db }),
    initialPageParam: 1,
    getNextPageParam: (lastPage) => {
      if (lastPage.current_page < lastPage.total_pages) {
        return lastPage.current_page + 1
      }
      return undefined
    },
    staleTime: 1000 * 60 * 2 // 2 minutes
  })

  const images: Media[] = infiniteQuery.data?.pages.flatMap(page => page.results) || []

  return {
    ...infiniteQuery,
    images,
  }
}
