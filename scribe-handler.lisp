;;;; freestance-handler, a redirector from mainstream websites to their
;;;; privacy-supporting mirrors for the Nyxt browser

;;;; This program is free software: you can redistribute it and/or modify
;;;; it under the terms of the GNU General Public License as published by
;;;; the Free Software Foundation, either version 3 of the License, or
;;;; (at your option) any later version.

;;;; This program is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.

;;;; You should have received a copy of the GNU General Public License
;;;; along with this program. If not, see <https://www.gnu.org/licenses/>.

;;;; scribe-handler.lisp

(in-package :nx-freestance-handler)

(defvar *preferred-scribe-instance* nil)

(defun scribe-handler (request-data)
  (let ((url (url request-data)))
    (setf (url request-data)
          ;; I think this might be the problem line
          (if (search "medium.com" (quri:uri-host url))
              (progn
                (setf (quri:uri-host url) (or *preferred-scribe-instance*
					      "scribe.rip"))
                (log:info "Switching to Scribe: ~s" (render-url url))
                url)
              url)))
  request-data)

#+nyxt-2
(in-package :nyxt)

#+nyxt-2
(define-command set-preferred-scribe-instance ()
  "Set the preferred Scribe instance."
  (let ((instance (prompt-minibuffer
                   :input-prompt "Input the URL of the instance"
                   :suggestion-function (history-suggestion-filter
                                      :prefix-urls (list (object-string
                                                          (url (current-buffer))))))))
    (setf nx-freestance-handler:*preferred-scribe-instance* instance)))

#+nyxt-3
(define-command set-preferred-scribe-instance ()
  "Set the preferred Scribe instance."
  (let ((instance (prompt
                   :prompt "Input the URL of the instance"
                   :sources (list (make-instance 'prompter:raw-source)
                                  (make-instance 'nyxt/history-mode:history-all-source)))))
    (setf nx-freestance-handler:*preferred-scribe-instance* instance)))
