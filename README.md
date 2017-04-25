# Matplotlib

This library enables to directly call [matplotlib](https://matplotlib.org/) from Ruby language.
This is built on top of [pycall](https://github.com/mrkn/pycall).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'matplotlib'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install --pre matplotlib

## Usage

### Using pyplot in irb console or standalone scripts

Example usage:

    require 'matplotlib/pyplot'
    plt = Matplotlib::Pyplot

    xs = [*1..100].map {|x| (x - 50) * Math::PI / 100.0 }
    ys = xs.map {|x| Math.sin(x) }

    plt.plot(xs, ys)
    plt.show()

### IRuby integration

`matplotlib/iruby` provides integration between IRuby notebook and matplotlib.
This functionality can be enabled by calling `Matplotlib::IRuby.activate`.

    require 'matplotlib/iruby'
    Matplotlib::IRuby.activate

`matplotlib/iruby` also loads `matplotlib/pyplot`, so you can use `Matplotlib::Pyplot` module without explicitly requireing `matplotlib/pyplot`.
And this introduces a post execution hook which put figures that are created in a cell just below the execution result of the cell.

See ipynb files in [examples](examples) to see example usages.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mrkn/matplotlib.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

