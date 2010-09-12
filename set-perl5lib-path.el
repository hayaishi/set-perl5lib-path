;-*- Emacs-Lisp -*-

(defun exists-envp (env-symbol value)
  (let* ((env (getenv env-symbol)))
    (cond ((null env)
           nil)
          ((numberp (string-match value env))
           t)
          (t nil))))

(defun join-string (separator target-list)
  (let* (joined-string
         (target (car target-list)))
    (if (not (null target-list))
      (setq joined-string (join-string separator (cdr target-list))))
    (if (null joined-string)
        target
      (concat target separator joined-string))))

(defun set-perl5lib-path (path dir-list)
  (interactive)
  (let* ((target-dir (car dir-list))
         (dir-list (cdr dir-list)))
    (if (stringp target-dir)
        (progn (set-perl5lib-path-2 path target-dir)
               (set-perl5lib-path path dir-list))
      (message "set PERL5LIB = %s" (getenv "PERL5LIB")))))

(defun set-perl5lib-path-2 (path dirname)
  (let* ((env (getenv "PERL5LIB"))
         (path-list (nreverse (cdr (nreverse (cdr (split-string path "/"))))))
         (counter (length path-list))
         (path-string (concat "/" (join-string "/" path-list)))
         (path-work (concat path-string "/" dirname)))
    (if (and
         (stringp path-string)
         (not (exists-envp "PERL5LIB" path-work)))
        (progn
          (cond ((file-directory-p path-work)
                 (setenv "PERL5LIB" (concat env path-work ":" )))
              (t (set-perl5lib-path-2 path-string dirname)))))))

(provide 'set-perl5lib-path)