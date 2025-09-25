(use-package elixir-ts-mode
  :ensure nil
  :mode
  "\\.elixir\\'"
  "\\.ex\\'"
  "\\.exs\\'"
  "\\mix.lock\\'"
  :config
  (defun tirimia/elixir-setup ()
    "Liquid gold."
    (interactive)
    (setq-local eglot-server-programs '((elixir-mode "elixir-ls")))
    (eglot-ensure))
  (defun tirimia/heex-setup ()
    "Template."
    (interactive)
    (setq-local eglot-server-programs '((elixir-mode "elixir-ls")))
    (eglot-ensure))
  :hook
  (elixir-ts-mode . tirimia/elixir-setup)
  (heex-ts-mode . tirimia/elixir-setup))


(use-package gleam-ts-mode
  :mode (rx ".gleam" eos)
  :hook (gleam-ts-mode . eglot-ensure)
  :config (add-to-list 'eglot-server-programs
		       '(gleam-ts-mode . ("gleam" "lsp"))))
