require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class TeamSnap < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => "https://apiv3.teamsnap.com",
        :authorize_url => "https://auth.teamsnap.com/oauth/authorize",
        #:token_url => "https://auth.teamsnap.com/oauth/token",
        :token_method => :post
      }

      def request_phase
        super
      end

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      uid { raw_info['id'].to_s }

      info do
        {
          :email => raw_info["email"],
          :name => "#{raw_info["first_name"]} #{raw_info["last_name"]}",
          :first_name => raw_info["first_name"],
          :last_name => raw_info["last_name"]
        }
      end

      extra do
        {:raw_info => raw_info}
      end

      def raw_info
        access_token.options[:mode] = :query
        @raw_info ||= access_token.get("/me").parsed
      end
    end
  end
end

OmniAuth.config.add_camelization 'teamsnap', 'TeamSnap'
