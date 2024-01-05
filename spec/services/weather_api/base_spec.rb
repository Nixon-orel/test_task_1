# frozen_string_literal: true

require "rails_helper"

RSpec.describe WeatherApi::Base do
  describe '#perform' do
    subject(:perform) { described_class.new.perform }

    let(:response) { double(body: ([{'Temperature': {'Metric': {'Value': value } } }]).to_json)}
    let(:value) { Faker::Number.decimal(l_digits: 2, r_digits: 2) }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)
    end

    it 'returns corret value' do
      expect(perform).to eq(value)
    end
  end

  describe '#right_path' do
    subject(:right_path) { described_class.new.send(:right_path, history) }

    let(:api_url) { Faker::String.random }
    let(:city_id) { Faker::String.random }
    let(:api_key) { Faker::String.random }

    before do
      stub_const('WeatherApi::Base::WEATHER_API_URL', api_url)
      stub_const('WeatherApi::Base::CITY_KEY', city_id)
      stub_const('WeatherApi::Base::WEATHER_API_KEY', api_key)
    end

    context 'when history equals true' do
      let(:history) { true }
      let(:expected_path) { "#{api_url}#{city_id}/historical/24?apikey=#{api_key}&details=true" }

      it 'returns expected path' do
        expect(right_path).to eq(expected_path)
      end
    end

    context 'when history equals true' do
      let(:history) { false }
      let(:expected_path) { "#{api_url}#{city_id}?apikey=#{api_key}" }

      it 'returns expected path' do
        expect(right_path).to eq(expected_path)
      end
    end
  end
end
