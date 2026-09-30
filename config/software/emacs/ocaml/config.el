(use-package neocaml
  :config
  ;; Register neocaml modes with Eglot
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((neocaml-mode neocaml-interface-mode) . ("ocamllsp"))))
  (defun tirimia/ocaml-setup ()
    "Camel go brr."
    (interactive)
    (eglot-ensure))
  :hook ((neocaml-mode neocaml-interface-mode) . tirimia/ocaml-setup))
