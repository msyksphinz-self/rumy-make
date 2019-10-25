#!/usr/bin/ruby

load "rumy-exec.rb"

test_o_files = ["../tests/multiple_files_build/test_0.o",
                "../tests/multiple_files_build/test_1.o",
                "../tests/multiple_files_build/test_2.o",
                "../tests/multiple_files_build/test_3.o",
                "../tests/multiple_files_build/test_4.o",
                "../tests/multiple_files_build/test_5.o",
                "../tests/multiple_files_build/test_6.o",
                "../tests/multiple_files_build/test_7.o",
                "../tests/multiple_files_build/test_8.o",
                "../tests/multiple_files_build/test_9.o"];

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
