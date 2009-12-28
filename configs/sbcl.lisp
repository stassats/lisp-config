;; -*- Mode: Lisp -*-

(load (merge-pathnames "lisp/configs/share.lisp" (user-homedir-pathname)))

(let ((sb-ext:*muffled-warnings* 'sb-kernel::redefinition-warning))
  (defmethod asdf:perform :around ((o asdf:load-op)
				   (c asdf:cl-source-file))
    (handler-case (call-next-method o c)
      ;; If a fasl was stale, try to recompile and load (once).
      (sb-ext:invalid-fasl ()
	(asdf:perform (make-instance 'asdf:compile-op) c)
	(call-next-method)))))

(nconc asdf:*central-registry*
      '((let ((asdf::home (posix-getenv "sbcl_home")))
	  (when (and asdf::home (not (string= asdf::home "")))
	    (merge-pathnames "site-systems/" (truename asdf::home))))))

(declaim (optimize (sb-c::let-conversion 0)))
