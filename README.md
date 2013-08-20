# Sonic

Sonic is a Rails engine which provides a status page for your
applications services, along with a number of tools to periodically
check those services.

## Installation

Add this line to your application's Gemfile:

    gem 'sonic'

And then execute:

    $ rails g sonic

## Usage

Sonic is configured via a simple DSL. Service checks are added by
updating the file in `config/intializers/sonic_config.rb`

Currently three types of services can be checked, http, tcp, and amqp.

Here's an example sonic_config.rb file

```ruby
module Sonic
  checks = []

  checks << Sonic.service_checker do
    protocol :http
    host 'myhttpserver'
    port 80
    path 'path/to/check'
  end

  checks << Sonic.service_checker do
    protocol :amqp
    host 'myrabbitmqserver'
    port 5672
  end

  checks << Sonic.service_checker do
    protocol :tcp
    host 'mytcpserver'
    port 12345
    payload 'some command'
  end

  SONIC_CHECKS = checks
end
```

Sonic also comes with a Clockwork clock file that can be executed that
will check the configured services every 3 mintues. This file can be
executed via your Procfile or whatever daemonizer your using. For
example you could add this to your Profile

    sonic_clock:  bundle exec clockwork lib/sonic_clock.rb

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
