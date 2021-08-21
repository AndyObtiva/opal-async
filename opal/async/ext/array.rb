require 'async/task'

class Array
  def async_cycle(n=nil, &block)
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
  end
  
  def async_each(&block)
    array = self
    index = 0
    looper = lambda do
      block.call(array.shift)
      Async::Task.new(&looper) unless array.empty?
    end
    Async::Task.new(&looper)
  end
end
