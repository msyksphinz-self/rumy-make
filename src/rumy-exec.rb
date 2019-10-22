#/usr/bin/ruby

define_method("execute") {|command|
  result = `#{command}`
  puts "Result\n"
  puts "===================="
  puts result
  puts "====================\n\n"
}


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
    puts "Target Name = #{@name}, Depends = #{@depends}, Commands = #{@commands}"
  end

end


def make_target (name, &block)
  target = Target.new(name)
  target.instance_eval(&block)
  target.show
end
