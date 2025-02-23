# frozen_string_literal: true

class ElasticsearchService
  BASE_URL = 'https://www.imago-images.de'
  DEFAULT_PAGE = 1
  DEFAULT_SIZE = 12

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

  def self.search(query, page = DEFAULT_PAGE, index = 'imago')
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
            filter: [
              { exists: { field: 'bildnummer' } },
              { exists: { field: 'db' } }
            ]
          }
        },
        from: from,
        size: DEFAULT_SIZE
      }
    )

    format_results(response['hits']['hits'])
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
