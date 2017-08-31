# twcrl

curl like CLI for Twitter API. Inspired by Twurl.

## Installation

```
$ git clone git@github.com:kenta-s/twcrl.git
$ cd twcrl
$ crystal build src/twcrl.cr --release
```

## Usage

Authorize the app
```
$ ./twcrl authorize --consumer-key key --consumer-secret secret
```

Make GET request
```
$ ./twcrl /1.1/home_timeline.json
```

Make POST request
```
$ ./twcrl /1.1/statuses/update.json -x post -d "hello"
```

## Contributing

1. Fork it ( https://github.com/kenta-s/twcrl/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [kenta-s](https://github.com/kenta-s) kenta-s - creator, maintainer
