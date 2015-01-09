class VarInterval
  def initialize time=0, &block
    @block = block
    set_time time
    start &block
  end

  def start &block
    @timeout = `setTimeout(function(){#{block.call};#{start(&block) unless @stopped};}, #{@time})`
    @stopped = false
  end
 
  def stop
    `clearTimeout(#@timeout)`
    @stopped = true
  end

  def set_time time
    @time = time
  end

  def restart
    stop
    start
  end

  def stopped?
    @stopped
  end
end