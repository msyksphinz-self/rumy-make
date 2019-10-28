#!/usr/bin/ruby

define_method("execute") {|command|
  result = `#{command}`
  puts result
}


$target_list = Hash.new

class Target
  def initialize(name)
    @name = name
    @depend_targets = []
    @help_message = ""
    @commands = []
    @global = false
  end

  def depends(targets)
    if not targets.kind_of?(Array) then
      puts "ERROR: \"depends\" should be specified as List. Did you forget to add '[', ']'?"
      exit
    end
    @depend_targets = targets
  end

  def executes(commands)
    if not commands.kind_of?(Array) then
      puts "ERROR: \"executes args\" should be specified as List. Did you forget to add '[', ']'?"
      exit
    end
    @commands += commands
  end

  def explain(message)
    @help_message = message
  end

  def show
    puts "[DEBUG] : Target Created  = #{@name}, Depends = #{@depends}, Commands = #{@commands}"
  end

  def global
    @is_global = true
  end

  attr_reader :name
  attr_reader :commands
  attr_reader :depend_targets
  attr_reader :help_message
  attr_reader :is_global
end


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

def show_help
  puts "[HELP] ============================================="
  $target_list.each{|key, target|
    if target.help_message != "" and target.is_global == true then
      puts "[HELP] #{key} : " + target.help_message
    end
  }
  puts "[HELP] ============================================="
end
