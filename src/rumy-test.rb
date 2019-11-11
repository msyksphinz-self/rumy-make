#!/usr/bin/ruby

$test_list = Hash.new

def add_test(name, command)
  test = Test.new(name, command)
  $test_list[name] = test
end

def run_tests
  $test_list.each{|test|
    `#{test}`
  }
end

class Test
  def initialize(name, command)
    @name = name
    @command = command
  end
end
