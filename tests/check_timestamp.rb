#!/usr/bin/ruby

load "rumy-exec.rb"

make_target "test" do
  global
  depends ["test.c"]
  executes ["gcc test.c -o test"]
end

exec_target "test"
