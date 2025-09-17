;; Core Emacs configuration
(require 'use-package)
(setq use-package-always-ensure t)

;; Yasnippet setup
(use-package yasnippet
  :config
  (yas-global-mode 1))

;; AAS (Auto-Activating Snippets) setup
(use-package aas
  :config
  (defun tirimia/aas-init ()
    "Set up aas for the global keymap."
    (interactive)
    (aas-activate-keymap 'global)
    (aas-activate-for-major-mode)))

;; Eglot setup (used instead of lsp-mode in your original config)
(use-package eglot
  :ensure nil
  :config
  (add-hook 'eglot-managed-mode-hook (lambda () (add-hook 'before-save-hook #'eglot-format-buffer t t))))
