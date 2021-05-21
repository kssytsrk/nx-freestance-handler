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

(defun bibliogram-handler (request-data)
  (let ((url (url request-data)))
    (setf (url request-data)
          (if (search "instagram.com" (quri:uri-host url))
              (progn
                (setf (quri:uri-host url) (or *preferred-bibliogram-instance*
					      "bibliogram.art"))
		(if (and (< 0 (length (quri:uri-path url)))
			 (not (str:starts-with? "/p/" (quri:uri-path url))))
		    (setf (quri:uri-path url)
			  (concatenate 'string "/u" (quri:uri-path url))))
                (log:info "Switching to Bibliogram: ~s" (render-url url))
                url)
              url)))
  request-data)

(in-package :nyxt)

(define-command set-preferred-bibliogram-instance ()
  "Set the preferred Bibliogram instance."
  (let ((instance (prompt-minibuffer
                   :input-prompt "Input the URL of the instance"
                   :suggestion-function (history-suggestion-filter
                                      :prefix-urls (list (object-string
                                                          (url (current-buffer))))))))
    (setf nx-freestance-handler:*preferred-bibliogram-instance* instance)))
