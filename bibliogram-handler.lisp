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

;;;; bibliogram-handler.lisp

(in-package :nx-freestance-handler)

(defvar *preferred-bibliogram-instance* nil)

(defparameter bibliogram-handler
  (url-dispatching-handler
   'bibliogram-dispatcher
   (match-host "www.instagram.com" "instagram.com")
   (lambda (url)
     (if (str:starts-with? "/p/" (quri:uri-path url))
         ;; view of posts disectly in bibliogram is broken:
         ;; see https://todo.sr.ht/~cadence/bibliogram-issues/26
         url
         (quri:copy-uri url
			:host (concatenate 'string
                                           (or *preferred-bibliogram-instance*
                                               "bibliogram.art")
                                           ;; bibliogram seems to have the "/u/"
                                           ;; scheme for users, while instagram
                                           ;; has none, so this has to be added
                                           (unless (<= (length (quri:uri-path url)) 1)
                                               "/u")))))))

(in-package :nyxt)

(define-command set-preferred-bibliogram-instance ()
  "Set the preferred Bibliogram instance."
  (let ((instance (prompt-minibuffer
                   :input-prompt "Input the URL of the instance"
                   :suggestion-function (history-suggestion-filter
                                      :prefix-urls (list (object-string
                                                          (url (current-buffer))))))))
    (setf nx-freestance-handler:*preferred-bibliogram-instance* instance)))
