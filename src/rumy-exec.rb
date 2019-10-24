#/usr/bin/ruby

define_method("execute") {|command|
  result = `#{command}`
  puts result
}


@target_list = Hash.new

class Target
  def initialize(name)
    @name = name
  end

  def depends(targets)
    @depends = targets
  end

  def executes(commands)
    @commands = commands
  end

  def show
    puts "[DEBUG] : Target Created  = #{@name}, Depends = #{@depends}, Commands = #{@commands}"
  end

  attr_reader :commands

end


def make_target (name, &block)
  target = Target.new(name)
  target.instance_eval(&block)
  target.show
  @target_list[name] = target
end

def exec_target (name)
  if @target_list.key?(name) then
    target = @target_list[name]
    result = `#{target.commands}`
    puts result
  else
    puts "Error: target #{name} not found."
  end
end
