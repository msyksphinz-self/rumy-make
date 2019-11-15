#!/usr/bin/env ruby

load "rumy-main.rb"

test1_c = "../tests/test1.c"

test2_obj = "../tests/test2.o"
test2_c = test2_obj.sub(".o", ".c")

exec_file = "test"

make_target :test2_c do
  executes ["echo \"#include <stdio.h>\nint test2 () { printf(\\\"Hello Test2!!\\\"\); return 0; }\" > #{test2_c}"]
end

make_target :test2_obj do
  depends  [:test2_c]
  executes ["gcc -c #{test2_c} -o #{test2_obj}"]
end

make_target :compile do
  depends [test1_c, :test2_obj]
  executes ["gcc #{test1_c} #{test2_obj} -o #{exec_file}"]
end

make_target :run do
  global
  depends [:compile]
  executes [exec_file]
end

exec_target :run
