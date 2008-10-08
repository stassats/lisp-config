;;; -*- Mode: Lisp -*-

(setf
 *compile-verbose* nil
 *compile-print* nil
 ext:*gc-verbose* nil)

(load (merge-pathnames "lisp/configs/share.lisp" (user-homedir-pathname)))
