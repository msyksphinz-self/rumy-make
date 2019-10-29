#!/usr/bin/ruby

def show_help
  puts "[HELP] ============================================="
  $target_list.each{|key, target|
    if target.help_message != "" and target.is_global == true then
      puts "[HELP] #{key} : " + target.help_message
    end
  }
  puts "[HELP] ============================================="
end
