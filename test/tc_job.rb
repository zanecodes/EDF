require 'test/unit'
require '../Job'

class TestJob < Test::Unit::TestCase
  def setup
    @task = Task.new('Task', 10)
  end

  def test_get_task
    job = Job.new(@task, 0)
    assert_same(@task, job.task)
  end

  def test_get_deadline
    job = Job.new(@task, 0)
    assert_equal(0, job.deadline)

    job = Job.new(@task, 20)
    assert_equal(20, job.deadline)
  end

  def test_get_remaining
    job = Job.new(@task, 0)
    assert_equal(10, job.remaining)
  end

  def test_run
    job = Job.new(@task, 0)

    (1..10).reverse_each do |i|
      assert_equal(i, job.remaining)
      assert_false(job.done?)
      job.run!
    end

    assert_equal(0, job.remaining)
    assert_true(job.done?)
  end
end
