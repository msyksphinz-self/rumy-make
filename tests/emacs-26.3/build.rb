#!/usr/env/bin ruby

external_make "lib", "lib"
external_make "lib-src", "lib-src"
external_target "src", "src", ["lib-src"]
external_make "lisp", "lisp"
external_make "info", "info"

make_target :all do
  global
  depends ["lib", "lib-src", "src", "lisp", "info"]
end
