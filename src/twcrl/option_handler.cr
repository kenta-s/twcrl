require "option_parser"

module Twcrl
  class OptionHandler
    getter consumer_key : String
    getter consumer_secret : String
    getter option_parser : OptionParser?

    property http_method : String

    def initialize
      args = ARGV
      @consumer_key = ""
      @consumer_secret = ""
      @http_method = "get"
      @option_parser = nil
      @params = ""

      if args.any?
        command = args.shift
      else
        command = ""
      end

      parse(args)

      if command == "authorize"
        parse(args)
        authorize
      elsif /\/.*/.match(command)
        call_api(command)
      else
        puts @option_parser
      end
    end

    def parse(args)
      @option_parser = OptionParser.parse(args) do |parser|
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

        parser.on("-x method", "--request-method method", "HTTP method(default: GET)") do |method|
          @http_method = method
        end

        parser.on("-d data", "--data data", "parameters used in a POST request") do |data|
          @params = data
        end

        parser.on("-h", "--help", "Show this help") { puts parser }
      end
    end

    def authorize
      oauth_client = Twcrl::OauthClient.new(client, @consumer_key, @consumer_secret)
      access_token = oauth_client.authorize!

      unless access_token.nil?
        rc = Twcrl::RcfileHandler.new
        screen_name = access_token.extra["screen_name"]
        rc.set_default_profile(screen_name, consumer_key)
        rc.set_profile(screen_name, consumer_key, consumer_secret, access_token.token, access_token.secret)
      end
    end

    def call_api(path)
      access_token = OAuth::AccessToken.new(rc.access_token, rc.access_token_secret)
      consumer.authenticate(client, access_token)
      case @http_method
      when "get"
        response = client.get(path)
        puts response.body
      when "post"
        response = client.post_form(path, @params)
        puts response.body
      else
        raise "Invalid HTTP method: #{@http_method}"
      end
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
