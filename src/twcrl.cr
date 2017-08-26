require "./twcrl/*"

client = HTTP::Client.new("api.twitter.com", tls: true)
cli = Twcrl::OauthClient.new(client, ENV["TWITTER_KEY"], ENV["TWITTER_SECRET"])
cli.authorize!

# examples:
#
# path = "/1.1/followers/ids.json"
# response = client.get(path)
# puts response.body
