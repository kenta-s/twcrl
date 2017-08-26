require "option_parser"

module Twcrl
  class OptionHandler
    getter consumer_key : String
    getter consumer_secret : String

    def initialize
      args = ARGV
      command = args.shift
      @consumer_key = ""
      @consumer_secret = ""

      parse(args)
      if command == "authorize"
        authorize
      else
        get(command)
      end
    end

    def parse(args)
      OptionParser.parse(args) do |parser|
        parser.banner = <<-USAGE
        Usage: twcrl authorize --consumer-key key --consumer-secret secret
               twcrl [options] /1.1/statuses/home_timeline.json
        USAGE
        parser.on("-c key", "--consumer-key key", "consumer key") do |key|
          @consumer_key = key
        end
        parser.on("-s secret", "--consumer-secret secret", "consumer secret") do |secret|
          @consumer_secret = secret
        end
        parser.on("-h", "--help", "Show this help") { puts parser }
      end
    end

    def authorize
      oauth_client = Twcrl::OauthClient.new(client, @consumer_key, @consumer_secret)
      access_token = oauth_client.authorize!

      unless access_token.nil?
        rc = Twcrl::RcfileHandler.new
        rc.set_default_profile("kenta_s_dev", consumer_key)
        rc.set_profile("kenta_s_dev", consumer_key, consumer_secret, access_token.token, access_token.secret)
      end
    end

    def get(path)
      # path = "/1.1/followers/ids.json"
      access_token = OAuth::AccessToken.new(rc.access_token, rc.access_token_secret)
      consumer.authenticate(client, access_token)
      response = client.get(path)
      puts response.body
    end

    def rc
      @rc ||= Twcrl::RcfileHandler.new
    end

    def client
      @client ||= HTTP::Client.new("api.twitter.com", tls: true)
    end

    def consumer
      @consumer ||= OAuth::Consumer.new("api.twitter.com", rc.consumer_key, rc.consumer_secret)
    end
  end
end
