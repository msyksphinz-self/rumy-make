#!/usr/bin/env ruby

require 'test/unit'
require 'stringio'

class TestExecute < Test::Unit::TestCase
  def test_execute

    load "rumy-main.rb"

    if File.exist?("test") then
      File.delete("test")
    end
    if File.exist?("test.o") then
      File.delete("test.o")
    end

    $stdout = StringIO.new

    expected_message = "\
[DEBUG] : Target Created  = test.o, Depends = , Commands = [\"gcc -c test.c\"]
"

    make_target "test.o" do
      depends ["test.c"]
      executes ["gcc -c test.c"]
    end

    assert_equal expected_message, $stdout.string
    $stdout = STDOUT


    $stdout = StringIO.new

    expected_message = "\
[DEBUG] : Target Created  = test, Depends = , Commands = [\"gcc test.o -o test\"]
"

    make_target "test" do
      depends ["test.o"]
      executes ["gcc test.o -o test"]
    end

    assert_equal expected_message, $stdout.string
    $stdout = STDOUT

    $stdout = StringIO.new

    expected_message = "\
[DEBUG] : Target Created  = run_test, Depends = , Commands = [\"./test\"]
[DEBUG] : Depends Target \"test\" execute.
[DEBUG] : Depends Target \"test.o\" execute.
[DEBUG] : Depend Tareget \"test.c\" is skip because it's file.
gcc -c test.c

gcc test.o -o test

./test
Hello Rumy-Make!!
[DEBUG] : Depends Target \"test\" execute.
[DEBUG] : Depends Target \"test.o\" execute.
[DEBUG] : Depend Tareget \"test.c\" is skip because it's file.
gcc test.o -o test

./test
Hello Rumy-Make!!
"

    make_target :run_test do
      global
      depends ["test"]
      executes ["./test"]
    end

    exec_target  :run_test
    exec_target  :run_test  # Execute Again

    assert_equal expected_message, $stdout.string
    $stdout = STDOUT

    $stdout = StringIO.new

    expected_message = "\
[DEBUG] clean_target : remove test.o
[DEBUG] clean_target : remove test
"
    clean_target :run_test

    assert_equal expected_message, $stdout.string
    $stdout = STDOUT

  end
end
