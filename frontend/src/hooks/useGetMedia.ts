import { useInfiniteQuery } from "@tanstack/react-query"
import { getMedia, GetMediaParams } from "@/api/getMedia"

export const useGetMedia = ({ query, sortDirection }: GetMediaParams) => {
  return useInfiniteQuery({
    queryKey: ['media', { sortDirection, query }],
    queryFn: ({ pageParam }) => getMedia({ page: pageParam, query, sortDirection }),
    initialPageParam: 1,
    getNextPageParam: (lastPage) => {
      if (lastPage.next_page) {
        return lastPage.next_page
      }
      return undefined
    },
  })
}
