# frozen_string_literal: true

RSpec.describe ElasticsearchService do
  let(:es_raw_response) do
    {
      "took": 5,
      "timed_out": false,
      "_shards": { "total": 1, "successful": 1, "skipped": 0, "failed": 0 },
      "hits": {
        "total": { "value": 1, "relation": "eq" },
        "max_score": 1.0,
        "hits": [
          {
            "_index": "imago",
            "_id": "1",
            "_score": 1.0,
            "_source": {
              "bildnummer": "51831860",
              "datum": "1989-12-01T00:00:00.000Z",
              "suchtext": "Bananen und anderes Obst...",
              "fotografen": "RG",
              "hoehe": 5364,
              "breite": 3591,
              "db": "stock"
            }
          }
        ]
      }
    }.with_indifferent_access
  end

  describe '#search' do
    before do
      allow(ElasticsearchService.client).to receive(:search).and_return(es_raw_response)
      allow(ElasticsearchService).to receive(:format_hit).and_return({ test: '' })
    end

    it 'calls elasticsearch service and returns parsed data' do
      res = described_class.search('test')

      expect(res).to match({ current_page: 1, results: [{ test: '' }], total_pages: 1, total_results: 1 })
    end
  end

  describe '#build_sort' do
    it 'returns sorting by date' do
      res = described_class.build_sort('desc')

      expect(res).to match_array([{ 'datum' => { order: 'desc' } }])
    end
  end

  describe '#format_hit' do
    before do
      allow(ElasticsearchService).to receive(:construct_image_url).and_return('test_url')
    end

    it 'parses ES hit for api response' do
      hit = es_raw_response['hits']['hits'].first
      source = hit['_source']
      res = described_class.format_hit(hit)

      expect(res).to match({
        id: hit['_id'],
        date: source['datum'],
        title: nil,
        description: source['suchtext'],
        photographer: source['fotografen'],
        height: source['hoehe'],
        width: source['breite'],
        image_url: 'test_url'
      })
    end
  end

  describe '#construct_image_url' do
    it 'returns image url' do
      expected_url = 'https://www.imago-images.de/bild/db/id/s.jpg'
      expect(described_class.construct_image_url('id', 'db')).to eq(expected_url)
    end
  end
end
