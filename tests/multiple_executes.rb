load "rumy-main.rb"

make_target :multiple_targets do
  global
  executes ["echo Hello, First Target!"]
  executes ["echo Hello, Second Target!!"]
end

exec_target :multiple_targets
