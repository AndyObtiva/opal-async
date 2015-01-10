# Opal: Async

## Installation

Add this line to your application's Gemfile:

    gem 'opal-async', github: "ravenstine/opal-async

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install opal-async


## Usage

The enumerator provides basic iteration methods for any enumerable object.  These methods are 'non-blocking' but can be chained.    

When the enumerator is finished, a promise is executed using #done.

For example:

```ruby
require 'opal-async'
enumerator = Async::Enumerator.new([1,2,3,4,5,6,7,8,9])
enumerator.map{|x| x + 2}.done{|x| puts x}
#=> [3,4,5,6,7,8,9,10,11]
```

Here's an example of method-chaining:
```ruby
enumerator = Async::Enumerator.new([1,2,3,4,5,6,7,8,9])
enumerator.map{|x| x + 2}.then{|x| x.each_slice(3).each{|x| puts x}
#=> [3,4,5]
#=> [6,7,8]
#=> [9,10,11]
```

### Available enumerator methods:
- each
- map
- each_slice

You can also use the timers that the enumerator uses:


```
Timeout.new 3000 do
  puts "I just waited 3 seconds."
end
```

```
Interval.new 3000 do
  puts "I'm going to do this every 3 seconds."
end
```

```
Countdown.new 3000, 5 do |cdown|
  puts "#{cdown} bottles of beer."
end

#=> 5 bottles of beer.
#=> 4 bottles of beer.
#=> 3 bottles of beer.
#=> 2 bottles of beer.
#=> 1 bottles of beer.
```
