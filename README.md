# RailsMonitoringEngine
This engine provides NewRelic-like functionality to rails apps.

I wanted to be able to monitor my rails applicaiton performance without
having to pay someone or sending telemetry data outside my network.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rails_monitoring_engine'
```

And then execute:
```bash
$ bundle install --path vendor/bundle --clean
```

## Testing

I'm aiming for 100% test coverage so I feel more confident
when making changes.

```bash
rails app:coverage
```

To see the coverage detail report start the server and go to: http://localhost:3000/coverage/

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
