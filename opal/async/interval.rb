class Interval
  def initialize time=0, &block
    @block = block
    @time = time
    start
  end
 
  def stop
    `clearInterval(#{@interval})`
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