class Enumerator
  def initialize enumerable
    @enumerable = enumerable
    @jobs = []
    @jobs_finished = 0
    @jobs_queued = 0
    set_defaults
  end
  def queue proc
    @jobs << proc
    @jobs_queued += 1
    watcher = Interval.new 0 do
      if @jobs.count == 1
        @jobs.first.call
        watcher.stop
      elsif @jobs.count.zero?
        watcher.stop
      end
    end
  end
  def set_defaults
    @output = []
    @finished = false
    @length = @enumerable.length
  end
  def each step=1, &block
    proc = Proc.new do
      set_defaults
      @step = step
      Countdown.new 0, @length, @step do |cdown, ind|
        Timeout.new 0 do
          yield(@enumerable[ind], ind)
          # @finished = true if cdown <= 1
          finish_job if cdown <= 1
        end
      end
      @output = @enumerable
    end
    queue proc
    self
  end
  def each_slice step=1, &block
    proc = Proc.new do
      set_defaults
      @step = step
      chunk = []
      block_was_given = block_given?
      Countdown.new 0, @length, 1 do |cdown, ind|
        Timeout.new 0 do
          chunk << @enumerable[ind]
          if (ind + 1) % @step == 0
            if block_was_given
              @output << yield(@enumerable[ind], ind)
            else
              @output << chunk
            end
            chunk = []
          end
          # @finished = true if cdown <= 1
          finish_job if cdown <= 1
        end
      end
    end
    queue proc
    self
  end
  def map step=1, &block
    proc = Proc.new do
      set_defaults
      @step = step
      Countdown.new 0, @length, @step do |cdown, ind|
        Timeout.new 0 do
          @output << yield(@enumerable[ind], ind)
          # @finished = true if cdown <= 1
          finish_job if cdown <= 1
        end
      end
    end
    queue proc
    self
  end
  def done &block
    complete Proc.new {yield(@output, self)}
  end
  def then &block
    complete Proc.new {yield(self.class.new(@output))}
  end
  def finish_job
    @jobs.shift
    @jobs_finished += 1
  end
  def complete proc
    checker = Interval.new 0 do
      if (@jobs_finished >= @jobs_queued)
        checker.stop
        proc.call
      end
    end
    self
  end
end