#!/usr/bin/ruby

load "rumy-main.rb"

test_o_files = (0..99).map{|num| "../tests/multiple_files_build/test_#{num}.o"}

test_o_files.each {|test_o|
  test_c = test_o.sub(".o", ".c")
  make_target test_o do
    executes ["gcc -c #{test_c} -o #{test_o}"]
  end
}

make_target "test_all" do
  global
  depends test_o_files

  o_files_string = test_o_files.join(' ')
  executes ["gcc ../tests/multiple_files_build/test_all.c #{o_files_string} -o test_all"]
end

exec_target "test_all"
