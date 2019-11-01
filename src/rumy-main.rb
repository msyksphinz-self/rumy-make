#!/usr/bin/ruby

require "rumy-clean.rb"
require "rumy-target.rb"
require "rumy-draw.rb"
require "rumy-help.rb"

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
    @is_global = false
    @is_external = false
    @external_dir = ""
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

  def external(dir_name)
    @is_external = true
    @external_dir = dir_name
  end

  attr_reader :name
  attr_reader :commands
  attr_reader :depend_targets
  attr_reader :help_message
  attr_reader :is_global

  # For external
  attr_reader :is_external
  attr_reader :external_dir
end
