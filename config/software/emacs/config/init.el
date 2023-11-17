;;; init.el --- Excellent-ish emacs config
;;; Commentary:
;; Emacs startup file

;; This is my config.

;;

;;; Code:

;; Base Emacs stuff
(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)

;;; Straight bootstrap
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package use-package
  :straight (:type built-in)
  :init (if init-file-debug
            (setq-default use-package-verbose t
                          use-package-expand-minimally nil
                          use-package-compute-statistics t
                          debug-on-error t)
          (setq-default use-package-verbose nil
                        use-package-expand-minimally t))
  :custom
  (straight-use-package-by-default t)
  (use-package-always-demand t "Needed so commands specified in commands actually load within the scope of the use-package sexp"))
;;; Native-comp-pgtk
(use-package comp
  :straight (:type built-in)
  :config
  (setq comp-deferred-compilation t
	comp-async-report-warnings-errors nil
	native-comp-speed 3
	native-comp-async-jobs-number 12
	byte-compile-warnings nil
        package-native-compile t))
(use-package use-package-ensure-system-package
  :config
  (add-to-list 'exec-path "/etc/profiles/per-user/tirimia/bin")
  (when (eq system-type 'darwin) (add-to-list 'exec-path "/opt/homebrew/bin")))

(use-package org)

;; User info
(setq
 user-full-name "Theodor-Alexandru Irimia"
 user-mail-address "theodor.irimia@gmail.com")

;; Generic configurations, maybe move into own blocks
(setq-default vc-follow-symlinks t
              coding-system-for-read 'utf-8
              coding-system-for-write 'utf-8
              sentence-end-double-space nil
              custom-file null-device	;; we don't set custom options beyond the current session
              byte-compile-debug nil	;; don't care right now
	      )
(setq-default compilation-ask-about-save nil
              compilation-always-kill t)

(setq-default indent-tabs-mode nil)
;; y or n instead of full words
(fset 'yes-or-no-p 'y-or-n-p)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)
;; Keep it clean
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; Weird features disabled
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
;;; Declutter base emacs
(setq-default visible-bell nil)
(setq ring-bell-function 'ignore
      initial-buffer-choice t
      initial-scratch-message nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(column-number-mode -1)
(line-number-mode -1)
(global-display-line-numbers-mode -1) ;; Line numbers on the side
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)
(setq-default fill-column 80)
(window-divider-mode -1) ;; Remove pesky line above echo area

;; Show where I am
(global-hl-line-mode) ;; TODO: configure color of this

;; Font setup
(use-package default-text-scale
  :commands (default-text-scale-mode)
  :config (default-text-scale-mode))
(add-to-list 'default-frame-alist '(font . "Iosevka Comfy Wide:pixelsize=22:weight=medium:slant=normal:width=normal:spacing=100:scalable=true"))
;;; Increase and decrease fonts like in normal editors
(global-set-key (kbd "<C-mouse-4>") 'text-scale-increase)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-decrease)

;; Addons
(use-package general
  :commands (general-def general-create-definer tirimia/key-definer)
  :defines (tirimia/key-definer tirimia/leader-key tirimia/alt-leader-key)
  :config
  (setq-default
   tirimia/leader-key "SPC"
   tirimia/alt-leader-key "C-,")
  ;; Without this statement, the motion state SPC being bound completely messes up the other bindings.
  (general-def :states '(motion) "SPC" nil)
  (general-create-definer tirimia/key-definer
    :states '(normal visual insert motion emacs)
    :prefix tirimia/leader-key
    :non-normal-prefix tirimia/alt-leader-key))
(use-package which-key
  :commands (which-key-mode which-key-enable-god-mode-support)
  :init
  (setq-default which-key-idle-delay 1
	        which-key-idle-secondary-delay 0.1
	        which-key-popup-type 'minibuffer)
  :config
  (which-key-mode)
  (which-key-enable-god-mode-support))

;;; Evil
;;TODO: do all evil bindings in one place, with evalafterload
(use-package evil
  :defines (
            evil-insert-state-modes
            evil-emacs-state-modes
            evil-motion-state-modes
            evil-insert-state-map
            )
  :commands (evil-mode
             evil-set-undo-system
             evil-define-key)
  :init (setq-default evil-want-keybinding nil)
  :custom
  (evil-ex-substitute-global t)
  (evil-default-state 'normal)
  (evil-want-minibuffer nil)
  (evil-vsplit-window-right t)
  (evil-split-window-below t)
  ;; TODO: move these to their respective modes
  :config
  (evil-mode 1)
  (add-to-list 'evil-insert-state-modes 'vterm-mode)
  (add-to-list 'evil-motion-state-modes 'imenu-list-major-mode)
  (add-to-list 'evil-motion-state-modes 'doc-view-mode)
  (add-to-list 'evil-motion-state-modes 'helpful-mode)
  (add-to-list 'evil-motion-state-modes 'messages-buffer-mode)
  (add-to-list 'evil-motion-state-modes 'special-mode)
  (add-to-list 'evil-motion-state-modes 'magit-blame-mode)
  (add-to-list 'evil-emacs-state-modes 'dired-mode)
  (add-to-list 'evil-emacs-state-modes 'flycheck-error-list-mode)
  (add-to-list 'evil-emacs-state-modes 'justl-mode)
  (evil-set-undo-system 'undo-redo)
  (defun new-line-dwim ()
    "Inserts newline and does the fun double enter back and tab if in a brace"
    (interactive)
    (let ((break-open-pair (or (and (eq (char-before) ?{) (looking-at "}"))
                               (and (eq (char-before) ?>) (looking-at "<"))
                               (and (eq (char-before) ?\() (looking-at ")"))
                               (looking-at ")$")
                               (and (eq (char-before) ?\[) (looking-at "\\]")))))
      (newline)
      (when break-open-pair
        (save-excursion
          (newline)
          (indent-for-tab-command)))
      (indent-for-tab-command)))
  (evil-define-key 'insert prog-mode-map (kbd "RET") 'new-line-dwim))

(use-package evil-goggles
  ;; Visual hints to changes
  :commands (evil-goggles-use-diff-refine-faces evil-goggles-mode)
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-refine-faces))
(use-package evil-mc
  :after (general evil)
  :commands (global-evil-mc-mode)
  :general (:states '(normal)
                    "gb" 'evil-mc-undo-last-added-cursor
                    "gn" 'evil-mc-make-and-goto-next-match
                    "gs" 'evil-mc-skip-and-goto-next-match
                    "gq" 'evil-mc-undo-all-cursors)
  ;; Disable cursors map for binding to be used elsewhere
  (:states '(normal visual) :keymaps 'evil-mc-key-map
           "gr" '(lsp-ui-peek-find-references :which-key "References"))

  :config
  (global-evil-mc-mode)
  (global-unset-key (kbd "M-<down-mouse-1>"))
  (global-set-key (kbd "M-<mouse-1>") 'evil-mc-toggle-cursor-on-click))
(use-package evil-escape
  :commands (evil-escape-mode)
  :custom
  (evil-escape-key-sequence "jk")
  (evil-escape-unordered-key-sequence t)
  (evil-escape-delay 0.15)
  :config
  (evil-escape-mode))
(use-package evil-snipe
  :after evil
  :commands (evil-snipe-mode evil-snipe-override-mode)
  :config
  (evil-snipe-mode 1)
  (evil-snipe-override-mode 1)
  :custom
  (evil-snipe-spillover-scope 'whole-visible))
(use-package evil-surround ;; ysiw[ to add square braces around word selection
  :after evil
  :commands (global-evil-surround-mode)
  :custom (evil-surround-pairs-alist '((?\( "(" . ")")
                                       (?\[ "[" . "]")
                                       (?\{ "{" . "}")
                                       (?\< "<" . ">")
                                       (?\% "%" . "%")
                                       (?t . evil-surround-read-tag)
                                       (?f . evil-surround-function)))
  :config
  (global-evil-surround-mode 1))
(use-package evil-exchange
  :after evil
  :commands (evil-exchange-install)
  :custom (evil-exchange-key "ge")
  :config
  (evil-exchange-install))
(use-package evil-collection
  :commands (evil-collection-init)
  :config (evil-collection-init '(calc org)))

;; TODO: consider using the default mode line but modded
(use-package mood-line
  :commands (mood-line-mode)
  :config (mood-line-mode))

;;; Code Completion
;; TODO: benchmark completion with 20i- AKA stop completing when evil is just repeating
(use-package corfu
  :commands (global-corfu-mode)
  :straight (:host github :repo "minad/corfu" :files ("*.el" "extensions/*.el"))
  :general
  (corfu-map "TAB" 'corfu-complete)
  (corfu-map "RET" nil)
  :bind ("M-/" . completion-at-point)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-quit-no-match 'separator)
  (corfu-on-exact-match nil "Sometimes gets in the way something fierce, needs to be disabled")
  (corfu-cycle t)
  (corfu-preselect 'first)
  ;; TODO: get the @ prefix working for zig
  :config
  (corfu-popupinfo-mode 1)
  (defun corfu-enable-in-minibuffer ()
    "Enable Corfu in the minibuffer if `completion-at-point' is bound."
    (when (where-is-internal #'completion-at-point (list (current-local-map)))
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-in-minibuffer))
(when (fboundp 'global-corfu-mode) (global-corfu-mode)) ;; need to run it outside the use-package because otherwise it won't load, wrapped to stop warning
;; if inside the block it needs a restart
(use-package yasnippet
  :after (evil)
  :init (defun tirimia/yasnippet-get-group-sexp ()
          "Fetch first defined group backwards."
          (save-match-data
            (search-backward "(defgroup ")
            (sexp-at-point)))
  :commands yas-global-mode
  :defines (yas-keymap)
  :config (yas-global-mode)
  :general
  (:states 'insert
           "C-p" 'yas-insert-snippet)
  (:keymaps 'yas-keymap
            "RET" 'yas-next-field
            "TAB" nil
            "<tab>" nil
                                        ; "C-g" 'corfu-quit
            )) ;; TODO: investigate if this is the one messing with my cg
(use-package yasnippet-snippets
  :after yasnippet)
;; TODO: list of snippets to create for each mode
(use-package yasnippet-capf
  :commands (yasnippet-capf)
  :after yasnippet)
(use-package dabbrev
  :straight (:type built-in)
  :config
  (defun tirimia/dabbrev-buffer-source-picker (buffer)
    "Determines if BUFFER should be used as a dabbrev source.
We only want buffers in the same major mode and visible buffers to be used."
    (or (dabbrev--same-major-mode-p buffer) (get-buffer-window buffer)))
  :custom
  (dabbrev-friend-buffer-function #'tirimia/dabbrev-buffer-source-picker)
  (dabbrev-check-all-buffers nil))
(use-package cape
  :commands (cape-dabbrev cape-keyword cape-file cape-capf-super cape-wrap-silent cape-wrap-noninterruptible)
  :config
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (defun setup-lsp-completion ()
    (setq-local completion-at-point-functions (list (cape-capf-super
                                                     #'lsp-completion-at-point
                                                     #'yasnippet-capf)
                                                    #'cape-file
                                                    #'cape-dabbrev)))
  (defun setup-elisp-completion ()
    (setq-local completion-at-point-functions (list (cape-capf-super #'elisp-completion-at-point
                                                                     #'yasnippet-capf)
                                                    #'cape-file
                                                    #'cape-dabbrev)))
  (defun setup-web-completion ()
    (setq-local completion-at-point-functions (list  #'yasnippet-capf
                                                     #'cape-file
                                                     #'cape-dabbrev)))
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)
  ;; Lsp is not playing nicely with corfu and leads to it hanging, this fixes it https://github.com/minad/corfu/issues/188#issuecomment-1148658471
  (advice-add #'lsp-completion-at-point :around #'cape-wrap-noninterruptible)
  :hook
  (emacs-lisp-mode     . setup-elisp-completion)
  (lsp-completion-mode . setup-lsp-completion)
  (web-mode . setup-web-completion))


;;; Linting
(use-package flycheck
  :after general
  :commands (global-flycheck-mode)
  :custom
  (flycheck-display-erors-delay 0.15)
  (flycheck-emacs-lisp-load-path 'inherit)
  :general
  (:states '(normal visual)
           "g[" 'flycheck-next-error
           "g]" 'flycheck-previous-error)
  ("M-g n" '(flycheck-next-error :which-key "Next error")
   "M-g p" '(flycheck-previous-error :which-key "Previous error"))
  ;; TODO: figure out why flycheck is not overriding next and previous error like it says it does - only shows up in non elisp
  ;; TODO: make flycheck rotate through top of file
  :config
  (global-flycheck-mode 1))
(use-package consult-flycheck)
(use-package flycheck-inline
  :hook (flycheck-mode . flycheck-inline-mode))
(use-package flycheck-actionlint
  :after flycheck
  :straight (:local-repo "~/MEGA/Projects/Emacs/flycheck-actionlint")
  :config (flycheck-actionlint-setup))
(use-package flycheck-relint
  :after flycheck
  :commands (flycheck-relint-setup)
  :config (flycheck-relint-setup))
(use-package flycheck-package
  :after (flycheck elisp-mode)
  :commands (flycheck-package-setup)
  :config (flycheck-package-setup))
(use-package flycheck-golangci-lint
  :after (flycheck go-ts-mode)
  :ensure-system-package (golangci-lint . "go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest")
  :straight (:host github :repo "forgoty/flycheck-golangci-lint")
  :commands (flycheck-golangci-lint-setup)
  :config
  (flycheck-golangci-lint-setup))
;; TODO: add hl-todo flycheck https://github.com/melpa/melpa/pull/8670
;; Theming
(add-hook 'emacs-startup-hook (lambda () (message ""))) ;; Shut up when starting up
(use-package ace-window
  :config (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :general
  (:states '(motion normal) "C-w" '(ace-window :which-key "Windows"))
  ("M-o" '(ace-window :which-key "Switch window")))

;;; Theme
(setq modus-themes-hl-line (quote (underline)))
(load-theme 'modus-vivendi t)
;;; Random icons
(use-package all-the-icons)
;;; Highlighting
(use-package hl-todo
  :commands (global-hl-todo-mode)
  :custom
  (hl-todo-keyword-faces
   '(("TODO"   . "#66FF33")
     ("MAYBE"  . "#FFFF00")
     ("FIXME"  . "#FF0000")
     ("DEBUG"  . "#A020F0")
     ("GOTCHA" . "#FF4500")
     ("STUB"   . "#1E90FF")))
  :config
  (global-hl-todo-mode 1))
;;; Make focused buffer easier to spot
;; TODO: make it not dim if you're in minibuffer
(use-package auto-dim-other-buffers
  :commands (auto-dim-other-buffers-mode)
  :config (auto-dim-other-buffers-mode)
  (set-face-attribute 'auto-dim-other-buffers-face nil :background "#222222"))
;;; Window organization
(setq display-buffer-alist
      `(("^*[Hh]elp.*$" (display-buffer-in-side-window) (window-height . 0.35) (side . bottom) (slot . -1))
	("^*.*[Cc]ompilation.*" (display-buffer-in-side-window) (window-height . 0.35) (side . bottom) (slot . 0))
	("^*Flycheck.*$" (display-buffer-in-side-window) (window-height . 0.35) (side . bottom) (slot . 1))))
(setq help-window-select t) ;; Focus help window once opened

;;; Terminal
(use-package vterm
  :init (setq-default vterm-always-compile-module t)
  :commands (vterm vterm-send vterm-send-string vterm-send-return)
  :general (:keymaps 'vterm-mode-map
                     "C-c C-d" `((lambda () (interactive) (vterm-send "C-d")) :which-key "C-d"))
  :hook (vterm-mode . tirimia/vterm-startup)
  :config (defun tirimia/vterm-startup () (hl-line-mode -1) (display-line-numbers-mode -1))
  (defun tirimia/term-with-command (command name)
    "Spawns a vterm NAME and runs COMMAND"
    (tirimia/binary-window-split)
    (vterm name)
    (vterm-send-string command)
    (vterm-send-return))
  (defun tirimia/fresh-vterm ()
    "Always spawns a new terminal"
    (interactive)
    (vterm t)))

;;; Magit
(use-package magit
  :ensure-system-package git
  :commands (magit-get-current-branch magit-refresh-buffer)
  :config
  (defun tirimia/smart-magit-refresh ()
    "Refresh magit only if the buffer is visible."
    (interactive)
    (let* ((project-name (projectile-project-name))
           (buffer-name (format "magit: %s" project-name)))
      (when (get-buffer-window buffer-name t) (magit-refresh-buffer)))) ;; TODO: figure out why this is not running
  (defun tirimia/set-commit-task-id ()
    "Sets up the task ID in a commit message if the branch is appropriate."
    (when-let* ((branch (magit-get-current-branch)) ;; TODO: more refined, maybe implement common commits
                (task-id
                 (save-match-data
                   (and (string-match "^\\([[:upper:]]+-[[:digit:]]+\\)*" branch)
                        (match-string 0 branch)))))
      (unless (string-empty-p task-id) (insert (format "%s: " task-id)))))
  :hook
  (git-commit-setup . tirimia/set-commit-task-id)
  (after-save . tirimia/smart-magit-refresh))

;;;; Whodunnit
(use-package blamer
  :after magit
  :custom
  (blamer-max-commit-message-length 80)
  (blamer-show-avatar-p nil)
  :config (tirimia/key-definer
            "b" '(:ignore t :which-key "Blame")
            "bb" '(magit-blame-addition :which-key "Buffer")
            "bp" '(blamer-show-commit-info :which-key "Point")))

;;; Scratch respawner
(use-package immortal-scratch ;; TODO: figure out why it keeps throwing an error
  :commands (immortal-scratch-mode)
  :config (immortal-scratch-mode))

;;; Minibuffer Completion
(use-package savehist
  :config
  (savehist-mode))

(use-package vertico
  :straight (:host github :repo "minad/vertico" :files ("*.el" "extensions/*.el"))
  :after (savehist)
  :custom
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)
  (completion-styles '(flex))
  :config (vertico-mode))

;; TODO: NEWMACS add fussy if necessary

;;; Project Management
(use-package projectile
  :commands (projectile-mode
             projectile-project-files
             projectile-project-root
             projectile-project-name
             projectile-acquire-root
             projectile-switch-project-by-name
             projectile-relevant-known-projects)
  :custom
  (projectile-completion-system 'auto)
  (projectile-indexing-method 'alien)
  (projectile-enable-caching nil)
  :config
  (defun tirimia/compile-in-project-root ()
    "Run compile in project root for special use-cases."
    (interactive)
    (let ((default-directory (projectile-project-root))) (compile (compilation-read-command compile-command))))
  ;; TODO: learn about current-prefix-arg
  (projectile-mode))
(use-package consult
  :commands (consult--file-action)
  :after (projectile)
  :ensure-system-package (rg . ripgrep)
  :general ("M-g M-g" 'consult-goto-line)
  :custom
  (consult-ripgrep-args "rg --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --with-filename --line-number --search-zip --hidden --glob=!.git/")
  (consult-project-function #'projectile-project-root)
  (consult-buffer-sources '(consult--source-buffer consult--source-projectile-projects consult--source-projectile-file))
  :config
  ;; For some reason these cannot be easily put in custom
  (setq-default consult--source-projectile-file (list
                                                 :name     "Project Files"
                                                 :narrow   '(?p . "Project files")
                                                 :category 'file
                                                 :face     'consult-file
                                                 :preview-key 'any
                                                 :history  'file-name-history
                                                 :enabled  #'projectile-project-root
                                                 :action   (lambda (f) (consult--file-action (concat (projectile-acquire-root) f)))
                                                 :items    (lambda () (projectile-project-files (projectile-acquire-root))))
                consult--source-projectile-projects (list
                                                     :name     "Projects"
                                                     :narrow   '(?P . "Project")
                                                     :category 'file
                                                     :face     'consult-key
                                                     :action   #'projectile-switch-project-by-name
                                                     :items    #'projectile-relevant-known-projects)))
(use-package marginalia
  :commands marginalia-mode
  :config (marginalia-mode))
;; TODO: dap mode and dap-mode-typescript etc.
(use-package lsp-mode
  :commands (lsp lsp-deferred lsp-format-buffer lsp-organize-imports lsp-completion-at-point)
  :custom
  (lsp-completion-provider :none)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-eldoc-render-all t)
  (lsp-diagnostic-clean-after-change t)
  (lsp-modeline-diagnostics-enable nil)
  (lsp-diagnostics-provider :flycheck)
  (lsp-disabled-clients '())
  (lsp-semgrep-languages '() "Disable this stupid lsp"))

(use-package lsp-ui
  :general
  (:states 'normal :keymaps 'lsp-mode-map
           "gd" '(lsp-ui-peek-find-definitions :which-key "Definitions")
           "K" '(lsp-describe-thing-at-point :which-key "Describe"))
  :config
  (setq-default lsp-ui-sideline-enable nil)
  (setq-default lsp-ui-sideline-show-diagnostics nil)
  (setq-default lsp-ui-sideline-diagnostic-max-line-length 50)
  (setq-default lsp-ui-sideline-diagnostic-max-lines 2)
  (setq-default lsp-ui-doc-show-with-cursor nil)
  (setq-default lsp-ui-doc-show-with-mouse t)
  (setq-default lsp-ui-doc-delay 1)
  (setq-default lsp-ui-doc-use-webkit t))

;; Automatically delete properly
(use-package smart-delete
  :hook prog-mode)

;; Automatically add and remove pairs of braces
(use-package smartparens
  :commands (smartparens-global-mode sp-local-pair)
  :config
  (smartparens-global-mode)
  ;; Single quotes are necessary for quoting in emacs and lifetimes in rust
  (sp-local-pair '(emacs-lisp-mode rust-mode) "'" nil :actions nil)
  (sp-local-pair '(emacs-lisp-mode) "`" nil :actions nil)
  ;; Web automatically adds them
  (sp-local-pair '(web-mode) "{" nil :actions nil))

;; TODO: get this sorted
(use-package web-mode
  :mode "\\.gohtml\\'"
  :custom
  (web-mode-enable-current-column-highlight t)
  (web-mode-enable-current-element-highlight t))

;; Compilation mode
(use-package ansi-color
  :straight (:type built-in)
  :commands (ansi-color-apply-on-region)
  :custom (compilation-scroll-output t)
  :general
  (:states '(motion) :keymaps 'compilation-mode-map
           "r" '(recompile :which-key "Recompile"))
  :config
  (defun my-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer))
;; Languages
;;; Common
(defun tirimia/prog-with-lsp (docs)
  "Base configuration for programming LSP enabled languages.
DOCS will be provided via devdocs if installed."
  (interactive)
  (setq-local devdocs-current-docs docs)
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t)
  (lsp-deferred))
;;; Elisp
(use-package aggressive-indent
  :ghook 'emacs-lisp-mode-hook)
(use-package elisp-autofmt
  :commands (elisp-autofmt-mode elisp-autofmt-buffer)
  :hook (emacs-lisp-mode . elisp-autofmt-mode))
(defun tirimia/elisp-setup ()
  "Function to set all the goodies up for Emacs Lisp."
  (interactive)
  (setq-local comment-start ";; ")
  (with-eval-after-load 'outline (outline-minor-mode))
  (with-eval-after-load 'devdocs (setq-local devdocs-current-docs '("elisp")))
  (prettify-symbols-mode))
(tirimia/key-definer
  :keymaps '(emacs-lisp-mode-map lisp-interaction-mode-map)
  :major-modes t
  "m" '(:ignore t :which-key "Elisp Mode")
  "mx" '(eval-defun :which-key "Eval top")
  "me" '(eval-last-sexp :which-key "Eval-last"))
(add-hook 'emacs-lisp-mode-hook #'tirimia/elisp-setup)
(add-hook 'lisp-interaction-mode-hook #'tirimia/elisp-setup)

;;; Yaml
(use-package yaml-mode
  :ensure-system-package yamllint
  :init
  (defun tirimia/yaml-setup ()
    "Function to set up YAML editing."
    (interactive)
    (when (eq 0 (buffer-size)) (insert "---\n"))
    (lsp-deferred))
  ;; TODO: fix indent bullshit
  :hook (yaml-mode . tirimia/yaml-setup))


;;; Golang
(use-package go-ts-mode
  :preface (add-to-list 'exec-path "/Users/tirimia/go/bin")
  :straight (:type built-in)
  :mode "\\.go\\'"
  :ensure-system-package (go
                          (gofumpt . "go install mvdan.cc/gofumpt@latest")
                          (goimports . "go install golang.org/x/tools/cmd/goimports@latest")
                          (gopls . "go install golang.org/x/tools/gopls@latest"))
  :config
  (defun tirimia/go-setup ()
    "Setup for writing the coolest yet most annoying language"
    (interactive)
    (setq-local compile-command "go run main.go")
    (tirimia/prog-with-lsp '("go")))
  (lsp-register-custom-settings
   '(("gopls.completeUnimported" t t) ("gopls.staticcheck" t t)))
  :custom
  (lsp-go-use-gofumpt t)
  (lsp-go-analyses '((nilness . t)
                     (shadow . t)
                     (unusedwrite . t) (unusedparams . t) (unusedvariable . t) (useany . t) (fieldalignment . t)))
  :hook ((go-mode go-ts-mode) . tirimia/go-setup))
(tirimia/key-definer
  :keymaps '(go-ts-mode-map go-mode-map)
  :major-modes t
  "m" '(:ignore t :which-key "Golang")
  "mc" '(compile :which-key "Go Compile")
  "mr" '(tirimia/compile-in-project-root :which-key "Go Compile in root")
  "mm" '(recompile :which-key "Go Recompile")
  "mh" '(lsp-describe-thing-at-point :which-key "Help"))
(use-package rustic
  :init (setq-default rustic-treesitter-derive t)
  :straight (:host github :repo "brotzeit/rustic" :branch "rustic-ts-mode")
  :config
  (add-to-list 'exec-path "~/.cargo/bin")
  (defun tirimia/rust-setup ()
    "Setup for writing Rust/Crablang"
    (interactive)
    (tirimia/prog-with-lsp '("rust")))
  (setq-default
   lsp-rust-analyzer-proc-macro-enable t
   lsp-rust-analyzer-diagnostics-disabled (vector "unresolved-macro-call" "unresolved-proc-macro")
   lsp-rust-analyzer-inlay-hints-mode t
   lsp-rust-analyzer-server-display-inlay-hints t
   lsp-rust-analyzer-cargo-watch-command "clippy"
   lsp-rust-analyzer-import-granularity "crate"
   lsp-rust-analyzer-display-parameter-hints t)
  :hook (rustic-mode . tirimia/rust-setup))
(tirimia/key-definer
  :keymaps '(rustic-mode-map)
  :major-modes t
  "m" '(:ignore t :which-key "Rust")
  "mc" '(rustic-compile :which-key "Rustic Compile")
  "mf" '(rustic-cargo-clippy-fix :which-key "Rustic Fix") ;; TODO: this won't work with uncommitted changes
  "mh" '(lsp-describe-thing-at-point :which-key "Help") ;; TODO: for some reason this doesn`t work
  "mm" '(rustic-recompile :which-key "Rustic Recompile"))
;; TODO: configure installing necessary tools and pacakge
(use-package reformatter
  :config
  (reformatter-define prettier-format
    :program "npx"
    :args (list "prettier" "--stdin-filepath" (buffer-file-name))))
;; TODO: in projects that contain prettierrc, turn on autosave and autorevert in each file
(use-package typescript-ts-mode
  :straight (:type built-in)
  :custom
  (lsp-javascript-display-enum-member-value-hints t)
  (lsp-javascript-display-parameter-name-hints 'all)
  (lsp-javascript-display-parameter-type-hints t)
  (lsp-javascript-display-property-declaration-type-hints t)
  (lsp-javascript-display-return-type-hints t)
  (lsp-javascript-display-variable-type-hints t)
  (lsp-typescript-surveys-enabled nil)
  :config
  (defun tirimia/typescript-setup ()
    "Setup for writing TS"
    (interactive)
    (setq-local devdocs-current-docs '("typescript" "node~18_lts"))
    (add-hook 'before-save-hook #'lsp-organize-imports t t)
    (prettier-format-on-save-mode)
    (lsp-deferred))
  :mode (("\\.ts\\'" . typescript-ts-mode) ("\\.tsx\\'" . tsx-ts-mode))
  :hook ((tsx-ts-mode typescript-ts-mode) . tirimia/typescript-setup))
(tirimia/key-definer
  :keymaps '(tsx-ts-mode-map typescript-ts-mode-map)
  :major-modes t
  "m" '(:ignore t :which-key "TypeScript")
  "mc" '(compile :which-key "TS Compile")
  "mr" '(tirimia/compile-in-project-root :which-key "Compile in root")
  "mm" '(recompile :which-key "TS Recompile")
  "mh" '(lsp-describe-thing-at-point :which-key "Help"))
(use-package prisma-mode
  :straight (emacs-prisma-mode :host github :repo "pimeys/emacs-prisma-mode" :branch "main")
  :config (add-hook 'prisma-mode-hook #'lsp))
(use-package json-ts-mode
  :straight (:type built-in)
  :config
  (defun tirimia/package-json-setup ()
    "Make sure package.json is refreshed and pretty"
    (interactive)
    (when (string= (buffer-name) "package.json")
      (auto-revert-mode 1)))
  :hook (json-ts-mode . tirimia/package-json-setup))
(use-package js2-mode
  :ensure nil
  :mode ("\\.cjs\\'" "\\.mjs\\'" "\\.js\\'" )
  :hook (js-ts-mode . lsp-deferred))

(use-package php-mode) ;; Because one must

(use-package devdocs
  :config
  (tirimia/key-definer
    :keymaps '(prog-mode-map)
    :major-modes t
    "md" '(devdocs-lookup :which-key "Docs")))

(use-package helpful
  :general
  ("C-h f" 'helpful-callable)
  ("C-h v" 'helpful-variable)
  ("C-h k" 'helpful-key))
;; TODO: bind spc tr to recompile on save, own function that autopicks the buffer if there is only one, potentially bind it to all major mode buffers in project
(use-package recompile-on-save)

;; Docker
(use-package docker) ;; TODO: bind and use
(use-package dockerfile-mode
  :mode "Dockerfile\\'")

;; Markdown
(use-package markdown-mode
  :mode
  ("INSTALL\\'"
   "CONTRIBUTORS\\'"
   "LICENSE\\'"
   "README\\'"
   "\\.markdown\\'"
   "\\.md\\'")
  :custom
  (markdown-asymmetric-header t)
  (markdown-split-window-direction 'right)
  :config
  (unbind-key "M-<down>" markdown-mode-map)
  (unbind-key "M-<up>" markdown-mode-map)
  )

;; HCL
(use-package hcl-mode
  :mode ("\\.job\\'" "nomad.job"))
;; TF
(use-package terraform-mode
  :hook (terraform-mode . lsp-deferred)
  :config (setq-default
           lsp-terraform-ls-prefill-required-fields t
           lsp-terraform-ls-validate-on-save t)
  ) ;; TODO: configure hook for this mode and more refined configuration
(use-package terraform-doc)

;; HTTP
(use-package restclient
  :mode ("\\.restclient\\'" . restclient-mode))
(use-package request)
(use-package know-your-http-well)
;; Nix
(use-package nix-mode
  :mode "\\.nix\\'"
  :hook (nix-mode . lsp-deferred))
(add-to-list 'exec-path "/Users/tirimia/.nix-profile/bin")
(add-to-list 'exec-path "/nix/var/nix/profiles/default/bin")
;; TODO: nix devdocs
;; TODO: format on save
(defvar lsp-nix-nixd-server-path "nixd" "temp var for nixd.")
(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection (lambda () lsp-nix-nixd-server-path))
                  :major-modes '(nix-mode)
                  :initialized-fn (lambda (workspace)
                                    (with-lsp-workspace workspace
                                      (lsp--set-configuration
                                       (lsp-configuration-section "nixd"))))
                  :synchronize-sections '("nixd")
                  :server-id 'nix-nixd))

(use-package treesit
  :straight (:type built-in)
  :custom
  (treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (gomod "https://github.com/camdencheek/tree-sitter-go-mod")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (php "https://github.com/tree-sitter/tree-sitter-php")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (rust "https://github.com/tree-sitter/tree-sitter-rust")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")
     (zig "https://github.com/maxxnino/tree-sitter-zig")))
  (major-mode-remap-alist
   '((yaml-mode . yaml-ts-mode)
     (bash-mode . bash-ts-mode)
     (js2-mode . js-ts-mode)
     (typescript-mode . typescript-ts-mode)
     (json-mode . json-ts-mode)
     (css-mode . css-ts-mode)
     (rust-mode . rust-ts-mode)
     (python-mode . python-ts-mode))))

;; System clipboard
(use-package xclip
  :commands (xclip-mode)
  :config (xclip-mode 1))

;; Encrypted files support
(epa-file-enable)
(add-to-list 'auto-mode-alist '("\\.gpg\\'" nil epa-file))

;; Missing directory files
(defun er-auto-create-missing-dirs ()
  "Create missing directories if we `find-file' into them."
  (let ((target-dir (file-name-directory buffer-file-name)))
    (unless (file-exists-p target-dir)
      (make-directory target-dir t))))

(add-to-list 'find-file-not-found-functions #'er-auto-create-missing-dirs)
;; Toggles and prettifiers
(use-package darkroom)
(use-package rainbow-mode)
(use-package rainbow-delimiters
  :hook prog-mode)
;; TODO: virtualenv for python
(use-package python
  :ensure-system-package ruff
  :config (defun tirimia/python-setup ()
            "Setup for writing Python."
            (interactive)
            (tirimia/prog-with-lsp '("python"))
            (prettify-symbols-mode))
  (tirimia/key-definer
    :keymap 'python-ts-mode-map
    :major-modes t
    "m" '(:ignore t :which-key "Python Mode")
    "mc" '(compile :which-key "Python Compile")
    "mm" '(recompile :which-key "Python Recompile"))
  :hook (python-ts-mode . tirimia/python-setup))
(use-package lua-mode)
(use-package kotlin-mode)
(use-package toml-mode)
(use-package just-mode)
(use-package justl) ;; TODO: conditionally bind it if project contains -- major mode map

;; TODO: move stuff to own directories and libraries to make the config more modular
(use-package zig-mode
  :ensure-system-package (zig zls)
  :custom (zig-format-on-save nil)
  :config
  (defun tirimia/zig-setup ()
    "Hook for Ziggy goodness"
    (interactive)
    (tirimia/prog-with-lsp '("zig"))
    (treesit-parser-create "zig"))
  (flycheck-define-checker zig
    "A zig syntax checker using zig's `ast-check` command."
    :command ("zig" "ast-check" (eval (buffer-file-name)))
    :error-patterns
    ((error line-start (file-name) ":" line ":" column ": error: " (message) line-end))
    :modes zig-mode)
  (add-to-list 'flycheck-checkers 'zig)
  :hook (zig-mode . tirimia/zig-setup))

(use-package define-word)

;; Helper functions
(defun tirimia/current-line ()
  "Get string that represents the current line"
  (buffer-substring-no-properties
   (line-beginning-position)
   (line-end-position)))
(defun tirimia/lines (input)
  "Return non-empty lines of INPUT."
  (cl-remove-if #'string-empty-p (split-string input "\n")))
(defun tirimia/side-window-p (window)
  "Returns whether WINDOW is a side-window"
  (cdr (--first (eq (car (when (listp it) it)) 'dedicated)
		(--first (eq (car it) 'buffer)
			 (nthcdr 2 (window-state-get window))))))
(defun tirimia/simple-annotation-function (string-pair)
  "Given a STRING-PAIR, keep the first as the choice and add the second as the annotation."
  (let ((item (assoc string-pair minibuffer-completion-table)))
    (when item (concat " " (second item)))))

(defun tirimia/first-word-and-rest (str)
  "Given STR, return a pair the first word, the rest of the string."
  (save-match-data
    (when (string-match "\\(^[[:graph:]]*\\) \\(.*\\)" str)
      (list (match-string 1 str) (match-string 2 str)))))

;; (let (completion-extra-properties '(:annotation-function tirimia/simple-annotation-function))
;; (alloc-id (completing-read "Backend alloc: " (mapcar #'tirimia/first-word-and-rest jobs))))

(defun tirimia/ssh-block-to-oneline ()
  "With a block format public key in the kill ring, insert the oneline version"
  (interactive
   (let* ((lines (tirimia/lines (current-kill 0 t)))
	  (comment-line (nth 1 lines))
	  (comment (nth 1 (split-string comment-line "\"")))
	  (key-lines (cdr (cdr (butlast lines 1)))))
     (insert (format "ssh-rsa %s %s" (string-join key-lines "") comment)))))

(defun tirimia/binary-window-split ()
  "Split window in halves."
  (interactive)
  (unless (tirimia/side-window-p (get-buffer-window (current-buffer)))
    (progn
      (if (> (window-pixel-width) (window-pixel-height))
	  (evil-window-vsplit)
	(evil-window-split))
      (when current-prefix-arg (balance-windows)))))

(defun tirimia/insert-uuid ()
  "Insert UUID at point. With prefix, uppercase it."
  (interactive)
  (let* ((uuid (string-trim-right (shell-command-to-string "uuidgen"))))
    (insert (if current-prefix-arg (upcase uuid) (downcase uuid)))))

(defun tirimia/github-url ()
  "Populates the clipboard with the github URL to the current line.
If multiple lines are selected, link to those.
With `current-prefix-arg', just link the file."
  (declare (interactive-only t))
  (interactive)
  (let* ((remote (magit-name-branch)))
    remote))

(defun sflx/select-account ()
  "Select from the SFLX AWS accounts"
  (completing-read "Account/ENV: " (nthcdr 2 (directory-files "~/Work/infrastructure/accounts/"))))
(defun sflx/nomad-backend-shell ()
  "Start a shell in a production backend task"
  (interactive
   (let* ((sflx-acc (sflx/select-account))
	  (default-directory (format "~/Work/infrastructure/accounts/%s/" sflx-acc))
	  (exec-dir default-directory)
	  (raw-output (shell-command-to-string
		       (format "direnv exec . nomad status --namespace=%s backend | grep running" sflx-acc)))
	  (jobs (nthcdr 2 (tirimia/lines raw-output)))
          (completion-extra-properties '(:annotation-function tirimia/simple-annotation-function))
          (alloc-id (completing-read "Backend alloc: " (mapcar #'tirimia/first-word-and-rest jobs))))
     (tirimia/term-with-command
      (format "cd %s && nomad alloc exec --namespace=%s -task php-fpm -i %s /bin/bash" exec-dir sflx-acc alloc-id)
      (format "%s: nomad backend %s" sflx-acc alloc-id)))))
(defun sflx/mysql-shell ()
  "Open a mysql shell to a sflx database."
  ;; TODO: do vault login in case it's not done
  ;; TODO: use database credentials path
  ;; vault read database/creds/developer
  (interactive)
  (let* ((environments '("training" "stage" "prod"))
         (env (completing-read "Env: " environments))
         (vault-env "VAULT_ADDR=https://vault.infra.schuett.tech")
         (vault-path (format "services/monolith/%s/database" env))
         (cmd (format "%s vault kv get -field=DATABASE_READER_URL %s" vault-env vault-path))
         (db_url (shell-command-to-string cmd))
         (sql-mysql-login-params (list "" "" "" (print db_url))))
    (sql-mysql)))
;; (let ((sql-mysql-login-params (list "" "" "" "databse_url")))
;;   (sql-mysql)
;;   )
(defun tirimia/call-cmd (command &optional env args)
  (let ((process-environment (cons env process-environment)))
    (apply #'call-process (append
                           (list command nil nil nil )
                           (split-string (or args ""))))))
(defun tirimia/get-vault-secret (addr path &optional field)
  "Get secrets under PATH from vault ADDR. Optionally can select a FIELD."
  (let* (
         (vault-env (format "VAULT_ADDR=%s" addr))
         (login (or (eq 0
                        (tirimia/call-cmd "vault" vault-env "token lookup"))
                    (tirimia/call-cmd "vault" vault-env "login -method=oidc -path=Okta role=sre")))
         (field-query (when field (format " -field=%s" field)))
         (cmd (format "%s kv get%s %s" "vault" field-query vault-path))
         )
    ;; TODO: make sure this uses the VAULT_ADDR environment
    (shell-command-to-string cmd)))
;; (call-process "vault" nil "temporary" nil "token" "lookup")
;; (tirimia/get-vault-secret
;;  "https://vault.infra.schuett.tech"
;;  "kv/temporary_prod_creds"
;;  "DATABASE_URL")

(defun tirimia/math-at-point ()
  "Replace number at point with result of prompted algebraic expression."
  (interactive)
  (save-excursion
    (when-let* ((num (number-at-point))
		(bounds (bounds-of-thing-at-point 'symbol))
		(result (calc-eval
			 (read-from-minibuffer
			  (format "Replace %d with: " num)
			  (number-to-string num))
			 ;; Results that are not a number will be an error
			 'num)))
      ;; Errors from the last step come back as lists
      (unless (listp result)
	(delete-region (car bounds) (cdr bounds))
	(insert result)))))

(defun tirimia/convert-and-insert ()
  "Takes a value with a unit and inserts the converted result without units"
  (interactive)
  (save-excursion
    (when-let*
	((number (calc-eval
		  `(,(math-convert-units
		      (calc-eval (read-from-minibuffer "Original value: ") 'raw)
		      (calc-eval (read-from-minibuffer "Unit: ") 'raw))
		    ;; Write the whole thing out in case of large numbers
		    calc-internal-prec 50))))
      (insert
       (save-match-data
	 (when (string-match (rx (group (one-or-more digit))) number)
	   (match-string 1 number)))))))
;; Original value: 3 day
;; Unit: ms
;; 259200000

(defun tirimia/topics-to-kafka-reassignment ()
  "In a plain buffer with a list of topics, turn these into a json
file compatible with the kafka partition reassignment tool."
  (interactive
   (let* ((topics (tirimia/lines (buffer-string)))
	  (topic-list (-map (lambda (name) (ht ("topic" name))) topics))
	  (json-encoding-pretty-print t))
     (erase-buffer)
     (insert
      (json-encode
       (ht ("version" 1)
	   ("topics" topic-list))))
     (save-buffer))))
;; {
;; "version": 1,
;; "partitions": [
;;                {
;;                "topic": "content.review.acquired_review",
;;                "partition": 7,
;;                "replicas": [
;;                             13,
;;                             33
;;                             ]
;;                }
;;                ]
;; }
(defun tirimia/kafka-reassignment-replace-broker ()
  "In a JSON file with a topic reassignment, replaces a broker ID by another."
  (interactive
   (let* ((json-encoding-pretty-print t)
	  (old-json (json-parse-string (buffer-string)))
	  (old-broker (read-number "Old broker: "))
	  (new-broker (read-number "New broker: "))
	  (new-json (ht ("version" (ht-get old-json "version"))
			("partitions"
			 (-map (lambda (entry)
				 (ht ("topic" (ht-get entry "topic"))
				     ("partition" (ht-get entry "partition"))
				     ("replicas"
				      (cl-substitute new-broker old-broker (ht-get entry "replicas")))))
			       (ht-get old-json "partitions"))))))
     (erase-buffer)
     (insert (json-encode new-json)))))

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
      org-agenda-files '("~/MEGA/Org/Agenda.org" "~/MEGA/Org/Daily")
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
(tirimia/key-definer
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
(tirimia/key-definer
  :keymaps 'org-mode-map
  :major-modes t
  "m" '(:ignore t :which-key "Org Mode")
  "mc" '(org-capture :which-key "Export")
  "mE" '(org-export-dispatch :which-key "Export")
  "md" '(org-deadline :which-key "Deadline")
  "me" '(org-edit-src-code :which-key "Edit code")
  "mi" '(org-insert-heading-respect-content :which-key "New heading")
  "mj" '(org-forward-heading-same-level :which-key "Next heading")
  "mk" '(org-backward-heading-same-level :which-key "Prev heading")
  "ml" '(:ignore t :which-key "Link")
  "mli" '(org-insert-link :which-key "Insert/edit")
  "mlo" '(org-open-at-point :which-key "Open")
  "mp" '(org-set-property :which-key "Propertize")
  "ms" '(org-schedule :which-key "Schedule")
  "mt" '(org-todo :which-key "Toggle TODO")
  "mT" '(org-set-tags-command :which-key "Tags")
  "mx" '(org-babel-execute-src-block :which-key "Run block")
  )

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
  "Improve org-switch-to for roam-daily-users. If cursor is on a
date heading, the function originally throws an error. With this
added :around, it goes to capture the respective daily note"
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

(tirimia/key-definer
  "'" '(tirimia/fresh-vterm :which-key "Shell")
  "/" '(consult-ripgrep :which-key "Search")
  ":" '(eval-expression :which-key "M-:")
  "=" '(tirimia/math-at-point :which-key "Math")
  tirimia/leader-key '(consult-buffer :which-key "Switch")
  tirimia/alt-leader-key '(execute-extended-command :which-key "M-x")
  "c" '(kill-buffer-and-window :which-key "Close")
  "f" '(find-file :which-key "Find file")
  "g" '(magit-status :which-key "Magit")
  "h" '(describe-symbol :which-key "Help")
  "k" '(kill-current-buffer :which-key "Kill")

  ;; Inserts
  "i" '(:ignore t :which-key "Insert")
  "iu" '(tirimia/insert-uuid :which-key "UUID")

  ;; Profiler
  "p" '(:ignore t :which-key "Profiler")
  "pp" '(profiler-start :which-key "Start")
  "pr" '(profiler-report :which-key "Report")
  "ps" '(profiler-stop :which-key "Stop")

  ;; Windows
  "w" '(:ignore t :which-key "Windows")
  "w <left>" '(evil-window-left :which-key "window left")
  "wh" '(evil-window-left :which-key "window left")
  "w <right>" '(evil-window-right :which-key "window right")
  "wl" '(evil-window-right :which-key "window right")
  "w <down>" '(evil-window-down :which-key "window down")
  "wj" '(evil-window-down :which-key "window down")
  "w <up>" '(evil-window-up :which-key "window up")
  "wk" '(evil-window-up :which-key "window up")
  "wv" '(evil-window-vsplit :which-key "vertical split")
  "ws" '(evil-window-split :which-key "split")
  "wd" '(evil-window-delete :which-key "delete")
  "wn" '(make-frame-command :which-key "new frame")
  "ww" '(tirimia/binary-window-split :which-key "Binary split")

  ;; Toggles
  "t" '(:ignore t :which-key "Toggles")
  "te" '(consult-flycheck :which-key "Go to error")
  "tf" '(focus-mode :which-key "Focus mode")
  "ti" '(imenu-list-smart-toggle :which-key "Imenu List")
  "tr" '(rainbow-mode :which-key "Rainbow mode")
  "ts" '(whitespace-mode :which-key "Whitespace indicators")
  "tt" '(toggle-truncate-lines :which-key "Line wraps")
  "tz" '(darkroom-mode :which-key "Zen mode"))
;; (use-package tarot-mode
;;   :straight (:local-repo "~/MEGA/Projects/Emacs/tarot-mode"))
(use-package plz)
(use-package hush
  :straight (:local-repo "~/MEGA/Projects/Emacs/hush"))
(use-package linear-mode
  :straight (:local-repo "~/MEGA/Projects/Emacs/linear-mode")
  ;; TODO: import from a secret storage
  ;; TODO: emacs keychain integration
  :custom (linear-mode-get-api-key (lambda () (hush-get '(:vault "Private" :path "LinearPAT/password") "1password"))))

;; TODO: see if we should disable dtrt when editorconfig kicks in
(use-package editorconfig
  :commands (editorconfig-mode)
  :config (editorconfig-mode))

(provide 'init)

;;; init.el ends here
