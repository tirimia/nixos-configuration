;; Rust configuration
(use-package rustic
  :config
  (setq rustic-format-on-save nil
        rustic-cargo-use-last-stored-arguments t
        rustic-lsp-client 'eglot)
  (add-to-list 'evil-emacs-state-modes 'rustic-popup-mode))
