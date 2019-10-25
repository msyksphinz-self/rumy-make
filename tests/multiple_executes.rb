load "rumy-exec.rb"

make_target :multiple_targets do
  executes ["echo Hello, First Target!"]
  executes ["echo Hello, Second Target!!"]
end

exec_target :multiple_targets
