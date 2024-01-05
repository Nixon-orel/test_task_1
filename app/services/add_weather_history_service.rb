# frozen_string_literal: true

module AddWeatherHistoryService
  module_function

  def perform
    histories = WeatherApi::History.perform

    check_or_create_today_histories!(histories)
    check_or_create_yesterday_histories!(histories)
  end
  handle_asynchronously :perform

  def check_or_create_today_histories!(histories)
    return if histories.blank?

    weather_history_today = WeatherHistory.record_with_expected_date(Time.now).first
    today_histories = parse_date(histories, Date.today)

    if weather_history_today.present?
      check_histories!(weather_history_today, today_histories)
    else
      WeatherHistory.create!(history: today_histories)
    end
  end

  def check_histories!(weather_history, histories)
    histories.each do |hour|
      next if weather_history.history.include?(hour)

      weather_history.history << hour
      weather_history.save
    end
  end

  def check_or_create_yesterday_histories!(histories)
    return if histories.blank?

    weather_history_yesterday = WeatherHistory.record_with_expected_date(Time.now - 1.day).first
    yesterday_histories = parse_date(histories, Date.yesterday)

    if weather_history_yesterday.present?
      check_histories!(weather_history_yesterday, yesterday_histories)
    else
      WeatherHistory.create!(history: yesterday_histories, created_at: 1.day.ago)
    end
  end

  def parse_date(histories, date)
    convert_to_utc(histories).select {|record| record.keys.first.to_date == date}
  end

  def convert_to_utc(histories)
    histories.map do |history|
      history.map { |time, temp| { Time.parse(time).utc => temp } }
    end.flatten
  end
end

