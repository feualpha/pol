# Pol [![Build Status](https://travis-ci.org/feualpha/pol.svg?branch=master)](https://travis-ci.org/feualpha/pol)

Ruby Unbounded pooling object

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pol'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pol

## Usage

```ruby
pool = Pol.new{ Object.new }
pool.with_pool do |pooled_obj|
  do_something_with(pooled_obj)
  done
end
```

you can set clear_block that called for every object in pool when the pool want to be cleared. just to make sure nothing is leaked

```ruby
pool.set_clear_block{ |pooled_obj| pooled_obj.some_method }
pool.clear_pool
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/feualpha/pol.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
