require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class TeamSnap < OmniAuth::Strategies::OAuth2
      option :name, :teamsnap
      option :authorize_options, [:scope]

      option :client_options, {
        :site => "https://auth.teamsnap.com",
        :authorize_url => "/oauth/authorize",
        :token_method => :post
      }

      uid { parse_datum("id") }

      info do
        {
          :email => parse_datum("email"),
          :first_name => parse_datum("first_name"),
          :last_name => parse_datum("last_name")
        }
      end

      def raw_info
        @raw_info ||= get_raw_info
      end

      private

      def get_raw_info
        # TeamSnap /me endpoint is not compatible with standard oauth2
        # access_token.get(url).parsed calls because oauth2 doesn't parse
        # responses with Content-Type: application/vnd.collection+json
        response = client.connection.get do |req|
          req.url "https://api.teamsnap.com/v3/me"
          req.headers["Authorization"] = "Bearer #{access_token.token}"
        end
        collection_json = JSON.parse(response.body)

        collection_json["collection"]["items"].first.fetch("data")
      end

      def parse_datum(property)
        raw_info.find { |d| d["name"] == property }.fetch("value")
      end
    end
  end
end

OmniAuth.config.add_camelization 'teamsnap', 'TeamSnap'
