require 'test/unit'
require '../Task'

class TestTask < Test::Unit::TestCase
  def test_get_name
    task = Task.new('Task', 10)
    assert_equal('Task', task.name)
  end

  def test_get_runtime
    task = Task.new('Task', 10)
    assert_equal(10, task.runtime)
  end
end
