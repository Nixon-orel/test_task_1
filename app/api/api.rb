# frozen_string_literal: true
module Api
  class Api < Grape::API
    format :json

    helpers do
      def find_history_by_time(time)
        FindHistoryFromTimeService.find_history_from_time(time)
      end

      def not_found
        error!('404 Not Found', 404)
      end
    end

    resource :weather do
      desc 'Return curren temperature'
      get :current do
        { current_temperature: Rails.cache.read('current_temperature')}
      end

      desc 'Return max temperature over 24 hours'
      get :max do
        { maximum_temperature_over_24_hours: Rails.cache.read('max_temperature')}
      end

      desc 'Return min temperature over 24 hours'
      get :min do
        { minimum_temperature_over_24_hours: Rails.cache.read('min_temperature')}
      end

      desc 'Return average temperature over 24 hours'
      get :avg do
        { average_temperature_over_24_hours: Rails.cache.read('avg_temperature')}
      end

      desc 'Return nearest temperature to send timestamp'
      params do
        requires :time, type: Integer
      end
      get :by_time do
        hash = find_history_by_time(params[:time]).to_a.flatten
        not_found unless hash.present?
        { temperature: hash.last, time: hash.first }
      end
    end

    resource :health do
      desc 'Return ok'
      get do
        :ok
      end
    end
  end
end