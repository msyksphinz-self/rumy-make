#!/usr/bin/ruby

define_method("execute") {|command|
  result = `#{command}`
  puts result
}


@target_list = Hash.new

class Target
  def initialize(name)
    @name = name
    @depend_targets = []
    @help_message = ""
  end

  def depends(targets)
    if not targets.kind_of?(Array) then
      puts "ERROR: \"depends\" should be specified as List. Did you forget to add '[', ']'?"
      exit
    end
    @depend_targets = targets
  end

  def executes(commands)
    @commands = commands
  end

  def explain(message)
    @help_message = message
  end

  def show
    puts "[DEBUG] : Target Created  = #{@name}, Depends = #{@depends}, Commands = #{@commands}"
  end

  attr_reader :name
  attr_reader :commands
  attr_reader :depend_targets
  attr_reader :help_message
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

      # if depends target is not found,
      # if depends targte is symbol but not found
      if not @target_list.key?(dep) and not Symbol.all_symbols.include?(dep) then
        puts "[DEBUG] : Depend Tareget \"#{dep}\" is because it's file."
        next
      end

      puts "[DEBUG] : Depends Target \"#{dep}\" execute."
      exec_target(dep)
    }
    result = `#{target.commands}`
    puts result
  else
    puts "Error: target \"#{name}\" not found."
  end
end


def show_help
  puts "[HELP] ============================================="
  @target_list.each{|key, target|
    if target.help_message != "" then
      puts "[HELP] #{key} : " + target.help_message
    end
  }
  puts "[HELP] ============================================="
end
