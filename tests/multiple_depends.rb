#!/usr/bin/env ruby

require 'test/unit'
require 'stringio'

class TestExecute < Test::Unit::TestCase
  def test_execute

    ## Test-1

    # replace stdout with string object
    $stdout = StringIO.new

    expected_message = "\
[DEBUG] : Target Created  = make_ccode, Depends = , Commands = [\"echo \\\"#include <stdio.h>\\nint main () { printf(\\\\\\\"Hello Rumy-Make!!\\\\\\\"); return 0; }\\\" > ./test.c\"]
"

    load "rumy-main.rb"

    source_file = "./test.c"
    exec_file = source_file.sub(".c", "")

    make_target :make_ccode do
      executes ["echo \"#include <stdio.h>\nint main () { printf(\\\"Hello Rumy-Make!!\\\"\); return 0; }\" > #{source_file}"]
    end

    assert_equal expected_message, $stdout.string
    $stdout = STDOUT

    ## Test-2
    $stdout = StringIO.new

    expected_message = "\
[DEBUG] : Target Created  = compile_c, Depends = , Commands = [\"gcc ./test.c -o ./test\"]
"

    make_target :compile_c do
      depends [:make_ccode]
      executes ["gcc #{source_file} -o #{exec_file}"]
    end

    assert_equal expected_message, $stdout.string
    $stdout = STDOUT


    ## Test-3
    $stdout = StringIO.new

    expected_message = "\
[DEBUG] : Target Created  = run_c, Depends = , Commands = [\"./test\"]
"

    make_target :run_c do
      global
      depends [:compile_c]
      executes ["#{exec_file}"]
    end

    assert_equal expected_message, $stdout.string
    $stdout = STDOUT

    ## Test-4
    $stdout = StringIO.new

    expected_message = "\
[DEBUG] : Depends Target \"compile_c\" execute.
[DEBUG] : Depends Target \"make_ccode\" execute.
echo \"#include <stdio.h>
int main () { printf(\\\"Hello Rumy-Make!!\\\"); return 0; }\" > ./test.c

gcc ./test.c -o ./test

./test
Hello Rumy-Make!!
"

    exec_target :run_c

    assert_equal expected_message, $stdout.string
    $stdout = STDOUT

    ## Test-5
    $stdout = StringIO.new

    expected_message = "\
"

    clean_target :run_c

    assert_equal expected_message, $stdout.string
    $stdout = STDOUT

  end
end
