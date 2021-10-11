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

;;;; package.lisp

(in-package :nyxt)

(uiop:define-package :nx-freestance-handler
    (:use :common-lisp :nyxt)
  (:documentation "A redirector from mainstream websites to their privacy-supporting mirrors for the Nyxt browser.")
  (:export :*preferred-invidious-instance*
           :*preferred-teddit-instance*
           :*preferred-bibliogram-instance*
           :*preferred-scribe-instance*
           :*preferred-nitter-instance*
           :*freestance-handlers*
           :invidious-handler
           :teddit-handler
           :bibliogram-handler
           :scribe-handler
           :nitter-handler))
