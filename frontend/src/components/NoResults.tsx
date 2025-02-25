interface NoResultsProps {
  isError: boolean
}

export function NoResults({ isError }: NoResultsProps) {
  return (
    <div className="border rounded text-center p-4 mt-[15rem]">
      <p>
        {isError ? 'Error fetching media. Please try again.' : 'No media found'}
      </p>
    </div>
  )
}
