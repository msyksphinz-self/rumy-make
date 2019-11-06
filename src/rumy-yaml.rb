require 'yaml'

load "rumy-cpp.rb"

data = open(ARGV[0], 'r') { |f| YAML.load(f) }

def show_hash (data)
  if data.kind_of?(Hash) then
    puts "It's Hash"
    data.each {|key, value|
      puts "Key = " + key.to_s
      show_hash(value)
    }
  elsif data.kind_of?(Array) then
    puts "It's Array"
    data.each {|elem|
      show_hash(elem)
    }
  else
    puts data
  end
end

show_hash(data)

@top_rule = ""

def obtain_rule (rule_array)
  # assert(rule_array.kind_of?(Array))
  rule_array.each {|rule|
    if rule.kind_of?(Hash)
      rule.each {|key, value|
        puts "rule = " + key
        if key == "top" then
          @top_rule = value[0]
        elsif value[0].key?("type") then
          if value[0]["type"][0] == "lib" then
            make_library_rule(key, value)
          elsif value[0]["type"][0] == "bin" then
            make_execute_rule(key, value)
          else
            puts "I don't know this type! \"" + value[0]["type"][0].to_s + "\""
            exit
          end
        else
          puts "Please define 'type' keys at the head of in each rule! "
          exit
        end
      }
    end
  }
end

def make_library_rule(lib_name, option_hash)
  # assert(rule_hash.kind_of?(Hash))

  lib_option_hash = Hash.new
  lib_option_hash['src_lists'      ] = []
  lib_option_hash['compile_options'] = []
  lib_option_hash['link_options'   ] = []
  lib_option_hash['depends'        ] = []

  option_hash.each {|elem|
    elem.each{|key, value|
      lib_option_hash[key] = value
    }
  }
  make_library(lib_name,
               lib_option_hash['src_lists'      ],
               lib_option_hash['compile_options'],
               lib_option_hash['link_options'   ],
               lib_option_hash['depends'        ])
end


def make_execute_rule(exe_name, option_hash)
  # assert(rule_hash.kind_of?(Hash))

  exe_option_hash = Hash.new
  exe_option_hash['src_lists'      ] = []
  exe_option_hash['lib_lists'      ] = []
  exe_option_hash['compile_options'] = []
  exe_option_hash['link_options'   ] = []
  exe_option_hash['link_libs'      ] = []
  exe_option_hash['depends'        ] = []

  option_hash.each {|elem|
    elem.each{|key, value|
      exe_option_hash[key] = value
    }
  }
  make_execute(exe_name,
               exe_option_hash['src_lists'      ],
               exe_option_hash['lib_lists'      ],
               exe_option_hash['compile_options'],
               exe_option_hash['link_options'   ],
               exe_option_hash['link_libs'      ],
               exe_option_hash['depends'        ])
end

obtain_rule data
exec_target @top_rule
