require 'async/task'

module Kernel
  def async_loop(&block)
    looper = lambda do
      block.call
      Async::Task.new(&looper)
    end
    Async::Task.new(&looper)
  end
end
