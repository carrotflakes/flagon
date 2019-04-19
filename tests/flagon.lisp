(defpackage flagon-test
  (:use :cl
        :flagon
        :prove))
(in-package :flagon-test)

;; NOTE: To run this test file, execute `(asdf:test-system :flagon)' in your Lisp.

(plan nil)

(defvar *state* (flagon:state "first name:borowski"))

(multiple-value-bind (succ bindings)
    (flagon:match (flagon:pattern "+first") *state*)
  (is succ t)
  (is bindings nil))

(multiple-value-bind (succ bindings)
    (flagon:match (flagon:pattern "+name:borowski") *state*)
  (is succ t)
  (is bindings nil))

(multiple-value-bind (succ bindings)
    (flagon:match (flagon:pattern "name:$name") *state*)
  (is succ t)
  (is bindings '(("name" . "borowski")) :test #'equal))

(is (flagon:update *state*
                   (flagon:updater "-first +second"))
    (flagon:state "second name:borowski")
    :test #'equal)

(is (flagon:get-value "name" *state*)
    "borowski")

(is (flagon:update *state*
                   (flagon:updater "age:20"))
    (flagon:state "age:20 first name:borowski")
    :test #'equal)

(finalize)
