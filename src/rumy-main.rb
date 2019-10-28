#!/usr/bin/ruby

require "rumy-clean.rb"
require "rumy-target.rb"
require "rumy-draw.rb"

define_method("execute") {|command|
  result = `#{command}`
  puts result
}


$target_list = Hash.new

class Target
  def initialize(name)
    @name = name
    @depend_targets = []
    @help_message = ""
    @commands = []
    @global = false
  end

  def depends(targets)
    if not targets.kind_of?(Array) then
      puts "ERROR: \"depends\" should be specified as List. Did you forget to add '[', ']'?"
      exit
    end
    @depend_targets = targets
  end

  def executes(commands)
    if not commands.kind_of?(Array) then
      puts "ERROR: \"executes args\" should be specified as List. Did you forget to add '[', ']'?"
      exit
    end
    @commands += commands
  end

  def explain(message)
    @help_message = message
  end

  def show
    puts "[DEBUG] : Target Created  = #{@name}, Depends = #{@depends}, Commands = #{@commands}"
  end

  def global
    @is_global = true
  end

  attr_reader :name
  attr_reader :commands
  attr_reader :depend_targets
  attr_reader :help_message
  attr_reader :is_global
end


def show_help
  puts "[HELP] ============================================="
  $target_list.each{|key, target|
    if target.help_message != "" and target.is_global == true then
      puts "[HELP] #{key} : " + target.help_message
    end
  }
  puts "[HELP] ============================================="
end
