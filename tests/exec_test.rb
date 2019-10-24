#!/usr/bin/ruby

require 'test/unit'

load "rumy-exec.rb"

execute "echo Hello World"


make_target :first do
  depends [:second, :third]
  executes "echo Hello, First Target"
end

exec_target :first

make_target :compile_c do
  src = "../tests/simple_main.cpp"
  exe = src.sub(".cpp", "")
  executes "gcc #{src} -o #{exe}"
end

exec_target :compile_c
