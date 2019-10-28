#!/usr/bin/ruby

load "rumy-main.rb"

make_target "test" do
  global
  depends ["test.c"]
  executes ["gcc test.c -o test"]
end


if ARGV.length == 0 then
  exec_target "test"
else
  instance_eval("exec_target ARGV[0]")
end
