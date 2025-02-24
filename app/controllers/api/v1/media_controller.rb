# frozen_string_literal: true

module Api
  module V1
    class MediaController < ApplicationController
      before_action :ensure_valid_query_param

      def index
        page = params[:page] || 1

        results = ElasticsearchService.search(es_query_param, filters: filter_params, page: page)
        render json: results, status: :ok
      rescue StandardError => e
        render json: { error: 'Something went wrong', details: e.message }, status: :internal_server_error
      end

      private

      def ensure_valid_query_param
        return unless es_query_param.blank?

        render json: { error: 'Query parameter is required' }, status: :bad_request and return
      end

      def filter_params
        params.permit(:photographer, :db, :start_date, :end_date, :sort_direction)
      end

      def es_query_param
        params[:query]
      end
    end
  end
end
