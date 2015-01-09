# Opal: Async

## Installation

Add this line to your application's Gemfile:

    gem 'opal-async', github: "ravenstine/opal-async

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install opal-async


## Usage

The enumerator provides basic iteration methods for any enumerable object.  These methods use intervals and timeouts to iterate without blocking the rest of the call stack.  

When the enumerator is finished, a promise is executed using the done method.

For example:

```ruby
require 'opal-async'
enumerator = Async::Enumerator.new([1,2,3,4,5,6,7,8,9])
enumerator.map{|x| x + 2}.done{|x| puts x}
#=> [3,4,5,6,7,8,9,10,11]
```
To continue with another enumerator, use 'then' instead of done.
```ruby
enumerator = Async::Enumerator.new([1,2,3,4,5,6,7,8,9])
enumerator.map{|x| x + 2}.then{|x| x.each_slice(3).done{|z| puts z}}
#=> [[3,4,5],[6,7,8],[9,10,11]]
```

### Available enumerator methods:
- each
- map
- each_slice