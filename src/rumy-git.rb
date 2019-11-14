#!/usr/bin/env ruby

require 'git'
require 'logger'
require 'pathname'

def rumy_clone_git(url, dir)
  # g = Git.open(toplevel_path)
  Git.clone(url, dir, :log => Logger.new(STDOUT))
  lock_file_loc = dir + "/" + ".rumy-lock"
  if not File.exist?(lock_file_loc) then
    loc_fp = File.open(lock_file_loc, "w")
    loc_fp.write("lock = true")
    loc_fp.close
  end
end

def rumy_is_git_modify_lock
  current_path = Pathname.new(`pwd`.sub("\n", ""))
  toplevel_path = Pathname.new(`git rev-parse --show-toplevel`.sub("\n", ""))
  if toplevel_path.to_s == "" then
    return false
  end
  git_root_relative = toplevel_path.relative_path_from(current_path).to_s
  lock_file_loc = git_root_relative + "/" + ".rumy-lock"
  if not File.exist?(lock_file_loc) then
    return false
  else
    File.open(lock_file_loc, "r"){|fp|
      fp.readlines.each{|line|
        if line.include?("lock = true")
          return true
        end
      }
    }
    return false
  end
end

def git_file_modified?(filename)
  current_path = Pathname.new(`pwd`.sub("\n", ""))
  toplevel_path = Pathname.new(`git rev-parse --show-toplevel`.sub("\n", ""))

  git_root_relative = toplevel_path.relative_path_from(current_path).to_s

  g = Git.open(toplevel_path)

  file_dir_from_root = current_path.relative_path_from(toplevel_path).to_s
  file_location = file_dir_from_root + "/" + filename
  if not File.exist?(filename) then
    puts "This file " + filename + " is not exist."
    return
  end

  return g.status.changed?(file_location)
end
