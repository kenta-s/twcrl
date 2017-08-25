require "./twcrl/*"

cli = Twcrl::OauthClient.new("consumer key", "consumer secret")
access_token = cli.obtain_access_token
token = access_token.token
secret = access_token.secret

