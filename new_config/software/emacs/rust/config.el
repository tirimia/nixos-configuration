(use-package rustic
  :config
  (setq rustic-format-on-save nil
        rustic-cargo-use-last-stored-arguments t
        rustic-lsp-client 'eglot)
  (defun tirimia/rust-setup ()
    "Fe2O3.unwrap()"
    (interactive)
    (setq-local eglot-server-programs
                '((rustic-mode .
                               ("rust-analyzer" :initializationOptions (:check (:command "clippy")))))))
  (add-to-list 'evil-emacs-state-modes 'rustic-popup-mode)
  :hook (rustic-mode . tirimia/rust-setup))
