# nx-freestance-handler

nx-freestance-handler is a redirector from mainstream websites to their privacy-supporting mirrors for the [Nyxt browser](https://github.com/atlas-engineer/nyxt). The code was inspired by [this issue](https://github.com/atlas-engineer/nyxt/issues/930). 

It is currently able to redirect from Youtube to [Invidious](https://github.com/iv-org/invidious), from Reddit to [Teddit](https://codeberg.org/teddit/teddit), from Instagram to [Bibliogram](https://sr.ht/~cadence/bibliogram/), and from Twitter to [Nitter](https://github.com/zedeus/nitter).

## Installation

Clone this repository to `~/common-lisp` with:

```bash
$ git clone https://github.com/kssytsrk/nx-freestance-handler
```

## Usage

To turn the handler on, add something like this to your Nyxt `init.lisp` file:

```common-lisp
(defvar *my-request-resource-handlers* '())

(load-after-system :nx-freestance-handler
                   (nyxt-init-file "freestance.lisp"))

(define-configuration buffer
    ((request-resource-hook
      (reduce #'hooks:add-hook
              *my-request-resource-handlers*
              :initial-value %slot-default))))
```

Then, create `freestance.lisp` file in `~/.config/nyxt` with these contents:

```common-lisp
;; to add all handlers/redirectors (youtube to invidious, reddit to teddit,
;; instagram to bibliogram, twitter to nitter)
(setq *my-request-resource-handlers*
      (nconc *my-request-resource-handlers*
             nx-freestance-handler:*freestance-handlers*))

;; alternatively, you may add each separately
;; (push nx-freestance-handler:invidious-handler *my-request-resource-handlers*)
;; (push nx-freestance-handler:nitter-handler *my-request-resource-handlers*)
;; (push nx-freestance-handler:bibliogram-handler *my-request-resource-handlers*)
;; (push nx-freestance-handler:teddit-handler *my-request-resource-handlers*)

;; to set your preferred instance, either invoke SET-PREFERRED-[name of website]-INSTANCE
;; command in Nyxt (its effect last until you close Nyxt), or write something like this:
;; (setf nx-freestance-handler:*preferred-invidious-instance* "https://invidious.snopyta.org")
```

By default, for Invidious this handler redirects from youtube.com to the healthiest (i.e, with best uptime) instance available. For Teddit it redirects to the official teddit.net instance, for Nitter - to nitter.net and for Bibliogram - to bibliogram.art.

FYI, right now direct links to posts on Instagram are not redirected, as Bibliogram [doesn't seem to support](https://todo.sr.ht/~cadence/bibliogram-issues/26) them (yet?).

## Notes

All ideas, suggestions and bugreports are welcome in the "issues" section. Don't hesitate to open an issue if something's not working.
