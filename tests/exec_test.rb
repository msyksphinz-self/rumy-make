#!/usr/bin/ruby

require 'test/unit'

load "rumy-exec.rb"

class TestExecute < Test::Unit::TestCase
  def test_execute
    assert_equal NIL, execute("echo Hello World")
  end
end


make_target :first do
  executes "echo Hello, First Target"
end

exec_target :first

make_target :compile_c do
  src = "../tests/simple_main.cpp"
  exe = src.sub(".cpp", "")
  executes "gcc #{src} -o #{exe}"
end

make_target :run_c do
  depends [:compile_c]
  executes "../tests/simple_main"
end

exec_target :run_c
