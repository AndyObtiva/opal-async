# backtick_javascript: true

module Async
  class Countdown
    def initialize time=0, intervals=1, step=1, &block
      @countdown = intervals
      @countup = 0
      @step = step
      @block = block
      @time = time
      start
    end
  
    def start
      @interval = `setInterval(function(){#{@block.call(@countdown,@countup)};#{@countdown -= @step};#{@countup += @step};#{stop if @countdown.zero?};}, #{@time})`
      @stopped = false
    end
   
    def stop
      `clearInterval(#@interval)`
      @stopped = true
    end
  
    def restart
      stop
      start
    end
  
    def stopped?
      @stopped = true
    end
  end
end
