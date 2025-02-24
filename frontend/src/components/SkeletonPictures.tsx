import { Skeleton } from '@radix-ui/themes'

export function SkeletonPictures() {
  return (
    <div className='flex flex-wrap gap-4 mt-4 justify-center'>
      <Skeleton className='rounded w-[19rem] md:w-[33rem] h-[13rem] md:h-[22rem]'>Skeleton</Skeleton>
      <Skeleton className='rounded w-[19rem] md:w-[33rem] h-[13rem] md:h-[22rem]'>Skeleton</Skeleton>
      <Skeleton className='rounded w-[19rem] md:w-[33rem] h-[13rem] md:h-[22rem]'>Skeleton</Skeleton>
      <Skeleton className='rounded w-[19rem] md:w-[33rem] h-[13rem] md:h-[22rem]'>Skeleton</Skeleton>
    </div>
  )
}
