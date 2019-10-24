#/usr/bin/ruby

define_method("execute") {|command|
  result = `#{command}`
  puts result
}


@target_list = Hash.new

class Target
  def initialize(name)
    @name = name
    @depend_targets = []
  end

  def depends(targets)
    @depend_targets = targets
  end

  def executes(commands)
    @commands = commands
  end

  def show
    puts "[DEBUG] : Target Created  = #{@name}, Depends = #{@depends}, Commands = #{@commands}"
  end

  attr_reader :commands
  attr_reader :depend_targets
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
    # Execute dependent commands at first
    target.depend_targets.each{|dep|
      puts "[DEBUG] : Depends Target \"#{dep}\" execute."
      exec_target(dep)
    }
    result = `#{target.commands}`
    puts result
  else
    puts "Error: target \"#{name}\" not found."
  end
end
