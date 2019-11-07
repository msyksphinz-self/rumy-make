#!/usr/bin/ruby

def clear_env
  ENV.clear
end

def add_env_path(env_data)
  if ENV["PATH"] == nil then
    ENV["PATH"] = env_data
  else
    ENV["PATH"] += ":" + env_data
  end
end

def add_env_ldpath(env_data)
  if ENV["LD_LIBRARY_PATH"] == nil then
    ENV["LD_LIBRARY_PATH"] = env_data
  else
    ENV["LD_LIBRARY_PATH"] += ":" + env_data
  end
end


def add_env(env_name, env_data)
  ENV[env_name] = env_data
end

def show_env
  ENV.each{|k, e|
    puts "key = " + k + ", data = " + e
  }
end
