#!/usr/bin/ruby

def make_target (name, &block)
  target = Target.new(name)
  target.instance_eval(&block)
  target.show
  $target_list[name] = target
end

private def do_target (name)
  if $target_list.key?(name) then
    target = $target_list[name]

    # Execute dependent commands at first
    check_target = false
    if name.kind_of?(String) and File.exist?(name) then
      target_stat = File::Stat.new(name)
      # puts "[DEBUG] : target mtime: #{target_stat.mtime}"

      check_target = true
    end

    target_older_1of_depends = false
    if target.depend_targets.length == 0 then
      target_older_1of_depends = true
    else
      target.depend_targets.each{|dep|
        if not $target_list.key?(dep) and not Symbol.all_symbols.include?(dep) then
          puts "[DEBUG] : Depend Tareget \"#{dep}\" is skip because it's file."
          if check_target == true and dep.kind_of?(String) then
            dep_stat = File::Stat.new(dep)
            # puts "[DEBUG] : depends mtime: #{dep_stat.mtime}"

            if target_stat.mtime <= dep_stat.mtime then
              target_older_1of_depends = true
            end
          else
            # If dependence list includes symbol, need to execute
            target_older_1of_depends = true
          end
          next
        else
          # one of depends are symbol => forcely re-execute target
          target_older_1of_depends = true
        end
        puts "[DEBUG] : Depends Target \"#{dep}\" execute."
        do_target(dep)
      }
    end

    if target_older_1of_depends then
      # Execute commands!
      target.commands.each {|command|
        puts "#{command}"
        result = `#{command}`
        puts result
      }
    end
  else
    puts "Error: target \"#{name}\" not found."
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