# frozen_string_literal: true

module WeatherApi
  class Avg < Base

    def perform
      responce = connection.get(right_path(true))
      transform_responce(parsed_responce(responce))
    end

    private

    def transform_responce(responce)
      temperature = responce.map do |weather_record|
        weather_record['Temperature']['Metric']['Value']
      end
      (temperature.sum / temperature.size).round(1)
    end
  end
end