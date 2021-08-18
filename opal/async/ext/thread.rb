require 'thread' # bring the thread compatibility class from Opal first

class Thread
  def initialize(*args, &proc)
    @async_task = Async::Task.new do
      proc.call(*args)
    end
  end
  
  def stop
    @async_task.stop
  end
  
  def kill
    @async_task.stop
  end
end
