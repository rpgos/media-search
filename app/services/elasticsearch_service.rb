# frozen_string_literal: true

class ElasticsearchService
  BASE_URL = 'https://www.imago-images.de'
  DEFAULT_PAGE = 1
  DEFAULT_SIZE = 12
  DEFAULT_SORT_DIRECTION = 'desc'

  def self.client
    @client ||= Elasticsearch::Client.new(
      url: ENV.fetch('ELASTICSEARCH_URL'),
      user: ENV.fetch('ELASTICSEARCH_USERNAME'),
      password: ENV.fetch('ELASTICSEARCH_PASSWORD'),
      transport_options: {
        ssl: { verify: false }
      }
    )
  end

  def self.search(query, filters: {}, page: DEFAULT_PAGE, index: 'imago')
    page = page.to_i
    from = (page - 1) * DEFAULT_SIZE

    response = client.search(
      index: index,
      body: {
        query: {
          bool: {
            must: [
              {
                multi_match: {
                  query: query,
                  fields: ['suchtext^3', 'fotografen']
                }
              }
            ],
            filter: build_filters(filters)
          }
        },
        sort: build_sort(filters[:sort_direction]),
        from: from,
        size: DEFAULT_SIZE
      }
    )

    format_results(response['hits']['hits'])
  end

  def self.build_filters(filters)
    filter_conditions = []

    # make sure we have an image url
    filter_conditions << { exists: { field: 'bildnummer' } }
    filter_conditions << { exists: { field: 'db' } }

    filter_conditions << { term: { 'fotografen.keyword' => filters[:photographer] } } if filters[:photographer].present?
    filter_conditions << { term: { 'db.keyword' => filters[:db] } } if filters[:db].present?
    filter_conditions << { range: { 'hoehe' => { gte: filters[:min_height].to_i } } } if filters[:min_height].present?
    filter_conditions << { range: { 'breite' => { gte: filters[:min_width].to_i } } } if filters[:min_width].present?

    if filters[:start_date].present? || filters[:end_date].present?
      range_filter = { range: { 'datum' => {} } }
      range_filter[:range]['datum'][:gte] = filters[:start_date] if filters[:start_date].present?
      range_filter[:range]['datum'][:lte] = filters[:end_date] if filters[:end_date].present?
      filter_conditions << range_filter
    end

    filter_conditions
  end

  def build_sort(direction)
    [{ 'datum' => { order: direction || DEFAULT_SORT_DIRECTION } }]
  end

  def self.format_results(results)
    results.map do |result|
      {
        id: result['_id'],
        date: result['_source']['datum'],
        description: result['_source']['suchtext'],
        photographer: result['_source']['fotografen'],
        height: result['_source']['hoehe'].to_i,
        width: result['_source']['breite'].to_i,
        image_url: construct_image_url(result['_source']['bildnummer'], result['_source']['db'])
      }
    end
  end

  def self.construct_image_url(image_id, db_source)
    "#{BASE_URL}/bild/#{db_source}/#{image_id}/s.jpg"
  end
end
