import axios from "axios";
import { apiUrls } from "../constants";

export interface GetFilterParams {
  filter: string
}

export async function getFilterValues({ filter }: GetFilterParams) {
  const { data } =  await axios.get(apiUrls.base + apiUrls.filterValues,
    {
      params: {
        filter
      }
    }
  )

  return data
}
