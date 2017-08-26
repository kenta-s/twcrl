require "oauth"

module Twcrl
  class OauthClient
    def initialize(@http_client : HTTP::Client, @consumer_key : String, @consumer_secret : String, @request_token : OAuth::RequestToken? = nil, @consumer : OAuth::Consumer? = nil, @authorize_uri : String? = nil)
    end

    def authorize! : Void
      access_token = obtain_access_token
      consumer.authenticate(@http_client, access_token) if access_token
    end

    def obtain_access_token : OAuth::AccessToken?
      if authorize_uri.nil?
        puts "Could not obtain access token. Please make sure consumer_key, consumer_secret, and PIN code are correct."
      else
        puts "Go to \n#{authorize_uri}\nAnd enter the PIN:\n"

        oauth_verifier = gets
        if oauth_verifier
          consumer.get_access_token(request_token, oauth_verifier)
        else
          raise "Could not obtain access token. Please make sure consumer_key, consumer_secret, and PIN code are correct."
        end
      end
    end

    def consumer : OAuth::Consumer
      @consumer ||= OAuth::Consumer.new("api.twitter.com", @consumer_key, @consumer_secret)
    end

    def request_token : OAuth::RequestToken
      @request_token ||= consumer.get_request_token
    end

    def authorize_uri : String?
      @authorize_uri ||= consumer.get_authorize_uri(request_token)
    rescue
      nil
    end
  end
end
