require "./twcrl/*"
require "oauth"

def consumer_key
  "your consumer key"
end

def consumer_secret
  "your consumer secret"
end

consumer = OAuth::Consumer.new("api.twitter.com", consumer_key, consumer_secret)
request_token = consumer.get_request_token
authorize_uri = consumer.get_authorize_uri(request_token)
puts authorize_uri

oauth_verifier = gets
if oauth_verifier
  access_token = consumer.get_access_token(request_token, oauth_verifier)
  http_client = HTTP::Client.new("api.twitter.com", tls: true)
  consumer.authenticate(http_client, access_token)

  path = "/1.1/followers/ids.json"
  response = http_client.get(path)
  puts response.body
end

