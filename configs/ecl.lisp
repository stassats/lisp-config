;;; -*- Mode: Lisp -*-

(load (merge-pathnames "lisp/configs/share.lisp" (user-homedir-pathname)))

(setf asdf:*central-registry*
      `(*default-pathname-defaults*))


;;; (si::pathname-translations "SYS" '(("**;*.*.*" "/home/stas/lisp/impl/ecl/build/**/*.*")))
