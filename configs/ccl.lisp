
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

#|
(in-package :ccl)

(set-development-environment t)

(defun c_gethostbyname (name)
  (with-cstrs ((name (string name)))
    (rlet ((result (* (struct :addrinfo))))
      (let ((err (#_getaddrinfo name (%NULL-PTR) (%NULL-PTR)
                                result)))
        (declare (fixnum err))
        (if (zerop err)
            (let ((result (%get-ptr result)))
              (prog1 (pref (pref result :addrinfo.ai_addr)
			   :sockaddr_in.sin_addr.s_addr)
                (#_freeaddrinfo result)))
            (values nil (- err)))))))

(defun c_gethostbyaddr (addr)
  (rlet ((sa :sockaddr_storage))
    (setf (pref sa :sockaddr_in.sin_family) #$AF_INET
          (pref sa :sockaddr_in.sin_addr.s_addr) addr)
    (%stack-block ((buf #$NI_MAXHOST))
      (let ((err (#_getnameinfo sa (record-length :sockaddr_in)
                                buf #$NI_MAXHOST
                                (%NULL-PTR) 0 0)))
        (declare (fixnum err))
        (if (zerop err)
            (%get-cstring buf)
            (values nil (- err)))))))

(set-user-environment t)
#|