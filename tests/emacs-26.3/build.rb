#!/usr/env/bin ruby

external_make "lib", "lib"
external_make "lib-src", "lib-src"
external_target "src", "src"
external_make "lisp", "lisp"

make_target :all do
  global
  depends ["lib", "lib-src", "src", "lisp"]
end
