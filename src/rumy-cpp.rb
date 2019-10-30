#!/usr/bin/ruby

require "rumy-main.rb"


def make_library(lib_name, cpp_file_list, compile_options, link_options)

  obj_file_list = cpp_file_list.map {|cpp| cpp + ".o"}
  make_target lib_name do
    global
    depends obj_file_list
    executes ["ar qc #{link_options.join(' ').to_s} #{lib_name} #{obj_file_list.join(' ').to_s}"]
  end

  cpp_file_list.zip(obj_file_list).each {|pair|
    cpp = pair[0]
    obj = pair[1]
    make_target obj do
      depends [cpp]
      executes ["g++ #{compile_options.join(' ').to_s} -c #{cpp} -o #{obj}"]
    end
  }
end


def make_execute(exec_name, cpp_file_list, lib_file_list, compile_options, link_options, link_libs)

  obj_file_list = cpp_file_list.map {|cpp| cpp + ".o"}
  make_target exec_name do
    global
    depends obj_file_list + lib_file_list
    executes ["g++ -o #{exec_name} #{link_options.join(' ').to_s} \
              #{obj_file_list.join(' ').to_s} \
              #{lib_file_list.join(' ').to_s} \
              #{link_libs.join(' ').to_s}"]
  end

  cpp_file_list.zip(obj_file_list).each {|pair|
    cpp = pair[0]
    obj = pair[1]
    make_target obj do
      depends [cpp]
      executes ["g++ #{compile_options.join(' ').to_s} -c #{cpp} -o #{obj}"]
    end
  }
end
