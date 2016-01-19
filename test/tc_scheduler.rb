require 'test/unit'
require '../Scheduler'

class TestScheduler < Test::Unit::TestCase
  def test_empty
    scheduler = Scheduler.new
    assert_equal({}, scheduler.timeline)
  end

  def test_single_job
    scheduler = Scheduler.new
    
    task = Task.new('Task', 10)

    job = Job.new(task, 10)

    scheduler << job
    11.times { scheduler.run! }

    assert_equal({
      job => [(0..10)]
    }, scheduler.timeline)
  end

  def test_job_failed
    scheduler = Scheduler.new

    task = Task.new('Task', 10)

    job = Job.new(task, 9)

    assert_raise ScheduleError do
      scheduler << job
    end
  end

  def test_two_jobs
    scheduler = Scheduler.new
    
    task_a = Task.new('A', 10)
    task_b = Task.new('B', 10)

    job_a = Job.new(task_a, 10)
    job_b = Job.new(task_b, 20)

    scheduler << job_a
    scheduler << job_b
    21.times { scheduler.run! }

    assert_equal({
      job_a => [(0..10)],
      job_b => [(10..20)]
    }, scheduler.timeline)
  end

  def test_job_interrupted
    scheduler = Scheduler.new
    
    task_a = Task.new('A', 10)
    task_b = Task.new('B', 10)

    job_a = Job.new(task_a, 20)
    job_b = Job.new(task_b, 15)

    scheduler << job_a
    5.times { scheduler.run! }
    scheduler << job_b
    16.times { scheduler.run! }

    assert_equal({
      job_a => [(0..5), (15..20)],
      job_b => [(5..15)]
    }, scheduler.timeline)
  end

  def test_job_interrupted_failed
    scheduler = Scheduler.new
    
    task_a = Task.new('A', 10)
    task_b = Task.new('B', 10)

    job_a = Job.new(task_a, 15)
    job_b = Job.new(task_b, 15)

    assert_raise ScheduleError do
      scheduler << job_a
      5.times { scheduler.run! }
      scheduler << job_b
      15.times { scheduler.run! }
    end
  end
end
