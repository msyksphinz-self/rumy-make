#!/usr/bin/ruby

load "rumy-exec.rb"

make_target "test.o" do
  depends ["test.c"]
  executes ["gcc -c test.c"]
end

make_target "test" do
  depends ["test.o"]
  executes ["gcc test.o -o test"]
end

make_target :run_test do
  global
  depends ["test"]
  executes ["./test"]
end

exec_target  :run_test
clean_target :run_test
