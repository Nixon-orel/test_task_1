# frozen_string_literal: true

class WeatherHistory < ApplicationRecord

  scope :record_with_expected_date, ->(date) { where("Date(created_at) = ?", "#{date}") }

  def histories_hours_with_index
    history ? history.map.with_index { |hour, index| { Time.parse(hour.keys.first) => index } } : nil
  end
end