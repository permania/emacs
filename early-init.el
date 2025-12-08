(defvar default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 1)

(defun +gc-after-focus-change ()
  "Run GC when frame loses focus."
  (run-with-idle-timer
   5 nil
   (lambda () (unless (frame-focus-state) (garbage-collect)))))

(defun +reset-init-values ()
  (run-with-idle-timer
   1 nil
   (lambda ()
     (setq file-name-handler-alist default-file-name-handler-alist
           gc-cons-percentage 0.1
           gc-cons-threshold 100000000)
     (when (boundp 'after-focus-change-function)
       (add-function :after after-focus-change-function #'+gc-after-focus-change)))))

(with-eval-after-load 'elpaca
  (add-hook 'elpaca-after-init-hook '+reset-init-values))

(setq package-enable-at-startup nil)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq visual-bell t)

(defun pm/apply-fonts ()
  (set-face-attribute 'default nil :font "Maple Mono CN" :height 120 :weight 'regular)
  (set-face-attribute 'fixed-pitch nil :font "Maple Mono CN" :height 120 :weight 'regular)
  (set-face-attribute 'variable-pitch nil :font "Open Sans" :height 120 :weight 'regular)
  (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
  (set-face-attribute 'font-lock-keyword-face nil :slant 'italic))

;; Apply font settings after Emacs has initialized
(add-hook 'elpaca-after-init-hook #'pm/apply-fonts)

;; Apply font settings for new frames (e.g., when using emacsclient)
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (with-selected-frame frame
              (pm/apply-fonts))))
