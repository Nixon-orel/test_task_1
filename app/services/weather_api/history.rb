# frozen_string_literal: true

module WeatherApi
  class History < Base

    def perform
      responce = connection.get(right_path(true))
      transform_responce(parsed_responce(responce))
    end

    private

    def transform_responce(responce)
      result_array = []
      responce.each do |hour|
        result_array << {hour['LocalObservationDateTime'] => hour['Temperature']['Metric']['Value']}
      end
      result_array
    end
  end
end