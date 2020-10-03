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

;;;; invidious-handler.asd

(asdf:defsystem :invidious-handler
  :serial t
  :version "1.0.0"
  :description "A redirector from Youtube to Invidious."
  :author "kssytsrk"
  :license "GNU General Public License v3.0"
  :depends-on (:nyxt
               :dexador
               :cl-json)
  :components ((:file "package")
               (:file "invidious-handler")))
