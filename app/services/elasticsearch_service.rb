class ElasticsearchService
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
    client.search(
      index: index,
      body: {
        query: {
          multi_match: {
            query: query,
            fields: ['title^5', 'description']
          }
        }
      }
    )
  end
end
