;;init.el --- Emacs configuration
;; INSTALL PACKAGES
;; ------------------------------------

(require 'package)
(add-to-list 'package-archives '("melpa". "http://melpa.milkbox.net/packages/"))
(package-initialize)
;;(when (not package-archive-contents)
;;  (package-refresh-contents))

;;{{(defvar myPackages
;;  '(better-defaults
;;    material-theme))

;;(mapc #'(lambda (package)
;;	  (unless (package-installed-p package)
;;	    (package-install package)))
;;      myPackages)}}

;;BASIC CUSTOMIZATION
;;-------------------------------------

;;(setq inhibit-startup-message t)   ;;hide the startup message
(global-linum-mode t)              ;;enable line number globally
;;i like having the clock
(display-time-mode 1)
;; disable the tool-bar
(tool-bar-mode -1)
;; disable the menu-bar
;;(menu-bar-mode -1)
;;load-theme
(load-theme 'tangotango t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/color-theme-tangotango")

;;full screen
(global-set-key [f11] 'my-fullscreen)
(defun my-fullscreen()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   ' (2 "_NET_WM_STATE_FULLSCREEN" 0))
  ) 

;;screen maximized
(defun my-maximized()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   ' (2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   ' (2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  )
;;load maximized
;;(my-maximized)
;;load fullscreen
(my-fullscreen)


;;keep pushing for the Emacs maintainers for fix window-min-size
(defun split-window-right-ignore (&optional size)
  (if (car size) size (list (/ (window-total-width) 2))))

;;(advice-add 'split-window-right: filter-args
;;	    'split-window-right-ignore)
(visual-line-mode 1)
(org-indent-mode 1)

;;alpha
;;(global-set-key (kbd"<f10>")'loop-alpha)
;;current window and not current window alpha
;;(setq alpha-list'((90 70)(100 100)))
;;(defun loop-alpha()
;;  (interactive)
;;  (let ((h (car alpha-list)))
;;    ((lambda(a ab)
;;       (set-frame-parameter(selected-frame)'alpha(list a ab))
;;       (add-to-list 'default-frame-alist(cons 'alpha (list a ab))))
;;     (car h)(car (cdr h)))
;;    (setq alpha-list(cdr (append alpha-list(list h))))))
;;automatic start alpha
;;(loop-alpha)


;;Since Emacs 23.2 you can use visual-line-mode and org-indent-mode. The view is much cleaner, long lines fold (which solves bill's problem) and the resulting .org file is easier to read with other text editors, which helps sharing documents with other people.





;;REQUIRE PACKAGES
;;--------------------------------------
;;start auto-complete with emacs
(require 'auto-complete)
;;do default config for auto-complete
(require 'auto-complete-config)
(ac-config-default)

;;start yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;;fix iedit bug in Mac
(define-key global-map (kbd "C-c ;") 'iedit-mode)  ;;C-c ; but doesnt work


;;add flymake-google-cpplint to load-path
;;(add-to-list 'load-path "~/.eamcs.d/flymake-google-cpplint-20140205.525/flymake-google-cpplint.el")
;;start flymake-google-cpplint-load
;;let's define a function for flymake initialization
(defun my:flymake-google-init()
  (require 'flymake-google-cpplint)   ;;should install cpplint before
  (custom-set-variables
  '(flymake-google-cpplint-command "/usr/local/bin/cpplint"))
  (flymake-google-cpplint-load)
)
(add-hook 'c-mode-hook 'my:flymake-google-init)
(add-hook 'c++-mode-hook 'my:flymake-google-init)

;;theme
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(case-fold-search nil)
 '(custom-enabled-themes (quote (tangotango)))
 '(custom-safe-themes
   (quote
    ("4e63466756c7dbd78b49ce86f5f0954b92bf70b30c01c494b37c586639fa3f6f" default)))
 '(flymake-google-cpplint-command "/usr/local/bin/cpplint")
 '(flymake-google-cpplint-linelength "120")
 '(flymake-google-cpplint-location (quote tempdir))
 '(flymake-google-cpplint-verbose "3"))
;;cpplint.py command location

;;start google-c-style with emacs
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;;where to create temporary copy



;;turn on Semantic
(semantic-mode 1)
;;let's define a function which add semantic as a suggestion backend to auto complete
;and hook this function to c-mode-common-hook
(defun my:add-semantic-to-autocomplete()
  (add-to-list 'ac-sources 'ac-source-semantic)
)
(add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)
;;turn on ede mode-line
(global-ede-mode 1)
;;create a project for your program;  !!each time you create a project??
;;(ede-cpp-root-project "my project":file "~/src/main.cpp"
;;		      :include-path '("/usr/lib/gcc/i586-redhat-linux/4.4.1/include"))
;;you can use system-include-path for setting up the system header file locations.
;;turn on automatic reparsing of open buffers in semantic
(global-semantic-idle-scheduler-mode 1)



;;(require 'setup-helm-gtags)
;;(require 'setup-ggtags)
;; using from the source file cause can not be downloaded via the net
(require 'ggtags)   
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)
;;(define-key helm-ggtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)   ;;can't sure is the helm-ggtags-mode-map exist?
(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)
;;Imenu offer a way to find the major definitions, such as function definitions 
(setq-local imenu-create-index-function #'ggtags-build-imenu-index)

;;require helm-gtags
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

;;(require 'helm-gtags)
;; Enable helm-gtags-mode
;;(add-hook 'dired-mode-hook 'helm-gtags-mode)
;;(add-hook 'eshell-mode-hook 'helm-gtags-mode)
;;(add-hook 'c-mode-hook 'helm-gtags-mode)
;;(add-hook 'c++-mode-hook 'helm-gtags-mode)
;;(add-hook 'asm-mode-hook 'helm-gtags-mode)

;;(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
;;(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
;;(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
;;(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
;;(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
;;(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

;;add funtion-args to emacs
(require 'function-args)
(fa-config-default)
;;put c++-mode as default for *.h files (optional)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;add sr-speedbar if you want a static outline tree
(require 'sr-speedbar)
;;only want ASCCII, even in GUI Emacs
(setq speedbar-use-images nil)

;;add company-mode, which is a text completion framework for Emacs
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;;use company-mode with Clang, add this configuration; ;;c-mod-map is void
;;(setq company-backends (delete 'company-semantic company-backends))
;;(define-key c-mode-mape  [(tab)] 'company-complete)
;;(define-key c++-mode-map  [(tab)] 'company-complete)

(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )

;;company-c-headers provides auto-completion for C/C++ headers using company
(add-to-list 'company-backends 'company-c-headers)
;;(add-to-list 'company-c-headers-path-system "/usr/lib/gcc/i586-redhat-linux/4.4.1/include")
(defun my:ac-c-header-init()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories '"/usr/lib/gcc/i586-redhat-linux/4.4.1/include")
) 

;;add eply package archive to your list of archive
(require 'package)
(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))
;;enable Elpy by default
(package-initialize)
(elpy-enable)


;;add wordnet
;;(add-to-list 'load-path "/)
(require 'wordnut)
(global-set-key [f12] 'wordnut-search)
(global-set-key [(control f12)] 'wordnut-lookup-current-word)


;;nyan-mode
(add-to-list 'load-path "~/.emacs.d/nyan-mode")
(require 'nyan-mode)
(setq default-mode-line-format
      (list ""
	    'mode-line-modified
	    "<"
	    "Tim is upgrading..."
	    ">"
	    "%10b"
	    '(:eval (when nyan-mode (list (nyan-create))))
	    " "
	    'default-directory'
	    " "
	    "%[("
	    'mode-name
	    'minor-mode-list
	    "%n"
	    'mode-line-process
	    ")&]--"
	    "Line %l--"
	    '(-3 . "%P")
	    "-%-"))
;;start nyan-mode
(nyan-mode t)
;;dancing
(nyan-start-animation)
;;(setq-default nyan-wavy-trail t)

;;--------
;;Org-mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;;add the files to search for TODOs and scheduled items
(setq org-agenda-files (list "~/org/digital.org"
			     "~/org/school.org"
			     "~/org/home.org"
			     "~/org/events.org"
			     "~/org/gtd.org"))

;;org-pomodoro
(require 'org-pomodoro)
(require 'pomodoro)
(pomodoro-add-to-mode-line)
;;(org-pomodoro-add-to-mode-line)
;;(define-key global-map "\C-cl" 'org-store-link)
;;(define-key global-map (kbd "C-c ;") 'iedit-mode)  ;;C-c ; but doesnt work
;;(define-key global-map (kbd "C-c p") 'lambda()(interactive) (org-clock-in)(org-pomodoro)(pomodoro-start))  ;;C-c ; but doesnt work
;;(global-set-key)(kbd "C-c p)(lambda()(interactive) (org-clock-in)(org-pomodoro)(pomodoro-start))
;;(global-set-key)(kdb "C-c-s)
;;(org-pomodoro-update-mode-line)

;;(org-pomodoro-update-mode-line)

;;(setq frame-title-format '("" Tim "@" htwt " " org-pomodoro-mode-line))
(defun my-run-org-pomodoro-commands()
  "Run (org-clock-in)(org-pomodoro)(pomodoro-start) in sequence"
  (interactive)
  (org-clock-in)
  (org-pomodoro))
  ;;(pomodoro-start))
(global-set-key (kbd "C-c p") 'my-run-org-pomodoro-commands)

;; An entry without a cookie is treat just like priority 'B'
;; So when create new task, they are default "important and urgent"

(setq org-agenda-custom-commands
      '(
	("w" . "Tasks Agenda")
	("wa" "Important and Urgent" tags-todo "+PRIORITY=\"A\"")
	("wb" "important not urgent" tags-todo "-Weekly-Monthly-Daily+PRIORITY=\"B\"")
	("wc" "not important not urgent" tags-todo "+PRIORITY=\"C\"")
	("b" "Blog" tags-todo "BLOG")
	("p" . "Project Agenda")
	("ps" tags-todo "PROJECT+WORK+CATEGORY=\"SDL\"")
        ("pt" tags-todo "PROJECT+DREAM+CATEGORY=\"Tim\"")
	("W" "Weekly Review"
	 ((stuck "") ;; review stuck projects as designated by org-stuck-projects
	 (tags-todo "PROJECT") ;; review all projects(assuming you use todo keywords to designate projects)
	 ))))

;; Multi status
(setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d)")
	(sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")
	(sequence "|" "CANCELED(c)")))




;; --------




;;init.el ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
