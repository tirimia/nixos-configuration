;; TypeScript configuration
(use-package typescript-ts-mode
  :ensure nil
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  :config
  (aas-set-snippets 'typescript-ts-base-mode
    "ex "   "export "
    "asfn " '(yas "async function $1($2) {$0}")
    "clg " '(yas "console.log($1)$0")
    "cdest " '(yas "const { ${2:items} } = $1;$0")
    "impf" '(yas "import { ${2:import} } from '${1:from}';")
    "tgg" '(yas "<${1:tag}>$0</$1>")
    "tgc" '(yas "<$1 />$0"))
  (defun tirimia/ts-setup ()
    "Customizations."
    (interactive)
    (tirimia/aas-init)
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
