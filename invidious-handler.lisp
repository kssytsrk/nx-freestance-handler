;;;; invidious-handler, a redirector from Youtube to Invidious for Nyxt browser
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

(in-package :invidious-handler)

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

(defparameter invidious-handler
  (url-dispatching-handler
   'invidious-dispatcher
   (match-host "www.youtube.com")
   (lambda (url)
     (if *preferred-invidious-instance*
         (quri:copy-uri url
                        :host *preferred-invidious-instance*)
         (quri:copy-uri url
                        :host (object-string (first (get-invidious-instances))))))))

(in-package :nyxt)

(define-command set-preferred-invidious-instance ()
  "Set the preferred invidious instance."
  (with-result (instance (read-from-minibuffer
                          (make-minibuffer
                           :input-prompt "Choose an instance"
                           :suggestion-function (invidious-handler::invidious-instance-suggestion-filter))))
    (setf invidious-handler:*preferred-invidious-instance* (invidious-handler::object-string instance))))
