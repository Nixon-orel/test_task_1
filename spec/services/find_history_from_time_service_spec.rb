# frozen_string_literal: true

require "rails_helper"

RSpec.describe FindHistoryFromTimeService do
  describe '.perform' do
    subject(:perform) { described_class.perform(time) }

    context 'when no sent date in database' do
      let(:time) { Time.now.to_i }

      before do
        create(:weather_history, history: [{ Time.now.utc.to_s => 5.1}], created_at: Time.now - 2.day)
      end

      it 'returns nil' do
        expect(perform).to be_nil
      end
    end

    context 'when sent date present in database' do
      let(:time_now) { Time.now.utc }
      let(:time) { time_now.to_i }
      let(:history) { [{ (time_now - 1.hour).to_s => 5.1 },
                       { (time_now - 2.hour).to_s => 6.1 },
                       { (time_now - 3.hour).to_s => 6.1 },
                       { (time_now + 2.hour).to_s => 7.3 },
                       { (time_now + 3.hour).to_s => 7.9 },
                       expected_responce] }
      let(:expected_responce) { { (time_now - 30.minutes).to_s => 6.4 } }

      before do
        create(:weather_history, history: history, created_at: Time.now)
      end

      it 'returns closest hash' do
        expect(perform).to eq(expected_responce)
      end
    end
  end
end