# invidious-handler

invidious-handler is a simple redirector from Youtube to Invidious for the [Nyxt browser](https://github.com/atlas-engineer/nyxt). The code was inspired by [this issue](https://github.com/atlas-engineer/nyxt/issues/930).

[Invidious](https://github.com/iv-org/invidious) is an alternative front-end to Youtube that uses copylefted libre software and respects user's privacy.

## Installation

Clone this repository to ~/common-lisp with:

```bash
$ git clone https://github.com/kssytsrk/invidious-handler
```

## Usage

To turn the handler on, add something like this to your Nyxt init.lisp file:

```common-lisp
(asdf:load-system :invidious-handler)

(define-configuration buffer
    ((request-resource-hook
      (reduce #'hooks:add-hook
              (list invidious-handler:invidious-handler)
              :initial-value %slot-default))))
```

By default, this handler redirects from youtube.com to the healthiest (i.e, with best uptime) instance available. If you prefer a particular one, it can be set with SET-PREFERRED-INVIDIOUS-INSTANCE Nyxt command, or in your init file with `(setf invidious-handler:*preferred-invidious-instance* "example.org")` (obviously, replace "example.org" with a real instance's url).

## Notes
All ideas, suggestions and bugreports are welcome in the "issues" section. Don't hesitate to open an issue if something's not working.
