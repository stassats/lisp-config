
(load (merge-pathnames "lisp/configs/share.lisp" (user-homedir-pathname)))

(setf ccl:*default-file-character-encoding* :utf-8
      ccl:*default-socket-character-encoding* :utf-8)

(nconc asdf:*central-registry*
       '("ccl:tools;advice-profiler;"))

(defun module-provide-asdf (name)
  (when (asdf:find-system name nil)
    (asdf:operate 'asdf:load-op name)
    t))

(pushnew 'module-provide-asdf CCL::*MODULE-PROVIDER-FUNCTIONS*)
