;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Rajesh Sharma"
      user-mail-address "rajesh@surf.net.np")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Reuse your existing vim/vimwiki notes instead of starting a fresh, empty
;; ~/org/ directory. It must be set before org loads!
(setq org-directory "~/notes/")

;; Same rationale as vim/basic-settings.vim: hard-wrapping breaks long URLs
;; mid-paragraph. Soft-wrap org buffers at the window edge instead of
;; inserting real line breaks at `fill-column'.
(add-hook 'org-mode-hook #'visual-line-mode)

;; Muscle-memory bindings ported from vim/mappings.vim and vim/basic-settings.vim.
(map! :nvoi "C-SPC" #'evil-force-normal-state
      :nvoi "C-@"   #'evil-force-normal-state  ; some terminals send C-@ for C-SPC
      :n  ",f" #'projectile-find-file  ; vim: <Leader>f -> :Files (fuzzy find in project)
      :n  ",w" #'basic-save-buffer     ; vim: <Leader>w -> :update (save if modified)
      :n  ",," #'evil-ex)              ; vim: <Leader><Leader> -> : (same as pressing : directly)

;; Doom's completion module (corfu) claims C-SPC/C-@ in corfu-mode-map and
;; corfu-map (for triggering/navigating completion), and those buffer-local
;; minor-mode keymaps take precedence over the global evil state keymaps
;; above in every buffer where corfu-mode is active -- which is nearly all
;; of them. Re-override at that same level so C-SPC reliably means "back to
;; normal state" instead of "start completion".
(after! corfu
  (map! :map corfu-mode-map
        :nvi "C-SPC" #'evil-force-normal-state
        :nvi "C-@"   #'evil-force-normal-state
        :map corfu-map
        :i "C-SPC" #'evil-force-normal-state
        :i "C-@"   #'evil-force-normal-state))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
