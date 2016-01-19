class Job
  include Comparable

  attr_reader :deadline, :remaining, :task

  def initialize(task, deadline)
    @task = task
    @deadline = deadline
    @remaining = task.runtime
  end

  def run!
    @remaining -= 1 unless done?
  end

  def done?
    @remaining.zero?
  end

  def <=>(other)
    other.deadline <=> self.deadline
  end
end
