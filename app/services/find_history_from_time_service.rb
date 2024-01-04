# frozen_string_literal: true

module FindHistoryFromTimeService
  module_function

  def find_history_from_time(time)
    datetime = Time.at(time.to_i)
    date = datetime.to_date
    return if WeatherHistory.pluck(:created_at).map(&:to_date).exclude?(date)

    weather_history = WeatherHistory.record_with_expected_date(date).first
    hours_records = weather_history.histories_hours_with_index
    weather_history.history[result_history_record(hours_records, datetime.to_time).values.first]
  end

  def result_history_record(hours_records, time)
    hours_records.min do |first_time, second_time|
      difference(first_time, time) <=> difference(second_time, time)
    end
  end

  def difference(value, time)
   (value.keys.first - time).abs.round(0)
  end
end