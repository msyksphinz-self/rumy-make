#!/usr/bin/env ruby

require 'test/unit'
require 'stringio'


class TestExecute < Test::Unit::TestCase
  def test_show_draw

    load "rumy-main.rb"

    # replace stdout with string object
    $stdout = StringIO.new

expected_message = "\
[DEBUG] : Target Created  = make_ccode, Depends = , Commands = [\"echo \\\"#include <stdio.h>\\nint main () { printf(\\\\\\\"Hello Rumy-Make!!\\\\\\\"); return 0; }\\\" > ./test.c\"]
[DEBUG] : Target Created  = compile_c, Depends = , Commands = [\"gcc ./test.c -o ./test\"]
[DEBUG] : Target Created  = link_code, Depends = , Commands = []
[DEBUG] : Target Created  = run_c, Depends = , Commands = [\"./test\"]
`-> Target : run_c\t\t\t\t// [\"./test\"]
    |-> Target : link_code\t\t\t\t// []
    |   `-> Target : hogehoge
    `-> Target : compile_c\t\t\t\t// [\"gcc ./test.c -o ./test\"]
        |-> Target : make_ccode\t\t\t\t// [\"echo \\\"#include <stdio.h>\\nint main () { printf(\\\\\\\"Hello Rumy-Make!!\\\\\\\"); return 0; }\\\" > ./test.c\"]
        |-> Target : test2.c
        `-> Target : test3.c
"

    source_file = "./test.c"
    exec_file = source_file.sub(".c", "")

    make_target :make_ccode do
      executes ["echo \"#include <stdio.h>\nint main () { printf(\\\"Hello Rumy-Make!!\\\"\); return 0; }\" > #{source_file}"]
    end

    make_target :compile_c do
      depends [:make_ccode, "test2.c", "test3.c"]
      executes ["gcc #{source_file} -o #{exec_file}"]
    end


    make_target :link_code do
      depends [:hogehoge]
    end


    make_target :run_c do
      global
      depends [:link_code, :compile_c]
      executes ["#{exec_file}"]
    end

    draw_target :run_c

    assert_equal expected_message, $stdout.string

    $stdout = STDOUT
  end
end
