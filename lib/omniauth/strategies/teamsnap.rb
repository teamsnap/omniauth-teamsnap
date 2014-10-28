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

        # TeamSnap /me endpoint is not compatible with standard oauth2 access_token.get(url).parsed calls
        # 1) oauth2 doesn't parse response with Content-Type: application/vnd.collection+json
        # 2) TeamSnap api uses custom X-Teamsnap-Access-Token header, no way to specify this oauth2 request
        response = client.connection.get do |req|
          req.url "https://apiv3.teamsnap.com/me"
          req.headers["X-Teamsnap-Access-Token"] = access_token.token
        end
        deserializer = Conglomerate::TreeDeserializer.new(JSON.parse(response.body))
        collection_json = deserializer.deserialize

        @raw_info = collection_json.items.first.data
      end

    end
  end
end

OmniAuth.config.add_camelization 'teamsnap', 'TeamSnap'
