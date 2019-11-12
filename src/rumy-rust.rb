#!/usr/bin/ruby

require "rumy-main.rb"


def make_execute_rust(exec_name, cpp_file_list, lib_file_list, compile_options, link_options, link_libs, additional_depends = [])

  additional_depends.each {|dep|
    do_target dep
  }

  obj_file_list = cpp_file_list.map {|cpp| cpp + ".o"}
  make_target exec_name do
    global
    depends obj_file_list + lib_file_list

    cc_cmd = "rustc"

    executes ["#{cc_cmd} -o #{exec_name} #{link_options.join(' ').to_s} \
              #{cpp_file_list.join(' ').to_s} \
              #{lib_file_list.join(' ').to_s} \
              #{link_libs.join(' ').to_s}"]
  end
end


def rust_init_project(proj_name)
  Dir.mkdir(proj_name)
  Dir.mkdir(proj_name + "/src")
  fp = File.open(proj_name + "/src/main.rs", "w") {|f|
    f.puts("fn main() {")
    f.puts("  println!(\"Hello, world!\");")
    f.puts("}")
  }

  fp = File.open(proj_name + "/build.rb", "w") {|f|
    f.puts("#!/usr/bin/env ruby\n")

    f.puts("load \"rumy-rust.rb\"")

    f.puts("cpp_lists = [\"./src/main.rs\"]")
    f.puts("compile_options = []")

    f.puts("make_execute_rust(\"" + proj_name + "\", cpp_lists, [], compile_options, [], [], [])")

    f.puts("make_target :all do")
    f.puts("  global")
    f.puts("  depends [\"" + proj_name + "\"]")
    f.puts("end")
  }

end
