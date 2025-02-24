import { Media } from "@/api/@types"
import { useEffect, useState } from "react";

interface MediaComponentProps {
  media: Media
}

export function MediaComponent({ media }: MediaComponentProps) {
  const [isValid, setIsValid] = useState(false);
  
  useEffect(() => {
    const img = new Image();
    img.src = media.image_url;

    img.onload = () => setIsValid(true);
    img.onerror = () => setIsValid(false);
  }, []);

  if (!isValid) return null;

  return (
    <img src={media.image_url} alt={media.description} className='rounded md:max-w-[33rem]' />
  )
}
