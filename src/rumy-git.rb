#!/usr/bin/env ruby

require 'git'
require 'logger'
require 'pathname'

def rumy_clone_git(url, dir)
  Git.clone(url, dir)
end

def rumy_log_git(filename)
  current_path = Pathname.new(".")
  toplevel_path = Pathname.new(`git rev-parse --show-toplevel`)
  puts "toplevel_path = " + toplevel_path.to_s
  # g = Git.open(toplevel_path, :log => Logger.new(STDOUT))
  puts current_path.relative_path_from(toplevel_path).to_s
  # gre = Git.open("../", :log => Logger.new(STDOUT))
  # g = Git.open(".", :log => Logger.new(STDOUT))
  # puts g.log
end
