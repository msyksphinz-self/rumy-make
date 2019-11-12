#!/usr/bin/ruby
# coding: utf-8

$test_list = Hash.new

def add_test(name, command, logfile)
  test = Test.new(name, command, logfile)
  $test_list[name] = test
end

def run_tests
  max_str_len = $test_list.map{|key, test| test.name.size}.max

  test_success = 0
  test_failure = 0

  $test_list.each{|key, value|
    print "Executing " + value.name + " ..."
    result_string = `#{value.command}`
    res_value = $?
    (max_str_len - value.name.size + 10).times do
      print(' ')
    end
    if res_value.exitstatus == 1 then
      puts "o"
      test_success = test_success + 1
    else
      puts "x"
      test_failure = test_failure + 1
    end
    fp = File.open(value.logfile, "w") {|f|
      f.puts(result_string)
    }
  }
  puts "======================================"
  puts "  RESULT"
  puts "  success = " + test_success.to_s
  puts "  failure = " + test_failure.to_s
  puts "======================================"
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
