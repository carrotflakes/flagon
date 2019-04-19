#|
  This file is a part of flagon project.
  Copyright (c) 2019 carrotflakes (carrotflakes@gmail.com)
|#

(defsystem "flagon-test"
  :defsystem-depends-on ("prove-asdf")
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("flagon"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "flagon"))))
  :description "Test system for flagon"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
