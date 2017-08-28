require "../spec_helper"

describe Twcrl::OauthClient do
  oauth_client = Twcrl::OauthClient.new(HTTP::Client.new("api.twitter.com", tls: true), "the_consumer_key", "the_consumer_secret")

  describe "#authorize!" do
  end

  describe "#obtain_access_token" do
  end

  describe "#consumer" do
    it "returns OAuth::Consumer" do
      oauth_client.consumer.should be_a OAuth::Consumer
    end
  end

  describe "#request_token" do
  end

  describe "#authorize_uri" do
  end
end
