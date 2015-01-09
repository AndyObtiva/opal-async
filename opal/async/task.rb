class Task
  def initialize time=0, &block
    @time = time
    @block = block
    start
  end
 
  def stopped?
    @stopped
  end

  def stop
    # `clearTimeout(#@timeout)`
    @stopped = true
  end

  def restart
    stop
    start
  end

  def start
    `
      var task = function(){#{@block.call};#{@stopped = true}};
      var mc = new MessageChannel();

      mc.port1.onmessage = function(){ task.apply(task) };
      mc.port2.postMessage(null);
    `
    @stopped = false
  end
end