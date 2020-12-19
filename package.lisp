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
  (:documentation "A redirector from mainstream websites to their privacy-supporting mirrors for the Nyxt browser.

Invidious is an alternative front-end to Youtube that uses copylefted libre software and respects user's privacy.

To turn the handler on, add something like this to your init file:
\"(asdf:load-system :nx-freestance-handler)

  (define-configuration buffer
    ((request-resource-hook
      (reduce #'hooks:add-hook
              (list nx-freestance-handler:invidious-handler)
              :initial-value %slot-default))))\"

By default, this handler redirects from youtube.com to the healthiest (i.e, with best uptime) instance available, but if you prefer a particular one, it can be set with SET-PREFERRED-INVIDIOUS-INSTANCE Nyxt command, or in your init file with `(setf nx-freestance-handler:*preferred-invidious-instance* \"example.org\")`.")
  (:export :*preferred-invidious-instance*
           :invidious-handler))
