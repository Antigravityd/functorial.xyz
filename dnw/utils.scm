
;; Shameless "borrowing" of SXML conveniences from jakob.space and bendersteed.tech.
;; A few modifications and a few additions.

(define-module (dnw utils)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:use-module (haunt site)
  #:export
  (hyperlink
   image
   stylesheet
   script
   post-uri))

(define (hyperlink target text)
  `(a (@ (href ,target)) ,text))

(define* (image file-name #:optional description class)
  (let ((src (string-append "/assets/image/" file-name)))
    (if description
	(if class
            `(img (@ (src ,src) (alt ,description) (title ,description) (class ,class)))
	    `(img (@ (src ,src) (alt ,description) (title ,description))))
        (if class
	    `(img (@ (src ,src) (class ,class)))
	    `(img (@ (src ,src)))))))

(define (stylesheet file-name)
  `(link (@ (rel "stylesheet") (href ,(format #f "/assets/css/~a" file-name)))))

(define (script file-name)
  (let ((src (string-append "/assets/js/" file-name)))
    `(script (@ (src ,src)))))

(define (post-uri site post)
  (string-append "/posts/" (site-post-slug site post) ".html"))
