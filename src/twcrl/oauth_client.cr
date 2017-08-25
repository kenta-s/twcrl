require "oauth"

module Twcrl
  class OauthClient
    def initialize(@consumer_key : String, @consumer_secret : String, @request_token : OAuth::RequestToken? = nil, @consumer : OAuth::Consumer? = nil)
    end

    def obtain_access_token : OAuth::AccessToken
      puts "Go to \n#{authorize_uri}\nAnd enter the PIN:\n"

      oauth_verifier = gets
      if oauth_verifier
        consumer.get_access_token(request_token, oauth_verifier)
        # http_client = HTTP::Client.new("api.twitter.com", tls: true)
        # consumer.authenticate(http_client, access_token)
      
        # path = "/1.1/followers/ids.json"
        # response = http_client.get(path)
        # puts response.body
      else
        raise "Could not obtain access token. Please make sure consumer_key, consumer_secret, and PIN code are correct."
      end
    end

    def consumer : OAuth::Consumer
      @consumer ||= OAuth::Consumer.new("api.twitter.com", @consumer_key, @consumer_secret)
    end

    def request_token : OAuth::RequestToken
      @request_token ||= consumer.get_request_token
    end

    def authorize_uri : String
      consumer.get_authorize_uri(request_token)
    end
  end
end


