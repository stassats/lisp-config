;; -*- Mode: Lisp -*-

(load (merge-pathnames "lisp/configs/share.lisp" (user-homedir-pathname)))

(sb-ext:set-sbcl-source-location (~ #-x86 "lisp/impl/sbcl/"
                                    #+x86 "lisp/impl/sbcl-x86/"))

(let ((sb-ext:*muffled-warnings* 'sb-kernel::redefinition-warning))
  (defmethod asdf:perform :around ((o asdf:load-op)
				   (c asdf:cl-source-file))
    (handler-case (call-next-method o c)
      ;; If a fasl was stale, try to recompile and load (once).
      (sb-ext:invalid-fasl ()
	(asdf:perform (make-instance 'asdf:compile-op) c)
	(call-next-method)))))

(setf sb-ext:*disassemble-annotate* nil)

(when (find-package :sb-regalloc)
  (setf (symbol-value (find-symbol "*REGISTER-ALLOCATION-METHOD*" :sb-regalloc))
        :iterative))

#+#.(cl:if (cl:find-package :sb-unicode) '(:and) '(:or))
(setf (sb-impl::%readtable-normalization *readtable*) nil
      (sb-impl::%readtable-normalization sb-impl::*standard-readtable*) nil)

(defun :tct (&rest targets)
  (setf sb-c::*compiler-trace-output*
        (if (and (progn
                   t
                   #+#.(cl:if (cl:find-symbol "*COMPILE-TRACE-TARGETS*" :sb-c) '(:and) '(:or))
                   (equal (shiftf sb-c::*compile-trace-targets* targets)
                          targets))
                 sb-c::*compiler-trace-output*)
            nil
            *standard-output*)))

(setf *print-right-margin* 157)
