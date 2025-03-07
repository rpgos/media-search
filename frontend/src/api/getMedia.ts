import axios from "axios";
import { apiUrls } from "../constants";

export interface GetMediaParams {
  page?: number
  sortDirection?: string
  query?: string
  db?: string
  photographer?: string
}

export async function getMedia({ page, sortDirection, query, db, photographer }: GetMediaParams) {
  const { data } =  await axios.get(apiUrls.base + apiUrls.media,
    {
      params: {
        page,
        sort_direction: sortDirection,
        query,
        db,
        photographer
      }
    }
  )

  return data
}
