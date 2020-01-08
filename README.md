# Rails Monitoring Engine
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
$ bundle install
```

## Configuration
Add the following code:
```ruby
# config/initializers/rails_monitoring_engine.rb

  RailsMonitoringEngine.enable!
```

## Development
To set up the development environment run the following:

```bash
$ bundle install --path vendor/bundle --clean
rails db:create db:migrate
```

### Adding a Model
To add a model run the following:
```bash
rails g model <model name>
```

Edit/test your migration then annotate it via the following command:
```bash
rails app:rails_monitoring_engine::annotate_models
```

## Testing

I'm aiming for 100% test coverage so I feel more confident
when making changes.

### Coverage
To generate a coverage report execute the following:

```bash
rails app:simplecov
```
To see the coverage detail report start the server and go to: http://localhost:3000/coverage/

### Performance
To run a performance test using the Apache Benchmarking Tool start the server
in one shell via
```bash
cd test/dummy
rails server
```

Then, in another shell, execute the following:

```bash
rails app:test:performance
```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
