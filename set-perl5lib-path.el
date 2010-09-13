;-*- Emacs-Lisp -*-

(defun set-perl5lib-path (path dir-list)
  (interactive)
  (let* ((target-dir (car dir-list))
         (env (if (null (getenv "PERL5LIB"))
                  ""
                (getenv "PERL5LIB")))
         lib-path)
    (if (stringp target-dir)
        (progn (setq lib-path (get-perl5lib-path path target-dir))
               (setq env (set-perl5lib-path path (cdr dir-list)))))
    (if (and
         (stringp lib-path)
         (not (string-match lib-path env)))
        (setenv "PERL5LIB" (concat lib-path ":" env))
      env)))

(defun get-perl5lib-path (path dirname)
  (let* ((path-list (nreverse (cdr (nreverse (cdr (split-string path "/"))))))
         (path-string (concat "/" (mapconcat 'identity path-list "/" )))
         (lib-path (concat path-string "/" dirname)))
    (if (not (null path-list))
        (progn
          (cond ((file-directory-p lib-path)
                 lib-path)
                (t (get-perl5lib-path path-string dirname)))))))

(provide 'set-perl5lib-path)
