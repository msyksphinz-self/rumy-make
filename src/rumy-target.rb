#!/usr/bin/env ruby

require 'parallel'
require 'rumy-git.rb'

def make_target (name, &block)
  target = Target.new(name)
  target.instance_eval(&block)
  target.show
  $target_list[name] = target
end

private def do_target (name)
  puts "[DEBUG] : ==== Execute Target " + name.to_s + " ===="

  if not $target_list.key?(name) then
    puts "Error: target \"#{name}\" not found."
    return
  end

  target = $target_list[name]

  need_check_modify = rumy_is_git_modify_lock()

  # Execute dependent commands at first
  check_target = false
  if name.kind_of?(String) and File.exist?(name) then
    target_stat = File::Stat.new(name)
    # puts "[DEBUG] : target mtime: #{target_stat.mtime}"

    check_target = true
  end

  target_older_depends_list = Array.new
  if target.depend_targets.length == 0 then
    target_older_depends_list = [true]
  else
    target_older_depends_list =  Parallel.map(target.depend_targets){|dep|
      target_older_depends = false
      # target_older_depends_list = target.depend_targets.each{|dep|
      skip_do_target = false
      if $target_list.key?(dep) and $target_list[dep].is_external then
        # External Target
        puts "[DEBUG] : Call External rule : " + dep
        Dir.chdir($target_list[dep].external_dir) {
          puts `pwd`
          `ruby ./build.rb`
        }
      elsif not $target_list.key?(dep) and not Symbol.all_symbols.include?(dep) then
        # puts "[DEBUG] : Depend Tareget \"#{dep}\" is skip because it's file."
        if need_check_modify and git_file_modified?(dep) then
          puts "[ERROR] : Rumy build is stop due to File #{dep} is modified. Exit."
          exit
        end

        if check_target == true and dep.kind_of?(String) then
          # puts "Checking file Status " + dep + " ..."
          dep_stat = File::Stat.new(dep)

          if target_stat.mtime <= dep_stat.mtime then
            target_older_depends = true
          end
        else
          # If dependence list includes symbol, need to execute
          target_older_depends = true
        end
        skip_do_target = true
      else
        # one of depends are symbol => forcely re-execute target
        target_older_depends = true
      end

      if not skip_do_target then
        do_target(dep)
      end
      # puts "[DEBUG] : Depends Target \"#{dep}\" : " + target_older_depends.to_s
      target_older_depends
    }
  end

  # puts target_older_depends_list.to_s
  if target_older_depends_list.include?(true) then
    # Execute commands!
    target.commands.each {|command|
      puts "#{command}"
      result = `#{command}`
      puts result
    }
  else
    puts "Target Execution Skipped"
  end

end


def exec_target (name)
  if not $target_list.key?(name) then
    puts "Error: target \"#{name}\" not found."
    exit
  end

  target = $target_list[name]
  if target.is_global != true then
    puts "Error: target \"#{name}\" is not global. You can't specify the target directly"
    exit
  end

  do_target(name)
end


##
## External Target Call
##
def external_target(lib_name, dir, depends = [])
  target = Target.new(lib_name)
  target.external(dir)
  target.depends(depends)
  $target_list[lib_name] = target
end


##
## External Target Make call
##
def external_make(lib_name, dir, depends = [])
  target = Target.new(lib_name)
  target.executes(["make -C #{dir}"])
  target.depends(depends)
  $target_list[lib_name] = target
end
