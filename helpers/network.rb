# frozen_string_literal: true

require 'httparty'
# Module that rightly might be extended with more network request types.
module Network
  def http_request(url)
    puts url
    response = HTTParty.get(url)
    return response.body unless response.code == :ok

    abort("Invalid request response: Code #{response.code}")
  end
end
