(defpackage flagon
  (:use :cl)
  (:import-from :flagon.parser
                :parse-pairs)
  (:import-from :flagon.condition
                :flagon-parse-error)
  (:export :state
           :pattern
           :updater
           :get-value
           :match
           :update))
(in-package :flagon)

(defun variablep (form)
  (and (listp form)
       (second form)))

(defun state (string &aux (ast (parse-pairs string)))
  (loop
    for (sign key value) in ast
    do (unless (eq sign :no-sign)
         (error 'flagon-parse-error :format-control "Sign is not allowed in state"))
       (when (variablep value)
         (error 'flagon-parse-error :format-control "Variable is not allowed in state"))
    collect (cons key value)))

(defun pattern (string &aux (ast (parse-pairs string)))
  (loop
    for (sign key value) in ast
    do (when (eq sign :no-sign)
         (setf sign :plus))
       (when (and (eq sign :minus) (variablep value))
         (error 'flagon-parse-error :format-control "Variable is not allowed with minus"))
    collect (list* sign key value)))

(defun updater (string &aux (ast (parse-pairs string)))
  (loop
    for (sign key value) in ast
    do (when (eq sign :no-sign)
         (setf sign :plus))
       (when (and (eq sign :minus) (variablep value))
         (error 'flagon-parse-error :format-control "Variable is not allowed with minus"))
    collect (list* sign key value)))

(defun get-value (key state &optional default)
  (let ((pair (assoc key state :test #'string=)))
    (if pair
        (cdr pair)
        default)))

(defun match (pattern state)
  (let ((bindings ()))
    (loop
      for (sign key . value) in pattern
      for state-pair = (assoc key state :test #'string=)
      do (ecase sign
           (:plus
            (cond
              ((null state-pair)
               (return-from match (values nil nil)))
              ((variablep value)
               (push (cons (variablep value) (cdr state-pair)) bindings))
              ((not (equal value (cdr state-pair)))
               (return-from match (values nil nil)))))
           (:minus
            (when state-pair
              (return-from match (values nil nil))))))
    (values t bindings)))

(defun update (state updater &optional bindings)
  (setf state (copy-list state))
  (loop
    for (sign key . value) in updater
    do (ecase sign
         (:plus
          (setf state (remove key state :test #'equal :key #'car))
          (push (cons key
                      (if (variablep value)
                          (cdr (or (assoc (variablep value)
                                          bindings
                                          :test #'string=)
                                   (error 'flagon-error
                                          :format-control "Variable ~a unbound"
                                          :format-arguments (list (variablep value)))))
                          value))
                state))
         (:minus
          (setf state (remove key state :test #'equal :key #'car)))))
  state)
