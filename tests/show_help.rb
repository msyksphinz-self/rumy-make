#!/usr/bin/ruby

load "rumy-exec.rb"

source_file = "./test.c"
exec_file = source_file.sub(".c", "")

make_target :make_ccode do
  explain  "Generate #{source_file}"
end

make_target :compile_c do
  explain  "Compile #{source_file}"
end

make_target :run_c do
  # explain  "Run #{exec_file}"
end

show_help
