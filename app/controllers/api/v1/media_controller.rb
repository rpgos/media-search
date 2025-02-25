# frozen_string_literal: true

module Api
  module V1
    class MediaController < ApplicationController
      before_action :ensure_valid_query_param

      def index
        page = search_params[:page] || 1

        results = ElasticsearchService.search(search_params[:query], filters: filter_params, page: page)
        render json: results, status: :ok
      rescue StandardError => e
        render json: { error: 'Something went wrong', details: e.message }, status: :internal_server_error
      end

      private

      def ensure_valid_query_param
        return unless search_params[:query].blank?

        render json: { error: 'Query parameter is required' }, status: :bad_request and return
      end

      def search_params
        params.permit(:query, :page)
      end

      def filter_params
        params.permit(:photographer, :db, :start_date, :end_date, :sort_direction)
      end
    end
  end
end
