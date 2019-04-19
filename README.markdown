# Flagon
Flagon is a flag management DSL.

## Usage
``` lisp
(ql:quickload :flagon)

(defvar *state* (flagon:state "first hello"))
;; => (("first") ("hello"))

(multiple-value-bind (succ binding)
    (flagon:match (flagon:pattern "+first") *state*)
  (print succ) ; => T
  (print binding)) ; => NIL

(setf *state*
  (flagon:update *state*
    (flagon:updater "-first +second")))
;; => (("second") ("hello"))

(setf *state*
  (flagon:update *state* (flagon:updater "+name:borowski")))
;; => (("name" . "borowski") ("second") ("hello"))

(flagon:get-value "name" *state*)
;; => "borowski"
```

## Installation
``` sh
$ ros install carrotflakes/flagon
```

## Author

* carrotflakes (carrotflakes@gmail.com)

## Copyright

Copyright (c) 2019 carrotflakes (carrotflakes@gmail.com)

## License

Licensed under the LLGPL License.
