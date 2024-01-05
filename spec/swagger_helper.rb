# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ],
      components: {
        schemas: {
          weather_current: {
            type: :object,
            properties: {
              current_temperature: { type: :float,
                                     example: 3.1 }
            }
          },
          weather_max: {
            type: :object,
            properties: {
              maximum_temperature_over_24_hours: { type: :float,
                                                   example: 3.1 }
            }
          },
          weather_min: {
            type: :object,
            properties: {
              minimum_temperature_over_24_hours: { type: :float,
                                                   example: 3.1 }
            }
          },
          weather_avg: {
            type: :object,
            properties: {
              average_temperature_over_24_hours: { type: :float,
                                                   example: 3.1 }
            }
          },
          weather_by_time_ok: {
            type: :object,
            properties: {
              temperature: { type: :float,
                             example: 3.0 },
              time: { type: :string,
                      example: '2024-01-03 12:23:31 +0000' }
            }
          },
          weather_by_time_not_found: {
            type: :object,
            properties: {
              error: { type: :string,
                       example: '404 Not Found'}
            }
          },
          health: {
            type: :string,
            example: 'ok'
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
