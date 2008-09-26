;;; -*- Mode: Lisp -*-

(declaim (optimize (compilation-speed 2) (debug 3) (safety 3)))

(unless (find :asdf *features*)
  #+(or clisp ecl)
  (load (merge-pathnames "lisp/site/asdf/asdf.lisp"
			 (user-homedir-pathname)))
  #+(or sbcl ccl)
  (require :asdf))

(setf asdf:*central-registry*
      `(*default-pathname-defaults*
	,(merge-pathnames "lisp/systems/" (user-homedir-pathname))))

(asdf:operate 'asdf:load-op :asdf-binary-locations)

(setf asdf:*centralize-lisp-binaries* t
      asdf:*default-toplevel-directory*
      (merge-pathnames "lisp/fasls/" (user-homedir-pathname)))

