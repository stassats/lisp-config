(require :asdf)

(setf ccl:*default-file-character-encoding* :utf-8
      ccl:*default-socket-character-encoding* :utf-8
      (pathname-encoding-name) :utf-8
      ccl:*default-external-format* :utf-8)

(setf asdf:*central-registry*
      `(*default-pathname-defaults*
        ,(merge-pathnames "lisp/systems/"
                          (user-homedir-pathname)))
      asdf:*compile-file-failure-behaviour* :warn
      asdf::*uninteresting-conditions* nil
      asdf:*warnings-file-type* nil
      uiop/configuration:*user-cache*
      `(,(merge-pathnames "lisp/fasls/" (user-homedir-pathname)) :implementation))
