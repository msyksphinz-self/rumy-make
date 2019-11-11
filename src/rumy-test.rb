#!/usr/bin/ruby
# coding: utf-8

$test_list = Hash.new

def add_test(name, command, logfile)
  test = Test.new(name, command, logfile)
  $test_list[name] = test
end

def run_tests
  $test_list.each{|key, value|
    puts value.command
    result = `#{value.command}`
    fp = File.open(value.logfile, "w") {|f|
      f.puts(result)
    }
  }
end

class Test
  def initialize(name, command, logfile)
    @name = name
    @command = command
    @logfile = logfile
  end

  attr_reader :name
  attr_reader :command
  attr_reader :logfile
end
