require 'httparty'

module Everscreen
  class Request
    def search(zip_code)
      handle_response(call_api("search/#{zip_code}"))
    end

    def near(location, radius)
      handle_response(call_api("near", { location: location, radius: radius }))
    end

    private

    def handle_response(resp)
      if resp.ok?
        resp.parsed_response
      else
        raise Everscreen::Error.new(resp.parsed_response['message'])
      end
    end

    def call_api(path, params={})
      HTTParty.get(url(path), headers: headers, query: params)
    end

    def url(path)
      "#{Everscreen.configuration.url}/#{path}"
    end

    def headers
      { "X-AUTH-TOKEN" => Everscreen.configuration.auth_token }
    end
  end
end
