# frozen_string_literal: true

module AddDataToCacheService
  module_function

  def current
    Rails.cache.write('current_temperature', WeatherApi::Base.perform)
  end
  handle_asynchronously :current

  def min
    Rails.cache.write('min_temperature', WeatherApi::Min.perform)
  end
  handle_asynchronously :min

  def max
    Rails.cache.write('max_temperature', WeatherApi::Max.perform)
  end
  handle_asynchronously :max

  def avg
    Rails.cache.write('avg_temperature', WeatherApi::Avg.perform)
  end
  handle_asynchronously :avg
end