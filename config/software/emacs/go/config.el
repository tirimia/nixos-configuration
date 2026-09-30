(use-package go-ts-mode
  :ensure nil
  :mode "\\.go\\'"
  :config
  (defun tirimia/go-setup ()
    "Customizations."
    (interactive)
    (setq-local eglot-workspace-configuration
                '((:gopls . ((gofumpt . t)))))
    (eglot-ensure))
  (add-hook 'go-ts-mode-hook #'tirimia/go-setup))
