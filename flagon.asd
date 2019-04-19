#|
  This file is a part of flagon project.
  Copyright (c) 2019 carrotflakes (carrotflakes@gmail.com)
|#

#|
  Author: carrotflakes (carrotflakes@gmail.com)
|#

(defsystem "flagon"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on (snaky)
  :components ((:module "src"
                :components
                ((:file "flagon" :depends-on ("parser" "condition"))
                 (:file "parser")
                 (:file "condition"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "flagon-test"))))
