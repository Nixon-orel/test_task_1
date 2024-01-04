# frozen_string_literal: true

module WeatherApi
  class Min < Base

    def perform
      responce = connection.get(right_path(true))
      transform_responce(parsed_responce(responce))
    end

    private

    def transform_responce(responce)
      responce.first['TemperatureSummary']['Past24HourRange']['Minimum']['Metric']['Value']
    end
  end
end