# frozen_string_literal: true

require "rails_helper"

RSpec.describe WeatherHistory do
  describe '#histories_hours_with_index' do
    subject(:histories_hours_with_index) { weather_history.histories_hours_with_index }

    let(:weather_history) { create :weather_history }
    let(:random_record) { weather_history.history.sample }
    let(:index) { weather_history.history.index(random_record) }
    let(:timestamp) { Time.parse(random_record.keys.first).utc }

    it 'returns expected hash' do
      expect((histories_hours_with_index).size).to eq(24)
      expect(histories_hours_with_index[index].keys.first).to eq(timestamp)
    end
  end
end