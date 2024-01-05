# frozen_string_literal: true

require "rails_helper"

RSpec.describe WeatherApi::History do
  describe '#perform' do
    subject(:perform) { described_class.new.perform }

    let(:response) { double(body: body) }
    let(:body) { ([{ 'LocalObservationDateTime': date_1, 'Temperature': {'Metric': {'Value': value_1 } } },
                  { 'LocalObservationDateTime': date_2, 'Temperature': {'Metric': {'Value': value_2 } } }]).to_json }
    let(:value_1) { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    let(:value_2) { Faker::Number.decimal(l_digits: 1, r_digits: 1) }
    let(:date_1) { Faker::Time.forward }
    let(:date_2) { Faker::Time.forward }
    let(:expected_responce) { [{ JSON.parse(date_1.to_json) => value_1 },
                               { JSON.parse(date_2.to_json) => value_2 }] }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)
    end

    it 'returns correct value' do
      expect(perform).to eq(expected_responce)
    end
  end
end