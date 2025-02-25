# frozen_string_literal: true

RSpec.describe Api::V1::HealthController, type: :controller do
  describe 'GET #index' do
    context 'with connections' do
      before do
        allow(ElasticsearchService.client).to receive(:ping).and_return(true)
      end

      it 'returns OK status' do
        get :index
        res = JSON.parse(response.body)
        expect(res['elasticsearch']['status']).to eq('OK')
        expect(res['database']['status']).to eq('OK')
      end
    end

    context 'without connections' do
      before do
        allow(ElasticsearchService.client).to receive(:ping).and_raise(StandardError.new('Test error'))
        allow(ActiveRecord::Base).to receive(:connection).and_raise(StandardError.new('Test error'))
      end

      it 'returns error status' do
        get :index
        res = JSON.parse(response.body)
        expect(res['elasticsearch']['status']).to eq('ERROR')
        expect(res['database']['status']).to eq('ERROR')
      end
    end
  end
end