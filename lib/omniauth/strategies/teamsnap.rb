require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class TeamSnap < OmniAuth::Strategies::OAuth2
      option :name, :teamsnap

      option :client_options, {
        :site => "https://auth.teamsnap.com",
        :authorize_url => "/oauth/authorize",
        :token_method => :post
      }

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      uid { raw_info["id"] }

      info do
        {
          :email => raw_info["email"],
          :first_name => raw_info["first_name"],
          :last_name => raw_info["last_name"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get("https://apiv3.teamsnap.com/me").parsed
      end
    end
  end
end
