require 'pqueue'
require 'Set'
require_relative 'ScheduleError'

class Scheduler
  attr_accessor :timeline, :time

  def initialize
    @jobs = PQueue.new
    @timeline = {}
    @time = 0
    @last_stop = 0
    @current_job = nil
  end

  def <<(job)
    raise ScheduleError if job.deadline < @time + job.remaining
    @jobs << job
  end

  def run!
    unless @current_job.equal? @jobs.top
      (@timeline[@current_job] ||= []) << (@last_stop..@time) unless @current_job.nil?
      @last_stop = @time
      @current_job = @jobs.top
    end

    unless @current_job.nil?
      raise ScheduleError if @time > @current_job.deadline && !@current_job.done?
      @current_job.run!
      @jobs.pop if @current_job.done?
    end

    @time += 1
  end
end
