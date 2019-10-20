#/usr/bin/ruby

define_method("execute") {|command|
  result = `#{command}`
  puts "Result\n"
  puts "===================="
  puts result
  puts "====================\n\n"
}
