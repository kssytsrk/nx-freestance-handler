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

;;;; nitter-handler.lisp

(in-package :nx-freestance-handler)

(defvar *preferred-nitter-instance* nil)

(defparameter nitter-handler
  (url-dispatching-handler
   'nitter-dispatcher
   (match-host "twitter.com")
   (lambda (url)
     (if *preferred-nitter-instance*
         (quri:copy-uri url
                        :host *preferred-nitter-instance*)
         (quri:copy-uri url
                        :host "nitter.net")))))

(in-package :nyxt)

(define-command set-preferred-nitter-instance ()
  "Set the preferred Nitter instance."
  (let ((instance (prompt-minibuffer
                   :input-prompt "Input the URL of the instance"
                   :suggestion-function (history-suggestion-filter
                                      :prefix-urls (list (object-string
                                                          (url (current-buffer))))))))
    (setf nx-freestance-handler:*preferred-nitter-instance* instance)))
