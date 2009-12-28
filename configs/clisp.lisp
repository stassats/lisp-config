(setf custom:*load-paths* '(#"P./"))
(load (merge-pathnames "lisp/configs/share.lisp" (user-homedir-pathname)))
