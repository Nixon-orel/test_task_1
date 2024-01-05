# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'weather', type: :request do
  path '/weather/current' do
    get :current do
      tags 'current'
      consumes 'application/json'

      let(:temp) { Faker::Number.decimal(l_digits: 2, r_digits: 2)}

      before do
        allow(Rails.cache).to receive(:read).with('current_temperature').and_return(temp)
      end

      response '200', 'return current temperature' do
        schema '$ref' => '#/components/schemas/weather_current'
        run_test!(openapi_strict_schema_validation: true) do
          expect(parsed_response['current_temperature']).to eq(temp)
        end
      end
    end
  end

  path '/weather/max' do
    get :max do
      tags 'max'
      consumes 'application/json'

      let(:temp) { Faker::Number.decimal(l_digits: 2, r_digits: 2)}

      before do
        allow(Rails.cache).to receive(:read).with('max_temperature').and_return(temp)
      end

      response '200', 'return max temperature' do
        schema '$ref' => '#/components/schemas/weather_max'
        run_test!(openapi_strict_schema_validation: true) do
          expect(parsed_response['maximum_temperature_over_24_hours']).to eq(temp)
        end
      end
    end
  end

  path '/weather/min' do
    get :min do
      tags 'min'
      consumes 'application/json'

      let(:temp) { Faker::Number.decimal(l_digits: 2, r_digits: 2)}

      before do
        allow(Rails.cache).to receive(:read).with('min_temperature').and_return(temp)
      end

      response '200', 'return min temperature' do
        schema '$ref' => '#/components/schemas/weather_min'
        run_test!(openapi_strict_schema_validation: true) do
          expect(parsed_response['minimum_temperature_over_24_hours']).to eq(temp)
        end
      end
    end
  end

  path '/weather/avg' do
    get :avg do
      tags 'avg'
      consumes 'application/json'

      let(:temp) { Faker::Number.decimal(l_digits: 2, r_digits: 2)}

      before do
        allow(Rails.cache).to receive(:read).with('avg_temperature').and_return(temp)
      end

      response '200', 'return avg temperature' do
        schema '$ref' => '#/components/schemas/weather_avg'
        run_test!(openapi_strict_schema_validation: true) do
          expect(parsed_response['average_temperature_over_24_hours']).to eq(temp)
        end
      end
    end
  end

  path '/weather/by_time' do
    get :by_time do
      tags 'by_time'
      consumes 'application/json'
      parameter name: :time, in: :query, type: :integer

      context 'when sent time present in database' do
        let(:time) { time_now.to_i }
        let(:time_now) { Time.now }
        let(:history) { [{ (time_now - 1.hour).to_s => 5.1 },
                         { (time_now - 2.hour).to_s => 6.1 },
                         { (time_now - 3.hour).to_s => 6.1 },
                         { (time_now + 2.hour).to_s => 7.3 },
                         { (time_now + 3.hour).to_s => 7.9 },
                         expected_history] }
        let(:expected_history) { { (time_now - 30.minutes).to_s => 6.4 } }
        let(:expected_response) { { 'temperature' => expected_history.values.first, 'time' => expected_history.keys.first } }

        before do
          create(:weather_history, history: history)
        end

        response '200', 'return by_time hash' do
          schema '$ref' => '#/components/schemas/weather_by_time_ok'
          run_test!(openapi_strict_schema_validation: true) do
            expect(parsed_response).to eq(expected_response)
          end
        end
      end

      context 'when no sent time in database' do
        let(:time) { Time.now.to_i }
        let(:error) { { "error" => "404 Not Found" } }

        before do
          create(:weather_history, history: [{ (Time.now - 1.day).to_s => 6.4 }], created_at: Date.yesterday)
        end

        response '404', 'return error 404' do
          schema '$ref' => '#/components/schemas/weather_by_time_not_found'
          run_test!(openapi_strict_schema_validation: true) do
            expect(parsed_response).to eq(error)
          end
        end
      end
    end
  end

  path '/health' do
    get :health do
      tags 'health'
      consumes 'application/json'

      response '200', 'return ok' do
        schema '$ref' => '#/components/schemas/health'
        run_test!(openapi_strict_schema_validation: true) do
          expect(parsed_response).to eq('ok')
        end
      end
    end
  end
end