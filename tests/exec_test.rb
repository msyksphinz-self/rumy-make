#!/usr/bin/ruby

load "rumy-exec.rb"

execute "ls -lt"
execute "echo Hello World"



make_target :first do
  depends [:second, :third]
  executes "echo Hello World"
end
