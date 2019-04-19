(defpackage flagon.condition
  (:use :cl)
  (:export :flagon-error
           :flagon-parse-error))
(in-package :flagon.condition)

(define-condition flagon-error (simple-error)
  ())

(define-condition flagon-parse-error (flagon-error)
  ())
