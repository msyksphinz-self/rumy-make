#!/usr/bin/ruby

define_method("execute") {|command|
  result = `#{command}`
  puts result
}

private def do_clean_target(name)
  if not $target_list.key?(name) then
    return
  end

  target = $target_list[name]
  target.depend_targets.each{|dep|
    do_clean_target(dep)
  }

  if not Symbol.all_symbols.include?(name) and File.exist?(name) then
    puts "[DEBUG] clean_target : remove " + name
    File.delete(name)
  end
end

def clean_target (name)
  if not $target_list.key?(name) then
    puts "Error: target \"#{name}\" not found."
    return
  end
  do_clean_target(name)

end