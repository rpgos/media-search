# frozen_string_literal: true

module Api
  module V1
    class MediaController < ApplicationController
      def index
        query = params[:query]
        page = params[:page] || 1

        if query.blank?
          render json: { error: 'Query parameter is required' }, status: :bad_request
          return
        end

        results = ElasticsearchService.search(query, filters: filter_params, page: page)
        render json: results, status: :ok
      rescue StandardError => e
        render json: { error: 'Something went wrong', details: e.message }, status: :internal_server_error
      end

      private

      def filter_params
        params.permit(:photographer, :db, :start_date, :end_date, :sort_direction)
      end
    end
  end
end
