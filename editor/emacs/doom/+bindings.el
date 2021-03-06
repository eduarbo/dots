;;; ~/dev/dotfiles/editor/emacs/doom/+bindings.el -*- lexical-binding: t; -*-

;;                 ▄▄▄▄· ▪   ▐ ▄ ·▄▄▄▄  ▪   ▐ ▄  ▄▄ • .▄▄ ·
;;                 ▐█ ▀█▪██ •█▌▐███▪ ██ ██ •█▌▐█▐█ ▀ ▪▐█ ▀.
;;                 ▐█▀▀█▄▐█·▐█▐▐▌▐█· ▐█▌▐█·▐█▐▐▌▄█ ▀█▄▄▀▀▀█▄
;;                 ██▄▪▐█▐█▌██▐█▌██. ██ ▐█▌██▐█▌▐█▄▪▐█▐█▄▪▐█
;;                 ·▀▀▀▀ ▀▀▀▀▀ █▪▀▀▀▀▀• ▀▀▀▀▀ █▪·▀▀▀▀  ▀▀▀▀

;;                  == Spacemacs-esque keybinding scheme ==


(defvar +completion-map (make-sparse-keymap))
(defvar +org-format-map (make-sparse-keymap))
(defvar +org-log-buffer-mode-map (make-sparse-keymap))

;; Setup minor mode for org note log buffers
(define-minor-mode +org-log-buffer-mode
  "Minor mode for org note log buffers"
  :keymap +org-log-buffer-mode-map)
(add-hook! 'org-log-buffer-setup-hook #'+org-log-buffer-mode)

(setq
  doom-leader-key ","
  doom-localleader-key ", m"
  +evil-repeat-keys '("+" . "-"))


;; ┏━╸╻  ┏━┓┏┓ ┏━┓╻  ┏━┓
;; ┃╺┓┃  ┃ ┃┣┻┓┣━┫┃  ┗━┓
;; ┗━┛┗━╸┗━┛┗━┛╹ ╹┗━╸┗━┛

(map!
  :m    ":"             #'execute-extended-command
  :m    ";"             #'evil-ex

  :n    "#"             #'evilnc-comment-or-uncomment-lines
  :v    "#"             #'evilnc-comment-operator

  :nv   "SPC"           #'+default/search-project-for-symbol-at-point
  :nv   "S-SPC"         #'+default/search-project

  :i    "S-SPC"         #'tab-to-tab-stop

  ;; Tab

  ;; This allows org-mode to bind org-cycle properly... do not why
  :nvm  [tab]           nil

  (:map prog-mode-map
    :nv [tab]           #'evil-jump-item
    :n  [S-tab]         #'evil-toggle-fold)

  (:when (featurep! :completion company)
    :i  [tab]           #'+company/complete
    :i  [C-tab]         +completion-map)

  (:when (featurep! :editor snippets)
    :i  [S-tab]         (λ! (unless (call-interactively 'yas-expand)
                              (call-interactively 'company-yasnippet)))
    :v  [S-tab]         #'yas-insert-snippet

    :i  [C-return]      #'aya-expand
    :nv [C-return]      #'aya-create)


  ;; Buffer/Workspace Navigation

  "s-["                 #'previous-buffer
  "s-]"                 #'next-buffer
  "s-h"                 #'previous-buffer
  "s-l"                 #'next-buffer

  (:when (featurep! :ui workspaces)
    "s-{"               #'+workspace/switch-left
    "s-}"               #'+workspace/switch-right
    "s-H"               #'+workspace/switch-left
    "s-L"               #'+workspace/switch-right)

  :gn   "s-j"           #'evil-switch-to-windows-last-buffer
  :gn   "s-J"           #'+eduarbo/switch-to-last-workspace


  ;; Easier window navigation

  (:map general-override-mode-map
    :n  "C-h"           #'evil-window-left
    :n  "C-j"           #'evil-window-down
    :n  "C-k"           #'evil-window-up
    :n  "C-l"           #'evil-window-right)
  ;; overrides
  (:after evil-org-agenda :map evil-org-agenda-mode-map
    :m  "C-h"           #'evil-window-left
    :m  "C-j"           #'evil-window-down
    :m  "C-k"           #'evil-window-up
    :m  "C-l"           #'evil-window-right)
  (:map comint-mode-map
    :in "C-h"           #'evil-window-left
    :in "C-j"           #'evil-window-down
    :in "C-k"           #'evil-window-up
    :in "C-l"           #'evil-window-right)
  (:after treemacs-mode :map treemacs-mode-map
    :g  "C-h"           #'evil-window-left
    :g  "C-l"           #'evil-window-right)


  ;; Shortcuts

  :gv     "s-x"         #'execute-extended-command
  "s-;"                 #'pp-eval-expression
  "s-f"                 #'swiper-thing-at-point
  :ginv "s-/"           #'helpful-key
  ;; "s-?"                 #'which-key-show-top-level
  "s-?"                 #'counsel-descbinds
  "s--"                 #'doom/decrease-font-size
  "s-+"                 #'doom/increase-font-size
  "s-="                 #'doom/reset-font-size
  "s-,"                 #'doom/find-file-in-private-config
  "s-<"                 #'doom/open-private-config

  "s-."                 (cond ((featurep! :completion ivy) #'ivy-resume)
                          ((featurep! :completion helm)    #'helm-resume))
  "s->"                 #'+popup/toggle

  "s-b"                 #'bookmark-jump
  "s-B"                 #'bookmark-delete
  "s-g"                 #'magit-status
  "s-i"                 #'org-capture
  "s-I"                 #'org-journal-new-entry
  "s-p"                 #'+treemacs/toggle
  "s-P"                 #'treemacs-find-file
  "s-r"                 #'+eval/open-repl-other-window
  "s-R"                 #'+eval/open-repl-same-window
  "s-u"                 #'winner-undo
  "s-U"                 #'winner-redo
  "s-y"                 #'+default/yank-pop


  ;; Text objects

  :gi   [C-backspace]   #'delete-forward-char

  :gi   "C-f"           #'forward-word
  :gi   "C-b"           #'backward-word

  :m    "H"             #'sp-backward-symbol
  :m    "L"             #'sp-forward-symbol
  :gi   "C-h"           #'sp-backward-symbol
  :gi   "C-l"           #'sp-forward-symbol

  :gi   "C-d"           #'evil-delete-line
  :gi   "C-S-d"         #'evil-delete-whole-line
  :gi   "C-S-u"         #'evil-change-whole-line
  :gi   "C-S-w"         #'backward-kill-sexp

  :gi   "C-S-a"         #'sp-beginning-of-sexp
  :gi   "C-S-e"         #'sp-end-of-sexp

  :gi   "C-t"           #'transpose-chars
  :nv   "C-a"           #'evil-numbers/inc-at-pt
  :nv   "C-S-a"         #'evil-numbers/dec-at-pt

  :m    "k"             #'evil-previous-visual-line
  :m    "j"             #'evil-next-visual-line
  :m    [up]            #'+evil-multi-previous-line
  :m    [down]          #'+evil-multi-next-line

  :n    "s"             #'evil-surround-edit
  :v    "s"             #'evil-surround-region


  ;; expand-region

  :v    "v"             (general-predicate-dispatch 'er/expand-region
                          (eq (evil-visual-type) 'line)
                          'evil-visual-char)
  :v    "C-v"           #'er/contract-region
)


;;; [g]o-to prefix

(map!
  (:prefix "g"
    :nv "Q"     #'+eduarbo/unfill-paragraph
    :nv "o"     #'avy-goto-char-timer
    :nv "O"     (λ! (let ((avy-all-windows t)) (avy-goto-char-timer)))
    :n  "."     #'call-last-kbd-macro
    :nv "k"     #'avy-goto-line-above
    :nv "j"     #'avy-goto-line-below
    :nv "s"     #'transpose-sexps
    :nv "w"     #'transpose-words
    :nv "a"     #'evil-snipe-s
    :nv "A"     #'evil-snipe-S
    :v  [tab]   #'evil-vimish-fold/create
    :n  [tab]   #'evil-vimish-fold/delete
    :n  [S-tab] #'evil-vimish-fold/delete-all
    ;; narrowing and widening
    :nv "n"     #'+eduarbo/narrow-or-widen-dwim))


;; ┏┳┓┏━┓╺┳┓╻ ╻╻  ┏━╸┏━┓
;; ┃┃┃┃ ┃ ┃┃┃ ┃┃  ┣╸ ┗━┓
;; ╹ ╹┗━┛╺┻┛┗━┛┗━╸┗━╸┗━┛

;;; :completion

(map!
  (:when (featurep! :completion company)
    (:after company
      (:map company-active-map
        [S-tab]   #'company-select-previous
        "C-l"     #'company-complete
        [right]   #'company-complete
        "C-h"     #'company-abort
        [left]    #'company-abort)

      (:map +completion-map
        "d"      #'+company/dict-or-keywords
        "f"      #'company-files
        "s"      #'company-ispell
        [C-tab]  #'company-yasnippet
        "o"      #'company-capf
        "a"      #'+company/dabbrev)))

  (:when (featurep! :completion ivy)
    (:after ivy :map ivy-minibuffer-map
      [S-return] #'ivy-immediate-done
      "C-n"      #'scroll-up-command
      "C-p"      #'scroll-down-command
      "s-o"      #'hydra-ivy/body)
    (:after counsel :map counsel-ag-map
      [S-tab]  #'+ivy/woccur
      [C-return] #'+ivy/git-grep-other-window-action
      "C-o"      #'+ivy/git-grep-other-window-action)
    (:after swiper :map swiper-map
      [S-tab] #'+ivy/woccur))

  (:when (featurep! :completion helm)
    (:after swiper-helm
      :map swiper-helm-keymap [S-tab] #'helm-ag-edit)
    (:after helm-ag
      :map helm-ag-map
      [S-tab]  #'helm-ag-edit)))


;;; evil-snipe

(map! :after evil-snipe :map (evil-snipe-override-mode-map evil-snipe-parent-transient-map)
  :nv "S" (λ! (require 'evil-easymotion)
          (call-interactively
            (evilem-create #'evil-snipe-repeat
              :bind ((evil-snipe-scope 'whole-buffer)
                      (evil-snipe-enable-highlight)
                      (evil-snipe-enable-incremental-highlight)))))

  ;; Don't interfere with my bindings
  :gm ";"  nil
  :gm ","  nil)


;;; snippets

(map!
  (:when (featurep! :editor snippets)
    :i  [S-tab]    (λ! (unless (call-interactively 'yas-expand)
                         (call-interactively 'company-yasnippet)))
    :v  [S-tab]    #'yas-insert-snippet

    :i  [C-return] #'aya-expand
    :nv [C-return] #'aya-create

    (:after yasnippet :map yas-keymap
      ;; Do not interfer with company
      [tab]         nil
      "TAB"         nil
      [S-tab]       nil
      "<S-tab>"     nil
      "C-n"         #'yas-next-field
      "C-p"         #'yas-prev-field
      "C-l"         #'yas-next-field
      "C-h"         #'yas-prev-field)))


;;; flyspell

(map!
  :after flyspell
  (:map (org-mode-map evil-org-mode-map)
    [S-return] #'eduarbo/add-word-to-dictionary))


;;; multiple-cursors

(map!
  (:when (featurep! :editor multiple-cursors)
    :n  "s-d"   #'evil-multiedit-match-symbol-and-next
    :n  "s-D"   #'evil-multiedit-match-symbol-and-prev
    :v  "s-d"   #'evil-multiedit-match-and-next
    :v  "s-D"   #'evil-multiedit-match-and-prev
    :nv "s-C-d" #'evil-multiedit-restore

    (:after evil-multiedit :map evil-multiedit-state-map
      "s-d"    #'evil-multiedit-match-and-next
      "s-D"    #'evil-multiedit-match-and-prev
      [return] #'evil-multiedit-toggle-or-restrict-region)))


;;; git-timemachine

(map! :after git-timemachine :map git-timemachine-mode-map
  :n "C-p" #'git-timemachine-show-previous-revision
  :n "C-n" #'git-timemachine-show-next-revision

  :n "-" #'git-timemachine-show-previous-revision
  :n "+" #'git-timemachine-show-next-revision

  :n "("   #'git-timemachine-show-previous-revision
  :n ")"   #'git-timemachine-show-next-revision

  :n "[["  #'git-timemachine-show-previous-revision
  :n "]]"  #'git-timemachine-show-next-revision
  )


;;; org-journal

(map! :after org-journal
  (:map org-journal-mode-map
    :n "C-p" #'org-journal-previous-entry
    :n "C-n" #'org-journal-next-entry

    :n "-" #'org-journal-previous-entry
    :n "+" #'org-journal-next-entry

    :n "("   #'org-journal-previous-entry
    :n ")"   #'org-journal-next-entry

    :n "[["  #'org-journal-previous-entry
    :n "]]"  #'org-journal-next-entry
    ))


;;; with-editor

(map! :after with-editor
  (:map with-editor-mode-map
    "s-s" #'with-editor-finish
    "s-k" #'with-editor-cancel
    "s-w" #'with-editor-cancel))


;; ┏━┓┏━┓┏━╸   ┏┳┓┏━┓╺┳┓┏━╸
;; ┃ ┃┣┳┛┃╺┓╺━╸┃┃┃┃ ┃ ┃┃┣╸
;; ┗━┛╹┗╸┗━┛   ╹ ╹┗━┛╺┻┛┗━╸

(map!
  (:after org
    (:map +org-log-buffer-mode-map
      "s-s" #'org-ctrl-c-ctrl-c
      "s-k" #'org-kill-note-or-show-branches
      "s-w" #'org-kill-note-or-show-branches)

    (:map (org-mode-map org-agenda-mode-map)
      "s-r"           #'org-refile
      "s-R"           #'+org/refile-to-running-clock

      :n [return]     #'+org/dwim-at-point

      :n "H"          #'org-metadown
      :n "L"          #'org-metaup)

    (:map org-capture-mode-map
      "s-r" #'org-capture-refile
      "s-w" #'org-capture-kill
      "s-k" #'org-capture-kill
      "s-s" #'org-capture-finalize)

    (:map org-src-mode-map
      "s-k" #'org-edit-src-abort
      "s-s" #'org-edit-src-save
      "s-w" #'org-edit-src-exit

      (:leader
        :desc "Save file"   "fs"    #'org-edit-src-save)))

  (:after evil-org
    (:map +org-format-map
      ;; Basic char syntax:
      ;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Basic-Char-Syntax.html#Basic-Char-Syntax
      "b"   (org-emphasize! +org/bold ?*)
      "i"   (org-emphasize! +org/italic ?/)
      "m"   (org-emphasize! +org/monospace ?~)  ;; monospace/code
      "u"   (org-emphasize! +org/underline ?_)
      "v"   (org-emphasize! +org/verbose ?=)
      "s"   (org-emphasize! +org/strike-through ?+)
      "x"   (org-emphasize! +org/restore-format ? )
      "r"   #'org-roam-insert
      "R"   #'org-roam-insert-immediate
      "c"   #'org-cliplink
      "d"   #'org-download-yank
      "D"   #'org-download-clipboard
      "k"   #'org-insert-link
      "K"   #'+org/remove-link
      "n"   #'org-add-note
      )

    (:map evil-org-mode-map
      :n "C-i"    #'evil-jump-forward
      "s-e"       +org-format-map

      (:when IS-MAC
        "s-o"   #'+org/insert-item-below
        "s-O"   #'+org/insert-item-above)

      (:localleader
        :desc "Add note to the current entry"    "n"   #'org-add-note
        :desc "format"                           "f"   +org-format-map
        :desc "TODO"                             "t"   #'org-todo

        (:prefix ("d" . "date/deadline")
          "T" #'org-toggle-timestamp-type
          "i" #'org-time-stamp-inactive)))

  (:after evil-org-agenda
    (:map evil-org-agenda-mode-map
    :m "k"          #'org-agenda-previous-item
    :m "j"          #'org-agenda-next-item))))

;; Disable bindings for org-super-agenda headers
(after! org-super-agenda
  (setq org-super-agenda-header-map nil))


;; ╻  ┏━╸┏━┓╺┳┓┏━╸┏━┓
;; ┃  ┣╸ ┣━┫ ┃┃┣╸ ┣┳┛
;; ┗━╸┗━╸╹ ╹╺┻┛┗━╸╹┗╸

(map! :leader
  :desc "M-x"                         ":"         #'execute-extended-command
  :desc "Eval expression"             ";"         #'pp-eval-expression
  :desc "Show marks"                  "/"         #'counsel-evil-marks
  :desc "Switch to scratch buffer"    "X"         #'doom/switch-to-scratch-buffer
  :desc "Switch Project"              "RET"       #'projectile-switch-project
  :desc "Switch Workspace"            "ESC"       #'persp-switch
  :desc "Find file"                   "."         #'counsel-find-file
  :desc "Find file from here"         ">"         #'+default/find-file-under-here
  :desc "Search other project"        [S-return]  #'+default/search-other-project
  :desc "Find file in other project"  "S-SPC"     #'doom/find-file-in-other-project
  :desc "Toggle last popup"           "'"         #'+popup/toggle
  :desc "Ivy resume"                  "`"         (cond ((featurep! :completion ivy) #'ivy-resume)
                                                  ((featurep! :completion helm)    #'helm-resume))

      ;;; <leader> l --- language
  (:when (featurep! :config language)
    (:prefix ("l" . "language")
      :desc "Configure translate languages"    ","   #'+language/set-google-translate-languages
      :desc "Translate"                        "t"   #'google-translate-smooth-translate
      :desc "Translate any language"           "a"   #'+language/google-translate-smooth-translate-any
      :desc "Translate from source lang"       "s"   #'google-translate-at-point
      :desc "Translate from destination lang"  "d"   #'google-translate-at-point-reverse))

      ;;; <leader> b --- buffer
  (:prefix ("b" . "buffer")
    :desc "Kill buried buffers"         "K"   #'doom/kill-buried-buffers)

      ;;; <leader> f --- file
  (:prefix ("f" . "file")
    :desc "Find file in other project"  "o" #'doom/find-file-in-other-project
    :desc "Search in other project"     "O" #'+default/search-other-project
    :desc "Find file in private config" "," #'doom/find-file-in-private-config
    :desc "Browse private config"       "<" #'doom/open-private-config
    :desc "Find file in .dotfiles"      "." (λ! (+eduarbo-find-file dotfiles-dir))
    :desc "Search in .dotfiles"         ">" (λ! (+eduarbo-search-project dotfiles-dir))
    )

      ;;; <leader> g --- git
  (:prefix ("g" . "git")
    (:when (featurep! :tools magit)
      :desc "Timemachine for branch"    "T"   #'git-timemachine-switch-branch
      :desc "Magit diff staged"         "d"   #'magit-diff-buffer-file
      :desc "Magit diff"                "D"   #'magit-diff))

      ;;; <leader> n --- notes
  (:prefix ("n" . "notes")
    :desc "Search notes"              "S-SPC" #'+org/org-notes-search
    :desc "Org Roam capture"            "RET" #'org-roam-capture
    :desc "Find note"                   "SPC" #'org-roam-find-file
    :desc "Switch to buffer"            ","   #'org-roam-switch-to-buffer
    :desc "Org Roam Insert"             "i"   #'org-roam-insert
    :desc "Jump to index"               "I"   #'org-roam-jump-to-index
    :desc "Today's journal"             "j"   #'org-journal-new-entry
    :desc "Date journal"                "J"   #'org-journal-new-date-entry
    :desc "Daily Agenda"                "d"   #'eduarbo/daily-agenda
    :desc "Unscheduled Agenda"          "u"   #'eduarbo/unscheduled-agenda
    :desc "Search org agenda headlines" "A"   #'+org/org-agenda-headlines
    :desc "Search org notes headlines"  "S"   #'+org/org-notes-headlines
    :desc "Open project notes"          "p"   #'+org/find-notes-for-project
    :desc "Today journal"               "t"   #'org-journal-open-current-journal-file
    :desc "Todo list"                   "T"   #'org-todo-list)

      ;;; <leader> o --- open
  (:prefix ("o" . "open")
    :desc "Shell command"                 "s" #'async-shell-command
    :desc "Shell command in project root" "S" #'projectile-run-async-shell-command-in-root)

      ;;; <leader> TAB --- workspace
  (:prefix ("TAB" . "workspace")
    :desc "Kill this workspace"          "k" #'+workspace/delete)

      ;;; <leader> p --- project
  (:prefix ("p" . "project")
    :desc "Run cmd in project root"      "!" #'projectile-run-async-shell-command-in-root
    :desc "Discover projects"            "D" #'projectile-discover-projects-in-search-path
    :desc "Open project notes"           "n" #'+org/find-notes-for-project)

      ;;; <leader> t --- toggle
  (:prefix ("t" . "toggle")
    (:when (featurep! :lang org +roam)
      :desc "Org Roam"                   "r" #'org-roam)
    :desc "Read-only mode"               "R" #'read-only-mode
    :desc "Line numbers"                 "l" #'display-line-numbers-mode
    :desc "Global Line numbers"          "L" #'global-display-line-numbers-mode
    :desc "Visual fill column mode"      "v" #'visual-fill-column-mode
    :desc "Subword mode"                 "W" #'subword-mode
    :desc "Frame maximized"              "m" #'toggle-frame-maximized)

      ;;; <leader> w --- window
  (:prefix ("w" . "window")
    "o" #'eduarbo/window-enlargen
    "O" #'eduarbo/focused-window-enlargen
    :desc "Most recently used buffer"    "w" #'evil-window-mru))
