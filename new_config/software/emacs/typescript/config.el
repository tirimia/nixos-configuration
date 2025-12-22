;; TypeScript configuration
(use-package typescript-ts-mode
  :ensure nil
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  :config
  (defun tirimia/ts-setup ()
    "Customizations."
    (interactive)
    (setq-local eglot-server-programs
                `((typescript-ts-base-mode
                   . ("typescript-language-server" "--stdio"
                      :initializationOptions
                      (:preferences
                       (
                        :includeInlayParameterNameHints "literals"
                        :includeInlayFunctionParameterTypeHints t
                        :includeInlayVariableTypeHints :json-false
                        ))))))
    (eglot-ensure))
  :hook (typescript-ts-base-mode . tirimia/ts-setup))
