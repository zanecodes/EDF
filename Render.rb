require 'erb'
require 'digest'
require_relative 'Scheduler'
require_relative 'Task'
require_relative 'Job'

class Render
  def initialize
    @scheduler = Scheduler.new
    @template = IO.read('render.html.erb')
  end

  def color(obj)
    "##{Digest::SHA1.hexdigest(obj)[0...6]}"
  end

  def render
    @tasks = {
      Task.new('A', 10) => 30,
      Task.new('B', 15) => 40,
      Task.new('C', 5) => 50
    }

    #@finish = @tasks.values.reduce(:lcm)
    @finish = 150

    0.upto(@finish) do |time|
      @tasks.each do |task, period|
        @scheduler << Job.new(task, time + period) if (time % period).zero?
      end

      @scheduler.run!
    end

    puts ERB.new(@template).result(binding)
  end
end

Render.new.render
