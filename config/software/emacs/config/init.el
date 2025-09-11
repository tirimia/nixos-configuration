;;; init.el --- Excellent-ish emacs config
;;; Commentary:
;; Emacs startup file

;; This is my config.

;;

;;; Code:
(setq package-archives '(("org" . "https://orgmode.org/elpa/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(require 'use-package)
(use-package use-package
  :init (if init-file-debug
            (setq-default use-package-verbose t
                          use-package-expand-minimally nil
                          use-package-compute-statistics t
                          debug-on-error t)
          (setq-default use-package-verbose nil
			use-package-expand-minimally )))
(setq use-package-always-ensure t)

(use-package emacs
  :ensure nil
  :init
  (setq inhibit-startup-message t)   ;no startup screen
  (tool-bar-mode -1)                 ;no toolbar
  (menu-bar-mode -1)                 ;no menubar
  (scroll-bar-mode -1)               ;no scrollbar
  (global-display-line-numbers-mode -1) ;; TODO make weight thin and height 1, also figure out how to shrink the bar
  (electric-pair-mode) ;; autocompletes parens _and_ does the enter and indent how I expect it
  (setq ring-bell-function 'ignore)  ;no ringing bells
  (defalias 'yes-or-no-p 'y-or-n-p)
  (setq line-number-mode t)
  (setq column-number-mode t)
  (setq make-backup-files nil)
  (setq auto-save-default nil)
  (setq custom-file (make-temp-name "/tmp/"))
  (setq initial-scratch-message nil)
  (setq-default indent-tabs-mode nil
		            tab-width 2)
  (toggle-frame-maximized)
  (load-theme 'modus-vivendi-tinted)
  (add-to-list 'default-frame-alist '(font . "Iosevka Comfy Wide:pixelsize=20:weight=medium:slant=normal:width=normal:spacing=100:scalable=true"))
  (defun make-directory-maybe (orig-fun filename &optional wildcards)
    "Create parent directory if not exists before visiting file."
    (unless (file-exists-p filename)
      (let ((dir (file-name-directory filename)))
        (unless (file-exists-p dir)
          (make-directory dir t))))
    (funcall orig-fun filename wildcards))
  (advice-add 'find-file :around #'make-directory-maybe))

(use-package evil
  :init
  (setq evil-want-keybinding nil
        evil-undo-system #'undo-redo)
  :config
  (setq evil-want-keybinding t
	      evil-split-window-below t
	      evil-vsplit-window-right t)
  (evil-mode 1)
  (defun evil-binary-split ()
    "Split the window in two."
    (interactive)
    (if (> (window-pixel-width) (window-pixel-height))
	      (evil-window-vsplit)
      (evil-window-split)))
  ;; (defun new-line-dwim ()
  ;;   "Inserts newline and does the fun double enter back and tab if in a brace"
  ;;   (interactive)
  ;;   (let ((break-open-pair (or (and (eq (char-before) ?{) (looking-at "}"))
  ;;                              (and (eq (char-before) ?>) (looking-at "<"))
  ;;                              (and (eq (char-before) ?\() (looking-at ")"))
  ;;                              (looking-at ")$")
  ;;                              (and (eq (char-before) ?\[) (looking-at "\\]")))))
  ;;     (newline)
  ;;     (when break-open-pair
  ;;       (save-excursion
  ;;         (newline)
  ;;         (indent-for-tab-command)))
  ;;     (indent-for-tab-command)))
  ;; (evil-define-key 'insert prog-mode-map (kbd "RET") #'tirimia/ret-or-tempel-next)
  (add-to-list 'evil-emacs-state-modes 'dired-mode)
  (add-to-list 'evil-emacs-state-modes 'special-mode)
  (add-to-list 'evil-emacs-state-modes 'compilation-mode))
(use-package evil-multiedit
  :config (evil-multiedit-default-keybinds))
(use-package evil-escape
  :config
  (setq evil-escape-key-sequence "jk")
  (setq evil-escape-unordered-key-sequence t)
  (setq evil-escape-delay 0.15)
  (evil-escape-mode))
(use-package evil-snipe
  :config
  (evil-snipe-mode 1)
  (evil-snipe-override-mode 1)
  (setq evil-snipe-spillover-scope 'whole-visible))
(use-package evil-surround ;; ysiw[ to add square braces around word selection
  :config
  (defun tirimia/surround-yasnippet ()
    "Surrounds selection with yasnippet."
    (interactive)
    (unless (functionp #'yas-expand-snippet) (error "YASnippet expand function not found, is it loaded?"))
    (unless (region-active-p) (error "Cannot surround with a yasnippet when no selection is made"))
    (unless yas-minor-mode (error "YASnippet minor mode is not active in this buffer"))
    (let* ((templates (yas--all-templates (yas--get-snippet-tables major-mode)))
           (filter (lambda (elem) (string-search "`yas-selected-text`" (yas--template-content elem))))
           (valid-snippets (seq-filter filter templates))
           (snippet (yas--prompt-for-template valid-snippets)))
      (yas-expand-snippet snippet)))
  ;; TODO: look into default value more, some gems in there
  (evil-define-key 'visual 'global-map "Y" #'tirimia/surround-yasnippet)
  (setq-default evil-surround-pairs-alist '((?\( "(" . ")")
                                            (?\[ "[" . "]")
                                            (?\{ "{" . "}")
                                            (?\> "<" . ">")
                                            (?\< "<" . ">")
                                            (?t . evil-surround-read-tag)
                                            (?f . evil-surround-function)))

  (global-evil-surround-mode 1))
(use-package evil-exchange
  :config
  (setq evil-exchange-key "ge")
  (evil-exchange-install))
(use-package evil-collection
  :config (evil-collection-init '(calc org magit vterm)))
(use-package evil-textobj-tree-sitter
  :config
  ;; TODO: figure out how to do dsf to delete surrounding function, needs to somehow interract with surround
  (define-key evil-outer-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.outer"))
  (define-key evil-inner-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.inner"))
  (define-key evil-outer-text-objects-map "c" (evil-textobj-tree-sitter-get-textobj "class.outer"))
  (define-key evil-inner-text-objects-map "c" (evil-textobj-tree-sitter-get-textobj "class.inner")))
(use-package evil-matchit
  :config (global-evil-matchit-mode))

(use-package ace-window
  :config (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :bind
  ("M-o" . ace-window))

(use-package flick
  :vc (:url "https://github.com/tirimia/flick" :rev :newest)
  :bind ("C-c f" . flick))

(setq display-buffer-alist
      '(("\\*eldoc\\*"
         (display-buffer-in-side-window)
         (side . bottom)
         (slot . -1)
         (window-height . 0.3))
        ("\\*compilation\\*"
         (display-buffer-in-side-window)
         (side . bottom)
         (slot . 1)
         (window-height . 0.3))))

(defun tirimia/move-to-side-bottom ()
  "Move buffer to the side window on the bottom."
  (interactive)
  (let ((buf (current-buffer))
        (wind (selected-window)))
    (display-buffer-in-side-window buf '((side . bottom) (window-height . 0.3)))
    (delete-window wind)))

(use-package direnv
  :config (direnv-mode))

(use-package magit)
(use-package forge
  :after magit
  :config
  (setq ghub-use-workaround-for-emacs-bug 'force)
  
  (defun ghub-token-from-gh (host username package &optional nocreate forge)
    (string-trim (shell-command-to-string "gh auth token")))
  
  (advice-add 'ghub--token :override #'ghub-token-from-gh))

(use-package which-key
  :config (which-key-mode))
(use-package general
  :config (general-evil-setup t)
  (general-create-definer tirimia/leader-def
    :keymaps '(normal visual motion)
    :prefix "SPC")
  ;; Without this statement, the motion state SPC being bound completely messes up the other bindings.
  (general-def :states '(motion) "SPC" nil)
  (tirimia/leader-def
    "SPC" '(consult-buffer :wk "Switch")
    "'" (list (lambda () (interactive) (vterm t)) :which-key "Shell")
    "/" '(consult-ripgrep :wk "Project search")
    "c" '(kill-buffer-and-window :wk "Close")
    "f" '(find-file :wk "Find file")
    "g" '(magit-status :wk "Magit")
    "h" '(helpful-symbol :which-key "Help")
    "k" '(kill-current-buffer :wk "Kill current buffer")

    "m" '(:ignore t :which-key "Meta")
    "mc" '(compile :which-key "Compile")
    "mr" '(project-compile :which-key "Compile in root")
    "mm" '(recompile :which-key "Recompile")
    "ms" '(recompile-on-save-mode :which-key "Toggle autorecompile")

    ;; TODO: consider flymake-show-diagnostics-buffer
    "te" '(consult-flymake :wk "Go to error")
    "tl" '(global-display-line-numbers-mode :wk "Line numbers")
    "ts" '(flick :wk "Make side window")

    "w" '(:ignore t :wk "Window")
    "wd" '(evil-window-delete :wk "Delete")
    "ws" '(evil-window-split :wk "Split")
    "wv" '(evil-window-vsplit :wk "VSplit")
    "ww" '(evil-binary-split :wk "Smart Split")
    ))

(use-package vterm
  :init (setq-default vterm-always-compile-module t)
  :general (:keymaps 'vterm-mode-map
                     "C-c C-d" `((lambda () (interactive) (vterm-send "C-d")) :which-key "C-d"))
  :config
  (add-to-list 'evil-insert-state-modes 'vterm-mode)
  (defun tirimia/vterm-startup ()
    (hl-line-mode -1)
    (display-line-numbers-mode -1))
  :hook (vterm-mode . tirimia/vterm-startup))

(use-package aggressive-indent)

(use-package savehist
  :config
  (savehist-mode))

(use-package vertico
  :config
  (vertico-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (orderless-matching-styles '(orderless-flex)))

(use-package marginalia
  :config (marginalia-mode))

(use-package projectile
  :custom
  (projectile-completion-system 'auto)
  (projectile-indexing-method 'alien)
  (projectile-enable-caching nil)
  (projectile-ignored-project-function
   (lambda (path) (cl-some
                   (lambda (prefix) (string-prefix-p prefix path))
                   '("/nix/store/" "~/.cargo/registry"))))
  :config
  (projectile-mode))

(use-package smart-delete
  :hook (prog-mode . smart-delete-mode))

(use-package consult
  :bind
  (("M-g M-g" . consult-goto-line)
   ("M-y" . consult-yank-pop))
  :config (setq
           consult-ripgrep-args "rg --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --with-filename --line-number --search-zip --hidden --glob=!.git/ --glob=!vendor/"))
(use-package consult-projectile
  :config
  (setq consult-buffer-sources '(consult--source-buffer consult-projectile--source-projectile-file consult-projectile--source-projectile-project)))

(use-package nerd-icons
  :disabled
  :config
  (defun tirimia/install-nerd-icons-if-necessary ()
    "Only ins necessary (aka core font not found)"
    (unless (ignore-errors (find-font (font-spec :family "Symbols Nerd Font Mono")))
      (nerd-icons-install-fonts t)))
  (tirimia/install-nerd-icons-if-necessary))

(use-package telephone-line
  :config (telephone-line-mode))

(use-package indent-guide
  :config (indent-guide-global-mode))

(use-package dtrt-indent
  :config (dtrt-indent-global-mode))

(use-package rainbow-delimiters
  :hook prog-mode)

(use-package ligature
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

(use-package helpful
  :general
  ("C-h f" 'helpful-callable)
  ("C-h v" 'helpful-variable)
  ("C-h k" 'helpful-key)
  :config
  (setq help-window-select t)
  (add-to-list 'evil-motion-state-modes 'helpful-mode))

(use-package editorconfig
  :commands (editorconfig-mode)
  :config (editorconfig-mode))

(use-package flymake
  :ensure nil
  :init
  (defun tirimia/disable-flymake-eldoc ()
    "Get rid of the flymake messages in the echo area."
    (setq eldoc-documentation-functions
          (remove #'flymake-eldoc-function eldoc-documentation-functions)))
  :hook prog-mode
  :config
  (add-hook 'flymake-mode-hook #'tirimia/disable-flymake-eldoc)
  (setq flymake-show-diagnostics-at-end-of-line 'short))

(use-package package-lint)

(use-package flymake-diagnostic-at-point
  :config
  (defun tirimia/flymake-at-point ()
    "Interactive wrapper around `flymake-diagnostic-at-point-maybe-display'."
    (interactive) (flymake-diagnostic-at-point-maybe-display))
  (defun tirimia/flymake-posframe-display (diagnostic-string)
    "Display DIAGNOSTIC-STRING in a posframe."
    (interactive)
    (let ((dialog-name "flymake-diag"))
      (posframe-show dialog-name
                     :position (point)
                     :internal-border-width 2
                     :border-width 2
                     :child-frame t
                     :parent-frame (window-frame (selected-window))
                     :string (propertize
                              diagnostic-string
                              'face (if-let ((type (get-char-property (point) 'flymake-diagnostic)))
                                        (pcase (flymake--diag-type type)
                                          (:error 'error)
                                          (:warning 'warning)
                                          (:note 'success)
                                          (_ 'default))
                                      'default)))
      ;; Auto-hide on move
      (unwind-protect
          (push (read-event) unread-command-events)
        (progn
          (posframe-hide dialog-name)))))
  (setq flymake-diagnostic-at-point-display-diagnostic-function #'tirimia/flymake-posframe-display)
  :bind
  (:map evil-normal-state-map
        ("H" . tirimia/flymake-at-point)))

(use-package eldoc-box
  :bind
  (:map evil-normal-state-map
	("K" . eldoc-box-help-at-point))
  :config
  (add-hook 'eldoc-box-buffer-setup-hook #'eldoc-box-prettify-ts-errors 0 t))

(use-package eglot
  :ensure nil
  ;; TODO: look into eglot-x for fancy rust-analyzer stuff
  ;; TODO: find better way to xref
  :bind (:map eglot-mode-map
	            ("s-l a" . eglot-code-actions)
	            ("s-l r" . eglot-rename)
	            ("s-l =" . eglot-format-buffer)
	            ("s-l h" . eldoc-print-current-symbol-info))
  :config
  (add-to-list 'evil-motion-state-modes 'xref--xref-buffer-mode)
  (add-hook 'eglot-managed-mode-hook (lambda () (add-hook 'before-save-hook #'eglot-format-buffer t t))))

(use-package tempel
  :config
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.
    ;; `tempel-expand' only triggers on exact matches. Alternatively use
    ;; `tempel-complete' if you want to see all matches, but then you
    ;; should also configure `tempel-trigger-prefix', such that Tempel
    ;; does not trigger too often when you don't expect it. NOTE: We add
    ;; `tempel-expand' *before* the main programming mode Capf, such
    ;; that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions))))
(use-package yasnippet
  :bind
  (:map evil-insert-state-map
        ("C-p" . yas-insert-snippet)
        :map yas-keymap
        ("RET" . yas-next-field)
        ("TAB" . nil)))
(yas-global-mode 1) ;; Still don't understand why this doesn't work inside the :config property of the yasnippet use package

(use-package templateforge
  :vc t
  :load-path "~/Personal/templateforge/"
  :config (templateforge-mode 1))

(use-package aas
  ;; TODO: decide how to structure this: snippets with the modes or all in this block
  ;; TODO: have another function that you can just pass the suffixes and templates and it does the rest and you can expand it in the aas-set-snipets block
  :config
  (defun tirimia/surround-postfix (suffix snippet-name mode)
    "Generate function for aas to have access via SUFFIX to yasnippet named SNIPPET-NAME for MODE that need to select the previous word.
  Example usage:
  (aas-set-snippets 'emacs-lisp-mode
    \".he\" (tirimia/surround-postfix \".he\" \"laugh-snip\" 'emacs-lisp-mode))
  "
    (let ((snip (yas-lookup-snippet snippet-name mode)))
      (unless snip (error "YASnippet snippet '%s' not found during lambda generation" snippet-name))
      ;; TODO: also validate the snippet contains `yas-selected-text'
      `(lambda ()
         (interactive)
         ;; (delete-char (- (length ,suffix))) ;; No need to delete suffix, aas does it for me
         (set-mark (point))
         (search-backward-regexp (rx symbol-start))
         (yas-expand-snippet ,snip))))
  (defun tirimia/aas-set-yas-for-mode (mode snips)
    "Set yasnippets for MODE in bulk via lookups in SNIPS."
    (interactive)
    (apply #'aas-set-snippets mode
           (apply #'append
                  (mapcar
                   (lambda (pair)
                     (let ((shortcut (car pair)) (snippet-name (cdr pair)))
                       `(,shortcut (yas ,(yas-lookup-snippet snippet-name mode)))))
                   snips))))
  ;; (aas-set-snippets 'global
  ;;   "cmm " '(yas "`comment-start`")
  ;;   "todo " '(yas "`comment-start`TODO: "))
  (tirimia/aas-set-yas-for-mode 'prog-mode
                                '(("cmm " . "comment")
                                  ("todo " . "todo")))
  (aas-set-snippets 'emacs-lisp-mode
    "usp "   '(yas "(use-package $0)"))
  (aas-set-snippets 'python-base-mode
    "ifma " '(yas "if __name__ == \"__main__\":\n\t$0")
    "dini " '(yas "def __init__(self, $1):\n\t$0")
    "smirr" '(yas "self.$1 = $1")
    "decla " '(yas "class ${1:ClassName}(${2: ${3:parent}}):\n\t"))
  (aas-set-snippets 'latex-mode
    "breg" '(yas "\\begin{$1}\n\t$0\n\\end{$1}")
    "/bi" '(yas "\\begin{itemize}\n\t$0\n\\end{itemize}")
                                        ;".bf" (tirimia/surround-postfix ".bf" "bf" 'latex-mode)
    )
  (aas-set-snippets 'nix-ts-mode
    "dbg" '(yas "dbg!(`(let ((node (treesit-node-at (point))))
                         (if node (treesit-node-text node t) \"\"))`)$0"))
  (defun tirimia/aas-init ()
    "Set up aas for the global keymap."
    (interactive)
    (aas-activate-keymap 'global)
    (aas-activate-for-major-mode)))

(use-package cape
  :config
  (add-hook 'eglot-managed-mode-hook
	          (lambda ()
	            (setq completion-at-point-functions
		                (list #'eglot-completion-at-point
			                    #'cape-file
			                    #'cape-dabbrev)))))
(use-package corfu
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  :bind
  (:map corfu-map
        ("C-h" . corfu-popupinfo-toggle)
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous))
  :config
  (setq corfu-auto t
	corfu-auto-delay 0.1
	corfu-auto-prefix 1
	corfu-preselect 'prompt
	corfu-cycle t
	corfu-preview-current 'insert
	completion-ignore-case t))

(use-package recompile-on-save)
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

;; Languages
(use-package emacs-lisp-mode
  :no-require t ;; Do not remove this, causes the hook at the end to stack overflow
  :ensure nil
  :config
  (defun tirimia/emacs-lisp-setup ()
    "Goodies for elisp."
    (interactive)
    (setq-local comment-start ";; ")
  (tirimia/aas-init)
  (aggressive-indent-mode))
  (add-hook 'emacs-lisp-mode-hook #'tirimia/emacs-lisp-setup))

(use-package go-ts-mode
  :ensure nil
  :mode "\\.go\\'"
  :config
  (defun tirimia/go-setup ()
    "Customizations."
    (interactive)
    (setq-local eglot-workspace-configuration
                '((:gopls . ((gofumpt . t)))))
    (tirimia/aas-init)
    (eglot-ensure))
  (add-hook 'go-ts-mode-hook #'tirimia/go-setup))

(use-package rustic
  :config
  (setq rustic-format-on-save nil
	rustic-cargo-use-last-stored-arguments t
	rustic-lsp-client 'eglot)
  (add-to-list 'evil-emacs-state-modes 'rustic-popup-mode))

(use-package typescript-ts-mode
  :ensure nil
  :mode (("\\.ts\\'" . typescript-ts-mode)
	       ("\\.tsx\\'" . tsx-ts-mode))
  :config
  (aas-set-snippets 'typescript-ts-base-mode
    "ex "   "export "
    "asfn " '(yas "async function $1($2) {$0}")
    ;; TODO: see if the $1 in the console log can't also be yas-selected-text in case of a selection
    ;; TODO: check if yasnippets can be called by name
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

(use-package yaml-ts-mode
  :ensure nil
  :mode "\\.ya?ml\\'")

(use-package k8s-mode
  :mode (rx "/kubernetes/" (* not-newline) ".y" (? "a") "ml" eos))

(use-package nix-ts-mode
  :mode "\\.nix\\'"
  :hook (nix-ts-mode . eglot-ensure))

(use-package gleam-ts-mode
  :mode (rx ".gleam" eos)
  :hook (gleam-ts-mode . eglot-ensure)
  :config (add-to-list 'eglot-server-programs
		       '(gleam-ts-mode . ("gleam" "lsp"))))

(use-package astro-ts-mode
  :mode (rx ".astro" eos))

(use-package lsp-mode
  :config (setq lsp-headerline-breadcrumb-enable nil))

(use-package lsp-haskell)
(use-package haskell-mode
  :mode (rx ".hs" eos)
  :config (aas-set-snippets 'haskell-mode
            "ccm " '(yas "-- >>> $1\n$0"))
  (defun tirimia/haskell-setup ()
    "Setup for the maff GOAT."
    (interactive)
    (tirimia/aas-init)
    (lsp-deferred))
  :hook (haskell-mode . tirimia/haskell-setup))

(use-package nushell-ts-mode
  :config
  (defun tirimia/nushell-setup ()
    "Time for the nu shizz."
    (interactive)
    (eglot-ensure))
  :hook (nushell-ts-mode . tirimia/nushell-setup))

(use-package elixir-ts-mode
  :ensure nil
  :mode
  "\\.elixir\\'"
  "\\.ex\\'"
  "\\.exs\\'"
  "\\mix.lock\\'"
  :config
  (tirimia/aas-set-yas-for-mode 'heex-ts-mode
                                '(("tgg " . "tag")
                                  ("tgc " . "self-closing tag")))
  (tirimia/aas-set-yas-for-mode 'elixir-ts-mode
                                '(("kk " . "ok tuple")
                                  ("km " . "ok match")
                                  ("errm " . "error match")
                                  ("asseq " . "assert equals")))
  (defun tirimia/elixir-setup ()
    "Liquid gold."
    (interactive)
    (tirimia/aas-init)
    (setq-local eglot-server-programs '((elixir-mode "elixir-ls")))
    (eglot-ensure))
  (defun tirimia/heex-setup ()
    "Template."
    (interactive)
    (tirimia/aas-init))
  :hook
  (elixir-ts-mode . tirimia/elixir-setup)
  (heex-ts-mode . tirimia/elixir-setup))

(use-package kotlin-ts-mode
  :mode (rx ".kt" (? "s") eos)
  :config
  (defun tirimia/kotlin-setup ()
    "Kotlincho."
    (interactive)
    (setq-local eglot-server-programs '((kotlin-ts-mode "kotlin-lsp" "--stdio"))
                eglot-autoshutdown t
                eglot-extend-to-xref t
                eglot-sync-connect 1
                eglot-connect-timeout 99999 ;; Inits take ages
                eglot-report-progress t)
    (eglot-ensure))
  :hook
  (kotlin-ts-mode . tirimia/kotlin-setup))

;; Org
(add-hook 'pdf-view-mode-hook 'auto-revert-mode)
(add-hook 'doc-view-mode-hook 'auto-revert-mode) ;; Keep pdf view updated
(setq org-latex-pdf-process '("%latex -interaction nonstopmode -output-directory %o %f" "%latex -interaction nonstopmode -output-directory %o %f" "%latex -interaction nonstopmode -output-directory %o %f"))
;; ("tectonic -Z shell-escape --outdir=%o %f")
(setq org-export-dispatch-use-expert-ui t) ;; Get menu in minibuffer, don't show entire thing
(setq-default org-directory "~/MEGA/Org"
              org-startup-folded t
              org-image-actual-width nil
              org-element-use-cache nil)
(use-package org-modern
  :config (global-org-modern-mode))
(defun tirimia/agenda ()
  "Show agenda."
  (interactive)
  (org-agenda nil "a"))
(setq org-agenda-custom-commands
      '(("a" "My Agenda"
         (
          (agenda "My Agenda" (
                               (org-agenda-search-view-max-outline-level 1)
                               (org-agenda-span 14)
                               (org-agenda-prefix-format " %i %?-2t %s")
                               (org-agenda-start-day "+0d")
                               (org-agenda-skip-scheduled-if-done t)
                               (org-agenda-skip-timestamp-if-done t)
                               (org-agenda-skip-deadline-if-done t)
                               (org-agenda-time)
                               (org-agenda-current-time-string "ᐊ┈┈┈┈┈┈┈ Now")
                               (org-agenda-sunrise-sunset)
                               (org-agenda-time-grid
                                (quote (
                                        (today require-timed remove-match)
                                        (1000 2000)
                                        "      "
                                        "┈┈┈┈┈┈┈┈┈┈┈┈┈")))))
          ;; Upcoming deadlines here
          (todo "" (
                    (org-deadline-warning-days 14)            ; 7 day advanced warning for deadlines
                    (org-agenda-overriding-header "Upcoming deadlines")
                    (org-agenda-skip-scheduled-if-done t)
                    (org-agenda-skip-timestamp-if-done t)
                    (org-agenda-skip-deadline-if-done t)
                    (org-agenda-skip-function '(org-agenda-skip-entry-if 'notdeadline))
                    (org-agenda-todo-keyword-format "")
                    (org-agenda-scheduled-leaders '("" ""))
                    (org-agenda-prefix-format "%t%s")))
          (todo "TODO" (
                        (org-agenda-overriding-header "Backlog")
                        (org-agenda-todo-keyword-format "")
                        (org-agenda-prefix-format "%c : %b %s")
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled)) ;; Only show TODOs without scheduled or deadline timestamps
                        )))))
      org-agenda-files '("~/MEGA/Org/Agenda.org")
      org-agenda-span 14
      org-agenda-start-with-log-mode t
      org-log-done 'time
      calendar-location-name "Dusseldorf, Germany"
      calendar-longitude 6.78
      calendar-latitude 51.2
      org-default-notes-file "~/MEGA/Org/Agenda.org"
      org-capture-templates '(("d" "Default" entry (file org-default-notes-file)   "* TODO %^{Name}\nDEADLINE: %^{Due: }t\n%?"))
      ;; TODO: replace full paths with (concat org-directory path)
      org-agenda-window-setup 'only-window
      org-agenda-restore-windows-after-quit t
      org-agenda-start-with-follow-mode t
      )
(advice-add 'org-agenda-quit :before 'org-save-all-org-buffers)
(setq org-todo-keywords '((sequence "TODO(t)"
                                    "IN PROGRESS(i)"
                                    "WAITING(w)"
                                    "|"
                                    "FINISHED(f)"
                                    "DELEGATED(d)"))
      org-adapt-indentation nil
      org-cycle-separator-lines 1
      org-hide-leading-stars t
      org-ellipsis " ▾"
      org-M-RET-may-split-line '((default . nil))
      org-hide-emphasis-markers t
      org-hide-macro-markers t
      )
(use-package org-roam
  :init (setq org-roam-v2-ack t)
  :config
  (setq org-roam-directory "~/MEGA/Org"
	org-roam-completion-everywhere t
	org-roam-capture-templates '(("d" "default" plain "%?" :if-new
				      (file+head "%<%Y%m%d>-${slug}.org" "#+TITLE: ${title}\n")
				      :unnarrowed t)
				     ("b" "book" plain "%?" :if-new
				      (file+head "Books/%<%Y%m%d>-${slug}.org" "#+AUTHOR: %^{Author: }\n#+TITLE: ${title}\n")
				      :unnarrowed t)
				     ("m" "media" plain "%?" :if-new
				      (file+head "Media/%<%Y%m%d>-${slug}.org" "#+TITLE: ${title}\n#+SOURCE: %^{Source: }\n")
				      :unnarrowed t)
                                     ("p" "person" plain "%?" :if-new
				      (file+head "People/%(org-id-uuid)-${slug}.org" "#+TITLE: ${title}\n\n* ${title}\n:PROPERTIES:\n:BIRTHDAY: %(org-read-date nil nil nil \"Birthday\")\n:END:\n")
				      :unnarrowed t)
				     ("r" "recipe" plain "%?" :if-new
				      (file+head "Recipes/%<%Y%m%d>-${slug}.org" "#+TITLE: ${title}\n")
				      :unnarrowed t)))
  (setq org-roam-node-display-template
	(concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
	(file-name-nondirectory
	 (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))
  (org-roam-setup))


;; Dailies
(setq org-roam-dailies-directory "~/MEGA/Org/Daily"
      org-roam-dailies-capture-templates
      '(("d" "default" plain
         "%?"
         :if-new (file+head "%<%Y-%m-%d>.org"
                            "#+TITLE: %<%Y-%m-%d>\n\n* Personal :personal:\n\n* Work :work:\n")
	 :unnarrowed t)))
(add-hook 'org-capture-mode-hook 'evil-insert-state)
(defun tirimia/agenda-capture ()
  "Start the default capture to the agenda."
  (interactive)
  (org-capture nil "d"))
(tirimia/leader-def
 "o" '(:ignore t :which-key "Org-Roam")

 "oa" '(tirimia/agenda :which-key "Agenda")

 "oc" '(:ignore t :which-key "Capture")
 "oca" '(tirimia/agenda-capture :which-key "Agenda")
 "occ" '(org-roam-capture :which-key "Capture")
 "ocd" '(org-roam-dailies-capture-date :which-key "Daily")

 "oi" '(org-roam-node-insert :which-key "Insert link to node")

 "oo" '(org-roam-node-find :which-key "Find node")
 "os" '(org-id-get-create :which-key "Set headline as node")

 "ot" '(:ignore t :which-key "Tags")
 "ott" '(org-roam-tag-add :which-key "Add tag")
 "otd" '(org-roam-tag-remove :which-key "Remove tag")

 "tw" '(org-roam-ui-mode :which-key "Roam in browser"))
(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t))
;; (tirimia/leader-def
;;  :keymaps 'org-mode-map
;;  :major-modes t
;;  "m" '(:ignore t :which-key "Org Mode")
;;  "mc" '(org-capture :which-key "Export")
;;  "mE" '(org-export-dispatch :which-key "Export")
;;  "md" '(org-deadline :which-key "Deadline")
;;  "me" '(org-edit-src-code :which-key "Edit code")
;;  "mi" '(org-insert-heading-respect-content :which-key "New heading")
;;  "mj" '(org-forward-heading-same-level :which-key "Next heading")
;;  "mk" '(org-backward-heading-same-level :which-key "Prev heading")
;;  "ml" '(:ignore t :which-key "Link")
;;  "mli" '(org-insert-link :which-key "Insert/edit")
;;  "mlo" '(org-open-at-point :which-key "Open")
;;  "mp" '(org-set-property :which-key "Propertize")
;;  "ms" '(org-schedule :which-key "Schedule")
;;  "mt" '(org-todo :which-key "Toggle TODO")
;;  "mT" '(org-set-tags-command :which-key "Tags")
;;  "mx" '(org-babel-execute-src-block :which-key "Run block"))

(general-define-key
 :keymaps '(org-agenda-mode-map)
 "RET" '(tirimia/org-agenda-switch-to-improved :which-key "Switch"))
(use-package org-contacts
  :config
  (defun org-contacts-files ()
    "Overwriting regular function so I can dynamically fetch contact files."
    (directory-files (concat org-directory "/People") t ".org")))
(setq org-edit-src-content-indentation 0
      org-src-tab-acts-natively t
      org-src-preserve-indentation t
      org-confirm-babel-evaluate nil
      org-src-window-setup 'plain)
(evil-define-key nil org-src-mode-map ;; Make vim wq and q work in org src
  [remap evil-write] #'org-edit-src-exit
  [remap evil-save-and-close] #'org-edit-src-exit
  [remap evil-quit] #'org-edit-src-abort)
(defun tirimia/org-agenda-switch-to-improved ()
  "Improve org-switch-to for roam-daily-users.
If cursor is on a date heading, the function originally throws an error.
With this added :around, it goes to capture the respective daily note"
  (interactive)
  (condition-case nil
      (org-agenda-switch-to)
    (error
     (let* ((curr-line (tirimia/current-line))
            (date (parse-time-string curr-line))
            (day (nth 3 date))
            (month (nth 4 date))
            (year (nth 5 date)))
       (org-roam-dailies--capture
        (encode-time (list 0 0 0 day month year)))))))
(add-hook 'org-mode-hook 'auto-fill-mode)

(provide 'init)

;;; init.el ends here
