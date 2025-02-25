# frozen_string_literal: true

RSpec.describe Api::V1::MediaController, type: :controller do
  describe 'GET #index' do
    context 'with query search param' do
      let(:results) { {
        total_results: 1,
        total_pages: 1,
        current_page: 1,
        results: [{
          id: 'test',
          date: 'test',
          title: 'test',
          description: 'test',
          photographer: 'test',
          height: 200,
          width: 300,
          image_url: 'test'
        }]
       } }

      before do
        allow(ElasticsearchService).to receive(:search).and_return(results)
      end

      it 'returns :ok response' do
        get :index, params: { query: 'Berlin' }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'without query search param' do
      it 'returns :bad_request' do
        get :index, params: {}
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when search raises an error' do
      before do
        allow(ElasticsearchService).to receive(:search).and_raise(StandardError.new('Test error'))
      end

      it 'returns :internal_server_error with error message' do
        get :index, params: { query: 'test' }

        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)['details']).to eq('Test error')
      end
    end
  end
end
