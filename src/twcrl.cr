require "./twcrl/*"

consumer_key = ENV["TWITTER_KEY"] # TODO: get the key from STDIN
consumer_secret = ENV["TWITTER_SECRET"] # TODO: get the secret from STDIN
client = HTTP::Client.new("api.twitter.com", tls: true)
cli = Twcrl::OauthClient.new(client, consumer_key, consumer_secret)
access_token = cli.authorize!

unless access_token.nil?
  rc = Twcrl::RcfileHandler.new
  rc.set_default_profile("kenta_s_dev", consumer_secret)
  rc.set_profile("kenta_s_dev", consumer_key, consumer_secret, access_token.token, access_token.secret)

  # examples:
  #
  # path = "/1.1/followers/ids.json"
  # response = client.get(path)
  # puts response.body
end
