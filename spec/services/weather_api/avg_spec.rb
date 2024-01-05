# frozen_string_literal: true

require "rails_helper"

RSpec.describe WeatherApi::Avg do
  describe '#perform' do
    subject(:perform) { described_class.new.perform }

    let(:response) { double(body: body) }
    let(:body) { ([{ 'Temperature':
                       {'Metric':
                          {'Value': value_1 }
                       }
                   },
                   { 'Temperature':
                       {'Metric':
                          {'Value': value_2 }
                       }
                   }]).to_json }
    let(:value_1) { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    let(:value_2) { Faker::Number.decimal(l_digits: 1, r_digits: 1) }
    let(:avg) { ((value_1 + value_2)/2).round(1) }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)
    end

    it 'returns correct value' do
      expect(perform).to eq(avg)
    end
  end
end