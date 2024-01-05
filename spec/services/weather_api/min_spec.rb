# frozen_string_literal: true

require "rails_helper"

RSpec.describe WeatherApi::Min do
  describe '#perform' do
    subject(:perform) { described_class.new.perform }

    let(:response) { double(body: body) }
    let(:body) { ([{ 'TemperatureSummary':
                       { 'Past24HourRange':
                           { 'Minimum':
                               {'Metric':
                                  {'Value': value }
                               }
                           }
                       }
                   },
                   { 'TemperatureSummary':
                       { 'Past24HourRange':
                           { 'Minimum':
                               {'Metric':
                                  {'Value': value }
                               }
                           }
                       }
                   }]).to_json }
    let(:value) { Faker::Number.decimal(l_digits: 2, r_digits: 2) }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)
    end

    it 'returns correct value' do
      expect(perform).to eq(value)
    end
  end
end