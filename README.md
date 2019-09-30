# Everscreen

Everscreen provides a simple client for interacting with the Mammogrammar API.
[Mammogrammar](https://github.com/jmulieri/mammogrammar) is a service that helps you to locate MQSA Certified Mammography Facilities.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'everscreen'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install everscreen

## Usage

```ruby
require 'everscreen'

Everscreen.configure do |config|
  config.url = 'http://localhost:3000'
  config.auth_token = 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX'
end

# specify zip code to find facilities
facilities = Everscreen.search('95531')

# search matches zip code by prefix, so you can specify a partial zip code 
facilities = Everscreen.search('955')

# find facilities within 10 miles of 95531
facilities = Everscreen.near('95531', 10) 

# find facilities within 1.5 miles of '1600 Divisadero St, San Francisco, CA'
facilities = Everscreen.near('1600 Divisadero St, San Francisco, CA', 1.5) 
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [Everscreen](https://github.com/jmulieri/everscreen).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
