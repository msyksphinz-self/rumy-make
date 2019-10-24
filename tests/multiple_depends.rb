#!/usr/bin/ruby

load "rumy-exec.rb"

source_file = "./test.c"
exec_file = source_file.sub(".c", "")

make_target :make_ccode do
  executes "echo \"#include <stdio.h>\nint main () { printf(\\\"Hello Rumy-Make!!\\\"\); return 0; }\" > #{source_file}"
end

make_target :compile_c do
  depends [:make_ccode]
  executes "gcc #{source_file} -o #{exec_file}"
end

make_target :run_c do
  depends [:compile_c]
  executes "#{exec_file}"
end

exec_target :run_c
