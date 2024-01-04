# frozen_string_literal: true

module WeatherApi
  class Base

    WEATHER_API_URL = 'http://dataservice.accuweather.com/currentconditions/v1/'
    CITY_KEY = ENV['CITY_KEY']
    WEATHER_API_KEY = ENV['WEATHER_API_KEY']

    def self.perform
      new.perform
    end

    def perform
      responce = connection.get(right_path(false))
      parsed_responce(responce).first['Temperature']['Metric']['Value']
    end

    private

    def connection
      Faraday.new(
        request: {
          timeout: 4
        }
      )
    end

    def right_path(history)
      with_history = "#{WEATHER_API_URL}#{CITY_KEY}/historical/24?apikey=#{WEATHER_API_KEY}&details=true"
      without_history = "#{WEATHER_API_URL}#{CITY_KEY}?apikey=#{WEATHER_API_KEY}"
      history ? with_history : without_history
    end

    def parsed_responce(responce)
      JSON.parse(responce.body)
    end
  end
end