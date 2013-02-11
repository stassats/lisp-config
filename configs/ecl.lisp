;;; -*- Mode: Lisp -*-

(setf (logical-pathname-translations "SYS")
      '(("**;*.*.*" "/home/stas/lisp/impl/ecl/build/**/*.*"))
      (logical-pathname-translations "SRC")
      '(("**;*.*.*" "/home/stas/lisp/impl/ecl/src/**/*.*"))
      (logical-pathname-translations "EXT")
      '(("**;*.*.*" "/home/stas/lisp/impl/ecl/contrib/**/*.*"))
      (logical-pathname-translations "BUILD")
      '(("**;*.*.*" "/home/stas/lisp/impl/ecl/build/**/*.*")))

(setf *compile-verbose* nil
      *compile-print* nil
      *load-verbose* nil
      *load-print* nil)

(load (merge-pathnames "lisp/configs/share.lisp" (user-homedir-pathname)))
