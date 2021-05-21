;;;; freestance-handler, a redirector from mainstream websites to their
;;;; privacy-supporting mirrors for the Nyxt browser
;;;; Copyright (C) 2020 kssytsrk

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

;;;; invidious-handler.lisp

(in-package :nx-freestance-handler)

(defstruct invidious-instance
  (name)
  (health))

(defmethod object-string ((invidious-instance invidious-instance))
  (invidious-instance-name invidious-instance))

(defmethod object-display ((invidious-instance invidious-instance))
  (format nil
          "~a (health: ~:[unknown~;~:*~a~])"
          (invidious-instance-name invidious-instance)
          (invidious-instance-health invidious-instance)))

(defun get-invidious-instances ()
  (mapcar #'(lambda (json)
              (make-invidious-instance :name (first json)
                                       :health (rest
                                                (assoc ':ratio
                                                       (rest
                                                        (assoc ':weekly-ratio
                                                               (rest
                                                                (assoc ':monitor
                                                                       (first
                                                                        (rest json))))))))))
          (cl-json:with-decoder-simple-list-semantics
              (cl-json:decode-json-from-string
               (dex:get "https://instances.invidio.us/instances.json?sort_by=health")))))

(defun invidious-instance-suggestion-filter ()
  (let* ((instances (get-invidious-instances)))
    (lambda (minibuffer)
      (fuzzy-match (input-buffer minibuffer) instances))))

(defvar *preferred-invidious-instance* nil)

(defun invidious-handler (request-data)
 (let ((url (url request-data)))
    (setf (url request-data)
          (if (or (search "youtube.com" (quri:uri-host url))
		  (search "youtu.be"    (quri:uri-host url)))
              (progn
                (setf (quri:uri-host url)
		      (or *preferred-invidious-instance*
			  (object-string (first (get-invidious-instances)))))
                (log:info "Switching to Invidious: ~s" (render-url url))
                url)
              url)))
  request-data)

(in-package :nyxt)

(define-command set-preferred-invidious-instance ()
  "Set the preferred invidious instance."
  (let ((instance (prompt-minibuffer
                   :input-prompt "Choose an instance"
                   :suggestion-function (nx-freestance-handler::invidious-instance-suggestion-filter))))
    (setf nx-freestance-handler:*preferred-invidious-instance* (nx-freestance-handler::object-string instance))))
