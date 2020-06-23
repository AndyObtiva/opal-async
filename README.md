# Opal: Async
[![Gem Version](https://badge.fury.io/rb/opal-async.svg)](https://badge.fury.io/rb/opal-async)

## Installation

Add this line to your application's Gemfile:

    gem 'opal-async', '~> 1.1.0'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install opal-async

Then require 'opal-async' in both your Opal code and your Opal compilation environment.


## Usage

#### Enumerator

The enumerator provides iteration methods for any enumerable object.  These methods are 'non-blocking', so other operations in the event loop can continue to be executed in between iterations.  Beware, this is not faster than a normal blocking iteration; it is trading off performance for not blocking other operations you may want to have continue such as UI updates & camera frame capture.  Very large arrays will take a long time to finish while the overhead may not be noticeable for smaller arrays.  It is best to do some tests and assess whether the trade-off is balanced enough for your needs.

Methods can be chained and when the enumerator is finished, a promise is executed using #done.

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
enumerator.map{|x| x + 2}.each_slice(3).each{|x| puts x}
#=> [3,4,5]
#=> [6,7,8]
#=> [9,10,11]
```

##### Available enumerator methods:
- each
- map
- each_slice
- select
- reject

#### Task
A task contains code that will be added to the call stack of the event loop.  The Enumerator uses tasks to run small chunks of code without blocking the event loop.  A task can do the same things that a Timeout or an Interval can do but with some added features and optimizations.

With no options provided, a task will be run immediately once the event loop comes back to it(if the environment supports this).  If the environment does not support immediates, it will attempt to polyfill an immediate before falling back on a 0ms timeout.

Example: 

```
Async::Task.new do
  puts "hello world"
end

#=> hello world
```

By default, a task will only run once.  To make a task repeat, set the option times to however many times you want the task to repeat.  You can also have access to countup and countdown variables.

```
Async::Task.new do times: 5 do |countup, countdown|
  puts countdown
end

#=> 5
#=> 4
#=> 3
#=> 2
#=> 1
``` 

To make a task repeat infinitely, set times to ```:infinite```, or repeat to ```true```.  A countup will be provided but no countdown.  You can also use ```:i``` for short.

```
Async::Task.new times: :infinite do
  puts "forever"
end

#=> forever
#=> forever
#=> forever
...

```

The step option will determine how much you want your task to "step".

```
Async::Task.new times: 10, step: 2 do |countup, countdown|
  puts countup
end

#=> 0
#=> 2
#=> 4
#=> 6
#=> 8
```

To set a delay time on your task, specify the delay option with the number of milliseconds you want the duration of the delay to be.  This can also be done when you have set your task to repeat.

```
Async::Task.new delay: 1000 do
  puts "this took 1 second"
end 
```

The delay and steps of a task can be modified within the execution of the task.  The following example will start out slow and increase in speed:

```
task = Async::Task.new times: 5, delay: 5000 do |countup, countdown|
  puts countdown
  task.delay = task.delay - 1000
end
```

Tasks also have callbacks that can be performed on certain events.

Here is an example of how to execute code after a repeating task has finished:

```
task = Async::Task.new times: 3, delay: 1000 do |countup, countdown|
  puts countdown
end

task.on_finish {puts "BOOM"}

#=> 3
#=> 2
#=> 1
#=> BOOM
```

Other callbacks include ```on_start``` and ```on_stop```.


#### Other Timers

You can also set timeouts and intervals, specifically:


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

## Contributors

- [Benjamin Titcomb](https://github.com/Ravenstine) (Creator and Main Contributor)
- [Andy Maleh](https://github.com/AndyObtiva) (Gemifier and Maintainer)
