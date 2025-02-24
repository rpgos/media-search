import { Media } from "@/api/@types"
import { Dialog } from "@radix-ui/themes";
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
    <Dialog.Root>
      <Dialog.Trigger className="cursor-pointer">
        <img src={media.image_url} alt={media.description} className='rounded md:max-w-[33rem]' />
    	</Dialog.Trigger>
      <Dialog.Content className="flex flex-col items-center">
        <Dialog.Title>{media.title}</Dialog.Title>
        <Dialog.Description size="2" mb="4">
          {media.description}
        </Dialog.Description>
        <img src={media.image_url} alt={media.description} className='rounded md:max-w-[33rem]' />
        <div>
          <span>Photographer: </span>
          <span>{media.photographer}</span>
        </div>
      </Dialog.Content>
    </Dialog.Root>
  )
}
