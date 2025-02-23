# frozen_string_literal: true

class ElasticsearchService
  BASE_URL = 'https://www.imago-images.de'

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

  def self.search(query, index = 'imago')
    response = client.search(
      index: index,
      q: query,
      # body: {
      #   # _source: ["title", "description", "url", "image_url"],
      #   query: {
      #     multi_match: {
      #       query: query,
      #       # fields: ['title^5', 'description']
      #     }
      #   }
      # }
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
