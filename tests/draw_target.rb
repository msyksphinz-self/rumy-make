#!/usr/bin/ruby

require 'test/unit'
require 'stringio'

load "rumy-main.rb"

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
