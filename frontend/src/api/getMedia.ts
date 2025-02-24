import axios from "axios";
import { apiUrls } from "@/constants";

export interface GetMediaParams {
  page?: number
  sortDirection?: string
  query?: string
  db?: string
}

export async function getMedia({ page, sortDirection, query, db }: GetMediaParams) {
  const { data } =  await axios.get(apiUrls.base + apiUrls.media,
    {
      params: {
        page,
        sort_direction: sortDirection,
        query,
        db
      }
    }
  )

  return data
}
