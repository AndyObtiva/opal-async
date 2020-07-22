require 'thread' # bring the thread compatibility class from Opal first

class Thread
  def initialize(*args, &proc)
    Async::Task.new do
      proc.call(*args)
    end
  end
end
