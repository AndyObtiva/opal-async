require 'async/task'

class Array
  alias cycle_without_opal_async cycle
  def cycle(n=nil, &block)
    if Async::Task.started? && block_given?
      array = self * n unless n.nil?
      index = 0
      looper = lambda do
        if n.nil?
          block.call(self[index])
          index += 1
          index = index % self.size
          Async::Task.new(&looper)
        else
          block.call(array.shift)
          Async::Task.new(&looper) unless array.empty?
        end
      end
      Async::Task.new(&looper)
    else
      cycle_without_opal_async(n, &block)
    end
  end
  
  alias each_without_opal_async each
  def each(&block)
    if Async::Task.started? && block_given?
      array = self
      index = 0
      looper = lambda do
        block.call(array.shift)
        Async::Task.new(&looper) unless array.empty?
      end
      Async::Task.new(&looper)
    else
      each_without_opal_async(&block)
    end
  end
end
