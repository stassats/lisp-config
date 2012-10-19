;; -*- Mode: Lisp -*-

(load (merge-pathnames "lisp/configs/share.lisp" (user-homedir-pathname)))

(setf asdf:*central-registry*
      (append (mapcar #'pathname
                      (mapcar #'directory-namestring
                              (directory "~/lisp/impl/abcl/contrib/*/*.asd")))
              asdf:*central-registry*))
