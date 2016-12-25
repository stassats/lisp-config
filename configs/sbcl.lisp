;; -*- Mode: Lisp -*-

(load (merge-pathnames "lisp/configs/share.lisp" (user-homedir-pathname)))

(sb-ext:set-sbcl-source-location (~ #-x86 "lisp/impl/sbcl/"
                                    #+x86 "lisp/impl/sbcl-x86/"))

(setf sb-ext:*disassemble-annotate* nil)

(when (find-package :sb-regalloc)
  (setf (symbol-value (find-symbol "*REGISTER-ALLOCATION-METHOD*" :sb-regalloc))
        :iterative))

#+#.(cl:if (cl:find-package :sb-unicode) '(:and) '(:or))
(setf (sb-impl::%readtable-normalization *readtable*) nil
      (sb-impl::%readtable-normalization sb-impl::*standard-readtable*) nil)

(defun :tct (&rest targets)
  (when targets
    #+#. (cl:if (cl:find-symbol "*COMPILE-TRACE-TARGETS*" :sb-c) '(:and) '(:or))
    (setf sb-c::*compile-trace-targets* targets))
  (setf sb-c::*compiler-trace-output*
        (if sb-c::*compiler-trace-output*
            nil
            *standard-output*)))
