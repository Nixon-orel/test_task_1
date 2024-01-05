# frozen_string_literal: true

module RequestHelpers
  def parsed_response
    JSON.parse(response.body)
  end
end