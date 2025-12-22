(use-package yaml-ts-mode
  :ensure nil
  :mode "\\.ya?ml\\'")

(use-package k8s-mode
  :mode (rx "/kubernetes/" (* not-newline) ".y" (? "a") "ml" eos))
