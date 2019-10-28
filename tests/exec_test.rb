#!/usr/bin/ruby

require 'test/unit'
require 'stringio'


class TestExecute < Test::Unit::TestCase
  def test_execute
    load "rumy-exec.rb"

    # replace stdout with string object
    $stdout = StringIO.new

    execute "echo Hello World"
    assert_equal "Hello World\n", $stdout.string

    $stdout = STDOUT
  end

  def test_make_target
    load "rumy-exec.rb"

    expected_message = "\
[DEBUG] : Target Created  = first, Depends = , Commands = [\"echo Hello, First Target\"]
echo Hello, First Target
Hello, First Target
"

    # replace stdout with string object
    $stdout = StringIO.new

    make_target :first do
      global
      executes ["echo Hello, First Target"]
    end

    exec_target :first

    assert_equal expected_message, $stdout.string

    $stdout = STDOUT
  end

  def test_make_copmile
    load "rumy-exec.rb"

    expected_message = "\
[DEBUG] : Target Created  = compile_c, Depends = , Commands = [\"gcc ../tests/simple_main.cpp -o ../tests/simple_main\"]
[DEBUG] : Target Created  = run_c, Depends = , Commands = [\"../tests/simple_main\"]
[DEBUG] : Depends Target \"compile_c\" execute.
gcc ../tests/simple_main.cpp -o ../tests/simple_main

../tests/simple_main
Hello rumy-make!!
"

    # replace stdout with string object
    $stdout = StringIO.new

    make_target :compile_c do
      src = "../tests/simple_main.cpp"
      exe = src.sub(".cpp", "")
      executes ["gcc #{src} -o #{exe}"]
    end

    make_target :run_c do
      global
      depends [:compile_c]
      executes ["../tests/simple_main"]
    end

    exec_target :run_c

    assert_equal expected_message, $stdout.string

    $stdout = STDOUT
  end

end
