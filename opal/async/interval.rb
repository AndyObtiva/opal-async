class Interval
  def initialize time=0, &block
    @block = block
    @time = time
    start
  end
 
  def stop
    `clearInterval(#{@interval.to_n})`
    @stopped = true
  end

  def start
    @interval = `setInterval(function(){#{@block.call}}, #{@time})`
    @stopped = false
  end

  def stopped?
    @stopped
  end

  def restart
    stop
    start
  end
end