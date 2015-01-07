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

      uid { raw_info.find { |d| d.name == "id"}.value }

      info do
        {
          :email => raw_info.find { |d| d.name == "email"}.value,
          :first_name => raw_info.find { |d| d.name == "first_name"}.value,
          :last_name => raw_info.find { |d| d.name == "last_name"}.value
        }
      end

      def raw_info
        return @raw_info if @raw_info

        # TeamSnap /me endpoint is not compatible with standard oauth2
        # access_token.get(url).parsed calls because oauth2 doesn't parse
        # responses with Content-Type: application/vnd.collection+json
        response = client.connection.get do |req|
          req.url "https://api.teamsnap.com/v3/me"
          req.headers["Authorization"] = "Bearer #{access_token.token}"
        end
        deserializer = Conglomerate::TreeDeserializer.new(JSON.parse(response.body))
        collection_json = deserializer.deserialize

        @raw_info = collection_json.items.first.data
      end

    end
  end
end

OmniAuth.config.add_camelization 'teamsnap', 'TeamSnap'
