require "spec_helper"
require "omniauth-teamsnap"

describe OmniAuth::Strategies::TeamSnap do
  subject do
    OmniAuth::Strategies::TeamSnap.new(nil, @options || {}).tap do |strategy|
    end
  end

  describe "#client" do
    it "should have the correct TeamSnap site" do
      expect(subject.client.site).to eq("https://auth.teamsnap.com")
    end

    it "should have the correct authorization url" do
      expect(subject.client.options[:authorize_url]).to eq("/oauth/authorize")
    end
  end
end
