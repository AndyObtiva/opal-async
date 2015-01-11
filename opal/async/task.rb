class Task
  attr_accessor :delay, :times
  def initialize options={}, &block
    @options = options
    @block = block
    generate_settings
    start
  end

  def generate_settings
    @countdown = @options[:times] || 1
    @countup = 0
    @step = @options[:step] || 1
    @delay = @options[:delay] || 0
    @times = @options[:times]
    @proc = Proc.new do
      if @times
        if @times.is_a?(Fixnum)
          @block.call(@countup, @countdown)
          @countdown -= @step
          unless @countdown <= 0
            start unless @stopped
          else
            stop
            @after_finish.call(@enumerable) if @after_finish
          end
        elsif [:infinite, :unlimited, :indefinite, :i].include?(@times) || @options[:repeat]
          @block.call(@countup, nil)
          start unless @stopped
        end
        @countup += @step
      else
        @block.call
        @stopped = true
      end
    end
  end

  def on_stop &block
    @after_stop = block
  end

  def on_start &block
    @before_start = block
  end

  def on_finish &block
    @after_finish = block
  end

  def stopped?
    @stopped
  end

  def stop
    @stopper.call if @stopper
    @after_stop.call(@enumerable) if @after_stop
    @stopped = true
  end

  def restart
    stop
    generate_settings
    start
  end

  def start
    @before_start.call(@enumerable) if @before_start
    if @delay && @delay > 0
      set_timeout
    else
      set_immediate
    end
    @stopped = false
  end

  def set_timeout
    @task = `setTimeout(function() {
      #{@proc.call};
    }, #{@delay || 0})`
    
    @stopper = Proc.new{`window.clearTimeout(#@task)`}
  end

  def set_immediate
    if `window.setImmediate != undefined`
      @task = `window.setImmediate(function() {
        #{@proc.call};
      })`


      @stopper = Proc.new{`window.clearImmediate(#@task)`}

    elsif `window.msSetImmediate != undefined`
      @task = `window.msSetImmediate(function() {
        #{@proc.call};
      })`


      @stopper = Proc.new{`window.msClearImmediate(#@task)`}

    elsif `window.MessageChannel != undefined`
      ### Higher precedence than postMessage because it is supported in WebWorkers.
      `
        var task = function(){
          if(#{!stopped?}){
            #{@proc.call};
          };
        };
        var mc = new MessageChannel();

        mc.port1.onmessage = function(){ 
          if (!#{stopped?}){
            task.apply(task) 
          }
        };
        mc.port2.postMessage(null);
      `

      @stopper = Proc.new{}
    elsif  `window.postMessage != undefined`
      @message_id = "opal.async.task.#{rand(1_000_000)}."
      @task = `window.addEventListener("message", function(event){
        if((event.data === '#{@message_id}') && #{!stopped?}){
          #{@proc.call};
        }
      }, true)`

      `window.postMessage("#{@message_id}", "*")`

      @stopper = Proc.new{@message_id = nil}
    elsif `document != undefined` && `document.onreadystatechange === null`
      `
        var script = document.createElement("script");
        script.onreadystatechange = function() {
          if (!#{stopped?}) {
            #{@proc.call};
          }
          script.onreadystatechange = null;
          script.parentNode.removeChild(script);
        };
        document.documentElement.appendChild(script);
      `
      @stopper = Proc.new{}
    else
      @task = `setTimeout(function() {
        #{@proc.call};
      }, 0)`
    end

  end

end