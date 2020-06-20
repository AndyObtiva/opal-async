require 'native'

module Async
  class Enumerator
    def initialize(enumerable, options={})
      puts 'initialize enumerator'
      @options = options
      @enumerable = enumerable
      @jobs = []
      @jobs_finished = 0
      @jobs_queued = 0
      @lock = false
      set_defaults
    end
  
    def locked?
      !@lock
    end
  
    def unlocked?
      !@lock
    end
  
    def lock
      @lock = true
    end
  
    def unlock
      @lock = false
    end
  
    def queue(proc)
      @jobs << proc
      @jobs_queued += 1
      watcher = Task.new times: :infinite do
        if unlocked?
          lock
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
        Task.new times: @length, step: @step do |ind, cdown|
          Task.new do
            yield(@enumerable[ind], ind)
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
        Task.new times: @length do |ind, cdown|
          Task.new do
            chunk << @enumerable[ind]
            if (ind + 1) % @step == 0
              if block_was_given
                @output << yield(@enumerable[ind], ind)
              else
                @output << chunk
              end
              chunk = []
            end
            if cdown <= 1
              finish_job 
            end
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
        Task.new step: @step, times: @length do |ind, cdown|
          Task.new do
            @output[ind] = yield(@enumerable[ind], ind)
            if cdown <= 1
              finish_job 
            end
          end
        end
      end
      queue proc
      self
    end
    def select step=1, &block
      proc = Proc.new do
        set_defaults
        @step = step
        Task.new step: @step, times: @length do |ind, cdown|
          Task.new do
            operation = yield(@enumerable[ind], ind)
            @output << @enumerable[ind] if operation == true 
            if cdown <= 1
              finish_job 
            end
          end
        end
      end
      queue proc
      self
    end
    def reject step=1, &block
      proc = Proc.new do
        set_defaults
        @step = step
        Task.new step: @step, times: @length do |ind, cdown|
          Task.new do
            operation = yield(@enumerable[ind], ind)
            @output << @enumerable[ind] unless operation == true 
            if cdown <= 1
              finish_job 
            end
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
      @enumerable = @output
      @jobs.shift
      @jobs_finished += 1
      unlock
    end
    def complete proc
      checker = Task.new times: :infinite do
        if (@jobs_finished >= @jobs_queued)
          checker.stop
          proc.call
        end
      end
      self
    end
  end
end
