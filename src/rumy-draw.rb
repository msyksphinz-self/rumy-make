#!/usr/bin/ruby

private def do_draw_target (name, spc, show_line_list, last_item)
  (1..spc).each_with_index {|_, i|
    if show_line_list.include?(i) then
      print "| "
    else
      print "  "
    end
  }
  if last_item then
    print "\`"
  else
    print "|"
  end
  print "-> Target : " + name.to_s

  if not $target_list.key?(name) then
    puts ""
    return
  else
    puts "\t\t\t\t// " + $target_list[name].commands.to_s
  end

  $target_list[name].depend_targets.each_with_index{|dep_name, index|
    new_show_line_list = show_line_list
    if $target_list[name].depend_targets.length-1 != index then
      new_show_line_list = new_show_line_list + [spc + 2]
      last_item = false
    else
      last_item = true
    end
    do_draw_target(dep_name, spc + 2, new_show_line_list, last_item)
  }
end


def draw_target (name)
  if not $target_list.key?(name) then
    puts "Error: target \"#{name}\" not found."
    exit
  end

  do_draw_target(name, 0, [], true)
end
