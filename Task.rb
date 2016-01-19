class Task
  attr_reader :name, :runtime

  def initialize(name, runtime)
    @name = name
    @runtime = runtime
  end
end
