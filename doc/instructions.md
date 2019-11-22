# 1. First simple example

## Basic Syntax of Rumy-Make

Make following file

```ruby
#!/usr/bin/env ruby

make_target :all do
  executes ["echo Hello, World"]
end
```

This code defines rule of Rumy. It corresponds to Makefile:

```make
all :
    echo Hello, World
```

In Rumy, `:all` is special label that `rumy build`, `rumy clean` command are at first trying to find `:all` label target.

Rumy build starts from target rule `:all`.

```sh
rumy build
```
```
Hello, World
```

## Execute Multiple commands

You can put multiple `executes` commands on each rule:

```ruby
make_target :all do
  executes ["echo Hello 1"]
  executes ["echo Hello 2"]
  ## You don't have to write like this:
  ## executes ["echo Hello 1; echo Hello 2"]
end
```

Each commands are executed sequentially.

# 2. Define Dependencies

Rumy-Make can define dependencies for each rules.

```ruby
make_target :all do
  depends [:sub_rule]
  executes ["echo Hello, World"]
end

make_target :sub_rule do
  executes ["echo This is subrule!"]
end
```

`:all` target depends on `:sub_rule`. Before executing `:all`'s command, `:sub_rule`'s command is executed.

It corresponds to Makefile:

```make
all : sub_rule
    echo Hello, World
sub_rule :
    echo This is subrule!
```
