;;; -*- Mode: Lisp -*-

(declaim (optimize (compilation-speed 2) (debug 3) (safety 3)))

(unless (find :asdf *features*)
  #+(or clisp ecl cmu)
  (load (merge-pathnames "lisp/site/asdf/asdf"
			 (user-homedir-pathname))
        :verbose nil)
  #+(or sbcl ccl acl)
  (require :asdf))

(setf asdf:*central-registry*
      `(*default-pathname-defaults*
	,(merge-pathnames "lisp/systems/" (user-homedir-pathname))))

(asdf:operate 'asdf:load-op :asdf-binary-locations :verbose nil)

(setf asdf:*centralize-lisp-binaries* t
      asdf:*default-toplevel-directory*
      (merge-pathnames "lisp/fasls/" (user-homedir-pathname)))

