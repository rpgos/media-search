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
      },
      log: true
    )
  end

  def self.search(query, filters: {}, page: DEFAULT_PAGE, index: 'imago')
    page = page.to_i
    from = (page - 1) * DEFAULT_SIZE

    response = client.search(
      index: index,
      body: build_search_body(query, filters, from)
    )

    Rails.logger.info("[ES SEARCH] Query: #{query}")
    Rails.logger.info("[ES SEARCH] Results: #{response.dig('hits', 'total', 'value')} hits found")
    format_results(response, page)
  rescue StandardError => e
    Rails.logger.error("[ES ERROR] Failed search query: #{e.message}")
    raise
  end

  def self.build_search_body(query, filters, from)
    {
      query: {
        bool: {
          should: [
            {
              match_phrase: {
                title: {
                  query: query,
                  slop: 2
                }
              }
            }
          ],
          must: [
            {
              multi_match: {
                query: query,
                fields: ['title^5', 'description^3', 'suchtext^3', 'fotografen'],
                minimum_should_match: '70%'
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
  end

  def self.build_filters(filters)
    filter_conditions = []

    # make sure we have an image url
    filter_conditions << { exists: { field: 'bildnummer' } }
    filter_conditions << { exists: { field: 'db' } }

    filter_conditions << { term: { 'fotografen.keyword' => filters[:photographer] } } if filters[:photographer].present?
    filter_conditions << { term: { 'db' => filters[:db] } } if filters[:db].present?
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

  def self.build_sort(direction)
    [{ 'datum' => { order: direction || DEFAULT_SORT_DIRECTION } }]
  end

  def self.format_results(results, page)
    hits = results.dig('hits', 'hits') || []
    total_results = results.dig('hits', 'total', 'value') || 0

    {
      total_results: total_results,
      total_pages: (total_results.to_f / DEFAULT_SIZE).ceil,
      current_page: page,
      results: hits.map { |hit| format_hit(hit) }
    }
  end

  def self.format_hit(hit)
    source = hit['_source']
    {
      id: hit['_id'],
      date: source['datum'],
      title: source['title'],
      description: source['description'] || source['suchtext'],
      photographer: source['fotografen'],
      height: source['hoehe'].to_i,
      width: source['breite'].to_i,
      image_url: construct_image_url(source['bildnummer'], source['db'])
    }
  end

  def self.construct_image_url(image_id, db_source)
    "#{BASE_URL}/bild/#{db_source}/#{image_id}/s.jpg"
  end
end
