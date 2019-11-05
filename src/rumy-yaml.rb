require 'yaml'

hash = {"Lemon" => 100, "Orange" => 150}


puts hash

hash.each{|key, value|
  print(key + "=>", value)
  puts ""
}


data = open(ARGV[0], 'r') { |f| YAML.load(f) }

def show_hash (hash_data, index)
  hash_data.each {|key, value|
    if key.kind_of?(Hash) then
      show_hash(key, index)
    else
      (1..index).each { print("_") }
      puts "key = " + key.to_s
      if value.kind_of?(Hash) then
        show_hash(value, index + 2)
      else
        (0..index).each { print("*") }
        puts value
      end
    end
  }
end


show_hash(data, 0)
