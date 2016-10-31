(require 'saveplace)
(require 'cl) ;; common-lisp stuff 


;; move all tildefiles to ~/.saves
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups



;; save place in file when re-opening it
(setq-default save-place t)



;; set up melpa
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
    (package-initialize))


;; get packages that are missing
(defvar riccardo/packages '(gist
                            go-autocomplete
                            go-mode
                            haskell-mode
                            markdown-mode
                            scala-mode
                            solarized-theme
                            verilog-mode)
  "Default packages")


(defun riccardo/packages-installed-p ()
  (cl-loop for pkg in riccardo/packages
        when (not (package-installed-p pkg)) do (cl-return nil)
        finally (cl-return t)))

(unless (riccardo/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg riccardo/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))


;; no tabs plz
(setq tab-width 2
      indent-tabs-mode nil)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(package-selected-packages
   (quote
    (go-eldoc flycheck go-autocomplete solarized-theme go-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; load solarized-light by default
(load-theme 'solarized-light)


;; follow symlinks automatically
(setq vc-follow-symlinks t)


;; go-mode, and go fmt before save

(require 'go-autocomplete)

(add-hook 'go-mode-hook
          (lambda ()
            (go-eldoc-setup)
            (add-hook 'before-save-hook 'gofmt-before-save)))
