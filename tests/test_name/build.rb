#!/usr/bin/env ruby

make_target "hello" do
  global
  depends ["hello.c"]
  executes ["gcc -o #{name} #{source}"]
end

make_target :all do
  global
  depends ["hello"]
end
