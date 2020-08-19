(prefer-coding-system 'utf-8)
(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;;fixes an issue when accessing elpa.gnu.org.
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(next-error-recenter 0)
 '(package-selected-packages
   (quote
    (ivy-rtags modern-cpp-font-lock json-mode cmake-mode gnu-elpa-keyring-update pyenv-mode pangu-spacing projectile python-mode org markdown-mode magit rtags)))
 '(show-paren-mode t))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)

;; ivy mode
(require 'ivy)
(ivy-mode t)

;; server frame size
(add-to-list 'default-frame-alist '(height . 70))
(add-to-list 'default-frame-alist '(width . 128))
;; KDE prefer emacsclient cursor color to dark, I prefer white
(add-to-list 'default-frame-alist '(cursor-color . "white"))

;; client frame size
(add-hook 'before-make-frame-hook
          #'(lambda ()
              (add-to-list 'default-frame-alist '(left   . 0))
              (add-to-list 'default-frame-alist '(top    . 0))
              (add-to-list 'default-frame-alist '(height . 70))
              (add-to-list 'default-frame-alist '(width  . 128))))

;; switch frame
(global-set-key (kbd "<f11>") (lambda () (interactive) (other-frame 1)))
(global-set-key (kbd "<f12>") (lambda () (interactive) (other-frame -1)))

;; switch window
(global-set-key (kbd "M-o") #'other-window)

;; set shortcut to kill whole emacs session
(global-set-key (kbd "C-x c") 'save-buffers-kill-emacs)

;; terminal display UTF-8
(add-hook 'term-exec-hook
          (function
           (lambda ()
             (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))))


;; load-path ;; disabled since clang++ has 2 versions (brew and Xcode)
;;(let ((default-directory  "~/.emacs.d/site-lisp/"))
;;  (normal-top-level-add-to-load-path '("."))
;;  (normal-top-level-add-subdirs-to-load-path))

;; used by emacs shell
(setenv "PATH" (concat "/usr/local/opt/llvm/bin:" "/usr/local/bin:" (getenv "PATH") ))
;; used by emacs
;;(setq exec-path (append exec-path '("/usr/local/bin")))
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "/usr/local/opt/llvm/bin")

;; set ibuffer as the default buffer manager
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; auto encrypt
(require 'epa-file)
(epa-file-enable)

;; magit
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

;; markdown mode autoload
(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))

;; c offset
(setq c-default-style "linux" c-basic-offset 8)

;; c-mode autoload
(add-to-list 'auto-mode-alist '("\\.c\\'" . c-mode))

;; c lang: offset case in switch
(c-set-offset 'case-label '+)

;; search word at cursor
(global-set-key (kbd "M-s") 'isearch-forward-symbol-at-point)

;; cmake-mode autoload
(autoload 'cmake-mode "cmake-mode" "Major mode for CMake files" t)
(add-to-list 'auto-mode-alist '("\\CMakeLists\\.txt\\'" . cmake-mode))

;; matching parenthesis
(show-paren-mode 1)

;; Remove splash screen
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;; smooth scroll
(setq scroll-margin 0 scroll-conservatively 10000 )

;; highlight parenthesis
(transient-mark-mode t)

(setq c-mode-hook
      '(lambda ()
	 ))

(setq c++-mode-hook
      '(lambda ()
	 (modern-c++-font-lock-global-mode t)
	 ))

;; for clear git diff
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; disable automatic python doc
(global-eldoc-mode -1)

;; glsl-mode
;;(require 'glsl-mode)
;;(autoload 'glsl-mode "glsl-mode" nil t)
;;(add-to-list 'auto-mode-alist '("\\.glsl\\'" . glsl-mode))
;;(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
;;(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))
;;(add-to-list 'auto-mode-alist '("\\.vs\\'" . glsl-mode))
;;(add-to-list 'auto-mode-alist '("\\.fs\\'" . glsl-mode))
;;(add-to-list 'auto-mode-alist '("\\.geom\\'" . glsl-mode))


;; projectile
(require 'projectile)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)


;; rtags
(eval-after-load 'cc-mode
  '(progn
     (require 'rtags)
     (mapc (lambda (x)
	     (define-key c-mode-base-map
	       (kbd (concat "C-z " (car x))) (cdr x)))
	   '(("." . rtags-find-symbol-at-point)
	     ("," . rtags-find-references-at-point)
	     ("v" . rtags-find-virtuals-at-point)
	     ("V" . rtags-print-enum-value-at-point)
	     ("/" . rtags-find-all-references-at-point)
	     ("Y" . rtags-cycle-overlays-on-screen)
	     (">" . rtags-find-symbol)
	     ("<" . rtags-find-references)
	     ("-" . rtags-location-stack-back)
	     ("+" . rtags-location-stack-forward)
	     ("D" . rtags-diagnostics)
	     ("G" . rtags-guess-function-at-point)
	     ("p" . rtags-set-current-project)
	     ("P" . rtags-print-dependencies)
	     ("e" . rtags-reparse-file)
	     ("E" . rtags-preprocess-file)
	     ("R" . rtags-rename-symbol)
	     ("M" . rtags-symbol-info)
	     ("S" . rtags-display-summary)
	     ("O" . rtags-goto-offset)
	     (";" . rtags-find-file)
	     ("F" . rtags-fixit)
	     ("X" . rtags-fix-fixit-at-point)
	     ("B" . rtags-show-rtags-buffer)
	     ("I" . rtags-imenu)
	     ("T" . rtags-taglist)))))

;; toggle read-only on directory
(add-hook 'find-file-hook
          (lambda ()
            (dolist (pattern '("~/.pyenv/versions/.*"
			       "~/Documents/blender-dev/blender/.*"
			       "~/Documents/mlpack/.*"
                               ;; add here
                               ))
              (if (string-match (expand-file-name pattern) buffer-file-name)
                  (read-only-mode)
                ))))

;; using ivy as auto-completion backend
(require 'ivy-rtags)
(setq rtags-display-result-backend 'ivy)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "Black" :foreground "White" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 240 :width normal :foundry "nil" :family "Monaco")))))
