#!/usr/bin/ruby

require 'test/unit'
require 'stringio'

class TestExecute < Test::Unit::TestCase
  def test_show_help
    load "rumy-main.rb"

    expected_message = "\
[DEBUG] : Target Created  = make_ccode, Depends = , Commands = []
[DEBUG] : Target Created  = compile_c, Depends = , Commands = []
[DEBUG] : Target Created  = run_c, Depends = , Commands = []
[HELP] =============================================
[HELP] compile_c : Compile ./test.c
[HELP] run_c : Run ./test
[HELP] =============================================
"

    # replace stdout with string object
    $stdout = StringIO.new

    source_file = "./test.c"
    exec_file = source_file.sub(".c", "")

    make_target :make_ccode do
      explain  "Generate #{source_file}"
    end

    make_target :compile_c do
      global
      explain  "Compile #{source_file}"
    end

    make_target :run_c do
      global
      explain  "Run #{exec_file}"
    end

    show_help

    assert_equal expected_message, $stdout.string

    $stdout = STDOUT
  end

end
