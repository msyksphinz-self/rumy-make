#!/usr/bin/env ruby

require "rumy-main.rb"


def make_library(lib_name, cpp_file_list, compile_options, link_options, additional_depends = [])

  additional_depends.each {|dep|
    do_target dep
  }

  obj_file_list = cpp_file_list.map {|cpp| cpp + ".o"}
  make_target lib_name do
    global
    depends obj_file_list
    executes ["ar qc #{link_options.join(' ').to_s} #{lib_name} #{obj_file_list.join(' ').to_s}"]
  end

  cpp_file_list.zip(obj_file_list).each {|pair|
    cpp = pair[0]
    obj = pair[1]

    cc_cmd = "gcc"
    if cpp =~ /.*\.cpp$/ then
      cc_cmd = "g++"
    end
    make_target obj do
      depends [cpp]
      executes ["#{cc_cmd} #{compile_options.join(' ').to_s} -c #{cpp} -o #{obj}"]
    end
  }
end


def make_execute(exec_name, cpp_file_list, lib_file_list, compile_options, link_options, link_libs, additional_depends = [])

  additional_depends.each {|dep|
    do_target dep
  }

  obj_file_list = cpp_file_list.map {|cpp| cpp + ".o"}
  make_target exec_name do
    global
    depends obj_file_list + lib_file_list

    cc_cmd = "g++"

    executes ["#{cc_cmd} -o #{exec_name} #{link_options.join(' ').to_s} \
              #{obj_file_list.join(' ').to_s} \
              #{lib_file_list.join(' ').to_s} \
              #{link_libs.join(' ').to_s}"]
  end

  cpp_file_list.zip(obj_file_list).each {|pair|
    cpp = pair[0]
    obj = pair[1]

    cc_cmd = "gcc"
    if cpp =~ /.*\.cpp$/ then
      cc_cmd = "g++"
    end

    make_target obj do
      depends [cpp]
      executes ["#{cc_cmd} #{compile_options.join(' ').to_s} -c #{cpp} -o #{obj}"]
    end
  }
end


def cpp_init_project(proj_name)
  Dir.mkdir(proj_name)
  Dir.mkdir(proj_name + "/src")
  Dir.mkdir(proj_name + "/include")
  fp = File.open(proj_name + "/src/main.cpp", "w") {|f|
    f.puts("#include <iostream>")
    f.puts("int main ()")
    f.puts("{")
    f.puts("  std::cout << \"Hello World\\n\";")
    f.puts("}")
  }

  fp = File.open(proj_name + "/.gitignore", "w") {|f|
    f.puts("*\.o   # object file")
    f.puts("#{proj_name}  # executable")
  }

  fp = File.open(proj_name + "/build.rb", "w") {|f|
    f.puts("#!/usr/bin/env ruby\n")

    f.puts("load \"rumy-cpp.rb\"")

    f.puts("cpp_lists = [\"./src/main.cpp\"]")

    f.puts("compile_options = [\"-I./include\"]")

    f.puts("make_execute(\"" + proj_name + "\", cpp_lists, [], compile_options, [], [], [])")

    f.puts("make_target :all do")
    f.puts("  global")
    f.puts("  depends [\"" + proj_name + "\"]")
    f.puts("end")
  }

end
