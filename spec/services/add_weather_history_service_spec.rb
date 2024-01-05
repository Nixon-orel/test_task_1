# frozen_string_literal: true

require "rails_helper"

RSpec.describe AddWeatherHistoryService do
  describe '.perform' do
    subject(:perform) { described_class.perform }

    before do
      allow(WeatherApi::History).to receive(:perform).and_return([])
    end

    it 'WeatherApi::History calls perform' do
      expect(WeatherApi::History).to receive(:perform)
      perform
    end

    it 'described_class calls check_or_create_today_histories!' do
      expect(described_class).to receive(:check_or_create_today_histories!).with([])
      perform
    end

    it 'described_class calls check_or_create_yesterday_histories!' do
      expect(described_class).to receive(:check_or_create_yesterday_histories!).with([])
      perform
    end
  end

  describe '.check_or_create_today_histories!' do
    subject(:check_or_create_today_histories) { described_class.check_or_create_today_histories!(histories) }

    context 'when histories blank' do
      let(:histories) { [] }

      it 'returns nil' do
        expect(check_or_create_today_histories).to be_nil
      end
    end

    context 'when database has not WeatherHistory with date today' do
      let(:histories) { [{ Time.now.utc.to_s => 5.1}] }

      before do
        allow(described_class).to receive(:parse_date).with(histories, Date.today).and_return(histories)
      end

      it 'WeatherHistory calls create! with expected arguments' do
        expect(WeatherHistory).to receive(:create!).with(history: histories)
        check_or_create_today_histories
      end
    end

    context 'when database has WeatherHistory with date today' do
      let(:histories) { [{ Time.now.utc.to_s => 5.1}] }
      let(:history_for_model) { [{ (Time.now.utc - 1.hour).to_s => 5.5 }] }
      let(:result_history) { [history_for_model, histories].flatten }

      before do
        create(:weather_history, history: history_for_model)
        allow(described_class).to receive(:parse_date).with(histories, Date.today).and_return(histories)
      end

      it 'WeatherHistory calls create! with expected arguments' do
        check_or_create_today_histories
        expect(WeatherHistory.first.history).to eq(result_history)
      end
    end
  end

  describe '.check_or_create_yesterday_histories!' do
    subject(:check_or_create_yesterday_histories) { described_class.check_or_create_yesterday_histories!(histories) }

    context 'when histories blank' do
      let(:histories) { [] }

      it 'returns nil' do
        expect(check_or_create_yesterday_histories).to be_nil
      end
    end

    context 'when database has not WeatherHistory with date today' do
      let(:histories) { [{ (Time.now.utc - 1.day).to_s => 5.1}] }
      let(:day_ago) { 1.day.ago }

      before do
        allow(described_class).to receive(:parse_date).with(histories, Date.yesterday).and_return(histories)
        allow_any_instance_of(ActiveSupport::Duration).to receive(:ago).and_return(day_ago)
      end

      it 'WeatherHistory calls create! with expected arguments' do
        expect(WeatherHistory).to receive(:create!).with(history: histories, created_at: day_ago)
        check_or_create_yesterday_histories
      end
    end

    context 'when database has WeatherHistory with date today' do
      let(:histories) { [{ (Time.now.utc - 1.day).to_s => 5.1}] }
      let(:history_for_model) { [{ (Time.now.utc - 25.hour).to_s => 5.5 }] }
      let(:result_history) { [history_for_model, histories].flatten }

      before do
        create(:weather_history, history: history_for_model, created_at: 1.day.ago)
        allow(described_class).to receive(:parse_date).with(histories, Date.yesterday).and_return(histories)
      end

      it 'WeatherHistory calls create! with expected arguments' do
        check_or_create_yesterday_histories
        expect(WeatherHistory.first.history).to eq(result_history)
      end
    end
  end

  describe '.convert_to_utc' do
    subject(:convert_to_utc) { described_class.convert_to_utc(histories) }
    let(:histories) { [{"2024-01-04 23:02:00 +0300" => 5.1},
                       {"2024-01-04 22:02:00 +0300" => 5.3}] }
    let(:expected_response) { [{ Time.parse('2024-01-04 20:02:00 +0000') => 5.1 },
                               { Time.parse('2024-01-04 19:02:00 +0000') => 5.3 }] }

    it 'returns time in hash in UTC' do
      expect(convert_to_utc).to eq(expected_response)
    end
  end
end