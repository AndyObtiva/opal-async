module Async
  class Timeout
  
    def initialize time=0, &block
      @time = time
      @block = block
      start
    end
   
    def stopped?
      @stopped
    end
  
    def stop
      `clearTimeout(#@timeout)`
      @stopped = true
    end
  
    def restart
      stop
      start
    end
  
    def start
      @timeout = `setTimeout(function(){#{@block.call};#{@stopped = true}}, #{@time})`
      @stopped = false
    end
    
  end
end
