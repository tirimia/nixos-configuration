;; Disable file name handler for performance during startup
(defvar backup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil
      ;; Set garbage collect high to speed up startup
      gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      ;; Ignore advice warnings
      ad-redefinition-action 'accept)

(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold 100000000
		      read-process-output-max (* 1024 1024)
		      gc-cons-percentage 0.1
		      file-name-handler-alist backup/file-name-handler-alist
		      ad-redefinition-action 'warn)))

;; Prevent package.el from loading, straight will deal with packages
(setq package-enable-at-startup nil)
