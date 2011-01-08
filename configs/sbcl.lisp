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

(sb-ext:restrict-compiler-policy 'debug 2)
