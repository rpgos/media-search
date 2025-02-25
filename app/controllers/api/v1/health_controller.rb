# frozen_string_literal: true

module Api
  module V1
    class HealthController < ApplicationController
      def index
        render json: {
          elasticsearch: check_elasticsearch,
          database: check_database
        }
      end

      private

      def check_elasticsearch
        ElasticsearchService.client.ping

        { status: 'OK' }
      rescue StandardError => e
        Rails.logger.error("[HEALTH CHECK] Elasticsearch error: #{e.message}")
        { status: 'ERROR' }
      end

      def check_database
        ActiveRecord::Base.connection.active? ? { status: 'OK' } : { status: 'ERROR' }
      rescue StandardError => e
        Rails.logger.error("[HEALTH CHECK] Database error: #{e.message}")
        { status: 'ERROR' }
      end
    end
  end
end
